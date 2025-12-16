package com.example.harassment.repository;

import com.example.harassment.model.ChatMessage;
import com.example.harassment.model.Consultation;

import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

/**
 * メモリ上で相談データを保持する簡易リポジトリ
 * - Singleton（getInstance）
 * - 相談登録時に accessKey を自動発行
 * - チャット appendChat / addChat
 * - 評価 saveEvaluation / updateEvaluation
 * - ステータス更新 setStatus / updateStatus
 * - 検索 search（氏名部分一致 / 日付FROM-TO / ソート）
 */
public class MemoryConsultationRepository {

    // ===== Singleton =====
    private static final MemoryConsultationRepository INSTANCE = new MemoryConsultationRepository();

    public static MemoryConsultationRepository getInstance() {
        return INSTANCE;
    }

    // ===== データ保持 =====
    private final Map<Integer, Consultation> store = new LinkedHashMap<>();
    private final AtomicInteger seq = new AtomicInteger(1);

    private MemoryConsultationRepository() {}

    // ===== 相談 登録/更新 =====

    /**
     * 新規保存（ID採番、accessKey自動付与）
     */
    public synchronized Consultation save(Consultation c) {
        if (c == null) return null;

        if (c.getId() <= 0) {
            c.setId(seq.getAndIncrement());
        }

        if (c.getAccessKey() == null || c.getAccessKey().trim().isEmpty()) {
            c.setAccessKey(generateKey());
        }

        // status未指定なら NEW
        if (c.getStatus() == null || c.getStatus().trim().isEmpty()) {
            c.setStatus("NEW");
        }

        // chatMessages null対策
        if (c.getChatMessages() == null) {
            c.setChatMessages(new ArrayList<>());
        }

        store.put(c.getId(), c);
        return c;
    }

    /**
     * 既存IDを上書き更新（updateが欲しいサーブレット対策）
     */
    public synchronized void update(Consultation c) {
        if (c == null) return;
        if (c.getId() <= 0) return;
        store.put(c.getId(), c);
    }

    /**
     * 互換：古いコードで repo.save(c) 以外を呼んでいる場合の受け口
     */
    public synchronized void saveOrUpdate(Consultation c) {
        if (c == null) return;
        if (c.getId() <= 0 || !store.containsKey(c.getId())) {
            save(c);
        } else {
            update(c);
        }
    }

    // ===== 取得系 =====

    public synchronized List<Consultation> findAll() {
        return new ArrayList<>(store.values());
    }

    public synchronized Consultation findById(int id) {
        return store.get(id);
    }

    /**
     * 相談者マイページ用：ID + accessKey で本人確認
     */
    public synchronized Consultation findByIdAndKey(int id, String key) {
        Consultation c = store.get(id);
        if (c == null) return null;
        if (c.getAccessKey() == null) return null;

        String k = (key != null) ? key.trim() : "";
        return c.getAccessKey().equals(k) ? c : null;
    }

    // ===== 管理者：確認チェック =====

    public synchronized void setAdminChecked(int id, boolean checked) {
        Consultation c = store.get(id);
        if (c == null) return;
        c.setAdminChecked(checked);
    }

    // ===== ステータス更新（互換で複数名用意） =====

    public synchronized void setStatus(int id, String status) {
        Consultation c = store.get(id);
        if (c == null) return;
        c.setStatus(normStatus(status));
    }

    public synchronized void updateStatus(int id, String status) {
        setStatus(id, status);
    }

    // ===== 管理者：対応内容保存（下書き/確定） =====

    /**
     * mode: "draft" or "final"
     */
    public synchronized void saveFollowup(int id, String mode, String text) {
        Consultation c = store.get(id);
        if (c == null) return;

        String t = (text != null) ? text : "";

        if ("final".equalsIgnoreCase(mode)) {
            c.setFollowUpAction(t);
            // 確定したら対応中→完了など運用次第。ここでは確定で「対応中」に倒す
            if (!"DONE".equals(c.getStatus())) {
                c.setStatus("IN_PROGRESS");
            }
        } else {
            c.setFollowUpDraft(t);
        }
    }

    // ===== チャット =====

    /**
     * JSP/Servlet側が repo.appendChat を呼ぶ想定に合わせる
     * senderRole: "ADMIN" / "MASTER" / "REPORTER"
     */
    public synchronized void appendChat(int id, String senderRole, String message) {
        Consultation c = store.get(id);
        if (c == null) return;

        String msg = (message != null) ? message.trim() : "";
        if (msg.isEmpty()) return;

        if (c.getChatMessages() == null) {
            c.setChatMessages(new ArrayList<>());
        }

        ChatMessage m = new ChatMessage(
                normRole(senderRole),
                msg,
                LocalDateTime.now()
        );
        c.getChatMessages().add(m);
    }

    /**
     * 互換：repo.addChat(...) を呼ぶコード対策
     */
    public synchronized void addChat(int id, String senderRole, String message) {
        appendChat(id, senderRole, message);
    }

    // ===== 評価（相談者の最終評価） =====

    /**
     * rating: 1〜5（それ以外は丸める）
     */
    public synchronized void saveEvaluation(int id, int rating, String feedback) {
        Consultation c = store.get(id);
        if (c == null) return;

        int r = rating;
        if (r < 1) r = 1;
        if (r > 5) r = 5;

        c.setReporterRating(r);
        c.setReporterFeedback(feedback != null ? feedback : "");
        c.setReporterRatedAt(LocalDateTime.now());

        // 評価が入るのは基本 DONE 後なので、未DONEならDONEへ寄せる（運用に合わせて）
        if (c.getStatus() == null || c.getStatus().trim().isEmpty()) {
            c.setStatus("DONE");
        }
    }

    /**
     * 互換：updateEvaluation と呼ばれても動くように
     */
    public synchronized void updateEvaluation(int id, int rating, String feedback) {
        saveEvaluation(id, rating, feedback);
    }

    // ===== 一覧検索（管理/マスター共通） =====
    // nameLike: 氏名部分一致（空なら無条件）
    // from/to : sheetDate 文字列比較（YYYY-MM-DD 想定、空なら無視）
    // sort    : "mental_desc" を想定（しんどさ高い順）
    public synchronized List<Consultation> search(String nameLike, String from, String to, String sort) {

        String n = (nameLike != null) ? nameLike.trim() : "";
        String f = (from != null) ? from.trim() : "";
        String t = (to != null) ? to.trim() : "";
        String s = (sort != null) ? sort.trim() : "";

        List<Consultation> list = new ArrayList<>(store.values());

        // 氏名部分一致
        if (!n.isEmpty()) {
            list = list.stream()
                    .filter(c -> {
                        String name = c.getConsultantName();
                        if (name == null) name = "";
                        return name.contains(n);
                    })
                    .collect(Collectors.toList());
        }

        // 日付フィルタ（sheetDateが YYYY-MM-DD で入る前提。入ってないものは素通し）
        if (!f.isEmpty()) {
            list = list.stream()
                    .filter(c -> {
                        String d = safe(c.getSheetDate());
                        if (d.isEmpty()) return true;
                        return d.compareTo(f) >= 0;
                    })
                    .collect(Collectors.toList());
        }
        if (!t.isEmpty()) {
            list = list.stream()
                    .filter(c -> {
                        String d = safe(c.getSheetDate());
                        if (d.isEmpty()) return true;
                        return d.compareTo(t) <= 0;
                    })
                    .collect(Collectors.toList());
        }

        // ソート
        if ("mental_desc".equalsIgnoreCase(s) || "MENTAL_DESC".equalsIgnoreCase(s)) {
            list.sort(Comparator.comparingInt(Consultation::getMentalScale).reversed());
        } else if ("id_desc".equalsIgnoreCase(s)) {
            list.sort(Comparator.comparingInt(Consultation::getId).reversed());
        } else {
            // デフォルト：ID昇順（登録順）
            list.sort(Comparator.comparingInt(Consultation::getId));
        }

        return list;
    }

    // ===== ユーティリティ =====

    private String safe(String s) {
        return s == null ? "" : s.trim();
    }

    private String normRole(String role) {
        String r = safe(role).toUpperCase();
        if (r.equals("ADMIN") || r.equals("MASTER") || r.equals("REPORTER")) return r;
        // それ以外は REPORTER 扱いに寄せる（落ちないのが最優先）
        return "REPORTER";
    }

    private String normStatus(String status) {
        String st = safe(status).toUpperCase();
        switch (st) {
            case "NEW":
            case "CHECKING":
            case "IN_PROGRESS":
            case "DONE":
                return st;
            default:
                // 変な値でもnullにしない（JSPラベル表示で困らないように）
                return st.isEmpty() ? "NEW" : st;
        }
    }

    private String generateKey() {
        // 相談者のマイページアクセス用の簡易キー（推測されにくい長さ）
        String chars = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789";
        Random r = new Random();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 16; i++) {
            sb.append(chars.charAt(r.nextInt(chars.length())));
        }
        return sb.toString();
    }
        /**
     * 互換：複数回の対応記録を「追記」する簡易版。
     * 本格的に FollowUpRecord を持たせる前の "止血" 実装。
     *
     * actorRole: "ADMIN" など
     * category : "1st", "2nd", "産業医" 等（自由）
     * text     : 本文
     */
        public synchronized void addFollowUp(int id, String actorRole, String category, String text) {
            Consultation c = store.get(id);
            if (c == null) return;
    
            String t = (text != null) ? text.trim() : "";
            if (t.isEmpty()) return;
    
            String header = "【" + normRole(actorRole) + " / " + safe(category) + " / " +
                    LocalDateTime.now().toString().replace('T', ' ') + "】\n";
    
            String current = c.getFollowUpDraft();
            if (current == null) current = "";
    
            // 下書き欄へ追記（履歴の代用）
            c.setFollowUpDraft(current + (current.isEmpty() ? "" : "\n\n") + header + t);
    
            // 1件でも対応が入ったら対応中に寄せる
            if (!"DONE".equals(c.getStatus())) {
                c.setStatus("IN_PROGRESS");
            }
        }
    
}
