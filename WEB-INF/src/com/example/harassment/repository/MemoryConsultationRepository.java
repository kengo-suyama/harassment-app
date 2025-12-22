package com.example.harassment.repository;

import com.example.harassment.model.ChatMessage;
import com.example.harassment.model.Consultation;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

/**
 * メモリ上で相談データを保持する簡易リポジトリ
 * - Singleton（getInstance）
 * - 相談登録時に accessKey を自動発行（衝突チェックあり）
 * - チャット appendChat / addChat
 * - 評価 saveEvaluation / updateEvaluation
 * - ステータス更新 setStatus / updateStatus
 * - 検索 search（氏名部分一致 / 日付FROM-TO / ソート）
 * - clearAll（全件削除：必要な場合のみ使用）
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

    // accessKey生成用（衝突しにくい）
    private static final String KEY_CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789";
    private static final int KEY_LEN = 16;
    private final SecureRandom random = new SecureRandom();

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

        if (isBlank(c.getAccessKey())) {
            c.setAccessKey(generateUniqueKey());
        }

        // status未指定なら NEW
        if (isBlank(c.getStatus())) {
            c.setStatus("NEW");
        } else {
            c.setStatus(normStatus(c.getStatus()));
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

        // 既存がなければ save と同等に扱う（落ちない優先）
        if (!store.containsKey(c.getId())) {
            save(c);
            return;
        }

        // status正規化
        if (!isBlank(c.getStatus())) {
            c.setStatus(normStatus(c.getStatus()));
        } else {
            c.setStatus("NEW");
        }

        // chatMessages null対策
        if (c.getChatMessages() == null) {
            c.setChatMessages(new ArrayList<>());
        }

        // accessKey空なら付与
        if (isBlank(c.getAccessKey())) {
            c.setAccessKey(generateUniqueKey());
        }

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

        String k = safe(key);
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
            // 確定したら運用上「対応中」へ（DONEなら維持）
            if (!"DONE".equals(c.getStatus())) {
                c.setStatus("IN_PROGRESS");
            }
        } else {
            c.setFollowUpDraft(t);
        }
    }

    /**
     * 互換：複数回の対応記録を「追記」する簡易版（止血実装）
     * actorRole: "ADMIN" など
     * category : "1st", "2nd", "産業医" 等（自由）
     */
    public synchronized void addFollowUp(int id, String actorRole, String category, String text) {
        Consultation c = store.get(id);
        if (c == null) return;

        String t = safe(text);
        if (t.isEmpty()) return;

        String header = "【" + normRole(actorRole) + " / " + safe(category) + " / "
                + LocalDateTime.now().toString().replace('T', ' ') + "】\n";

        String current = c.getFollowUpDraft();
        if (current == null) current = "";

        c.setFollowUpDraft(current + (current.isEmpty() ? "" : "\n\n") + header + t);

        if (!"DONE".equals(c.getStatus())) {
            c.setStatus("IN_PROGRESS");
        }
    }

    // ===== チャット =====

    /**
     * senderRole: "ADMIN" / "MASTER" / "REPORTER"
     */
    public synchronized void appendChat(int id, String senderRole, String message) {
        Consultation c = store.get(id);
        if (c == null) return;

        String msg = safe(message);
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

        // 運用：評価が入るなら完了寄せ（必要なければここは消してOK）
        if (isBlank(c.getStatus())) {
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
    // sort    : "mental_desc" / "id_desc" / default(id_asc)
    public synchronized List<Consultation> search(String nameLike, String from, String to, String sort) {

        String n = safe(nameLike);
        String f = safe(from);
        String t = safe(to);
        String s = safe(sort);

        List<Consultation> list = new ArrayList<>(store.values());

        // 氏名部分一致
        if (!n.isEmpty()) {
            list = list.stream()
                    .filter(c -> safe(c.getConsultantName()).contains(n))
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
        if ("mental_desc".equalsIgnoreCase(s)) {
            list.sort(Comparator.comparingInt(Consultation::getMentalScale).reversed());
        } else if ("id_desc".equalsIgnoreCase(s)) {
            list.sort(Comparator.comparingInt(Consultation::getId).reversed());
        } else {
            list.sort(Comparator.comparingInt(Consultation::getId)); // デフォルト：ID昇順
        }

        return list;
    }

    // ===== 便利：全件クリア（必要なら） =====
    public synchronized void clearAll() {
        store.clear();
        seq.set(1);
    }

    // ===== ユーティリティ =====

    private String safe(String s) {
        return (s == null) ? "" : s.trim();
    }

    private boolean isBlank(String s) {
        return safe(s).isEmpty();
    }

    private String normRole(String role) {
        String r = safe(role).toUpperCase();
        if (r.equals("ADMIN") || r.equals("MASTER") || r.equals("REPORTER")) return r;
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
                return st.isEmpty() ? "NEW" : st; // 変な値でもnullにしない
        }
    }

    private String generateUniqueKey() {
        // 念のため衝突チェック（メモリ上なので軽い）
        for (int tries = 0; tries < 1000; tries++) {
            String k = generateKeyOnce();
            boolean exists = store.values().stream()
                    .anyMatch(c -> k.equals(c.getAccessKey()));
            if (!exists) return k;
        }
        // ここに来ることはほぼないが、最悪UUIDで逃げる
        return UUID.randomUUID().toString().replace("-", "");
    }

    private String generateKeyOnce() {
        StringBuilder sb = new StringBuilder(KEY_LEN);
        for (int i = 0; i < KEY_LEN; i++) {
            sb.append(KEY_CHARS.charAt(random.nextInt(KEY_CHARS.length())));
        }
        return sb.toString();
    }
}
