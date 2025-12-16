package com.example.harassment.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * ハラスメント相談シート 1 件分を表すモデルクラス
 */
public class Consultation {

    // ====== 連番ID ======
    private int id;

    // ====== 相談シートの主な項目 ======
    private String sheetDate;                // シート記入日（文字列でOK）
    private String consultantName;           // 相談者氏名（任意）
    private String summary;                  // 相談の概要

    // 発生後の状況
    // reportedExists: "NONE" / "SOMEONE" / "YES" / "NO" など揺れても表示できるようにする
    private String reportedExists;           // 「相談済み」などのコード
    private String reportedPerson;           // 相談相手
    private String reportedAt;               // 相談日時
    private String followUp;                 // その後の対応（相談者側の自己記入）

    // 心身の状態
    private int mentalScale;                 // 1〜10
    private String mentalDetail;             // 心身の状態の詳細

    // 今後の希望（カンマ区切りで複数コードを保存）
    private String futureRequest;            // コード列（カンマ区切り）
    private String futureRequestOtherDetail; // その他の具体的な希望

    // 共有の可否
    // sharePermission: "ALL_OK" / "LIMITED" / "NO_SHARE"
    private String sharePermission;          // 共有範囲コード
    private String shareLimitedTargets;      // 限定共有の相手（テキスト）

    // 管理者対応欄
    private boolean adminChecked;            // 管理者が確認済みか
    private String followUpDraft;            // 管理者が編集中の対応内容（下書き）
    private String followUpAction;           // 確定した対応内容（マスターに見せる用）

    // 相談の進行状況
    // NEW / CHECKING / IN_PROGRESS / DONE
    private String status;

    // ====== 相談者マイページ用（アクセスキー） ======
    private String accessKey;

    // ====== チャット（相談者↔管理者/マスター） ======
    private List<ChatMessage> chatMessages = new ArrayList<>();

    // ====== 相談者の最終評価 ======
    // DONE のときだけ入力する想定
    private int reporterRating;              // 1〜5（未評価は 0）
    private String reporterFeedback;         // 自由記述
    private LocalDateTime reporterRatedAt;   // 評価日時
        // 相談者の満足度（別機能：SatisfactionSubmitServlet用）
        private int satisfactionScore;                 // 1～5など
        private String satisfactionComment;            // コメント
        private java.time.LocalDateTime satisfactionAt; // 評価日時
    
    // ====== 通常の getter / setter ======

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getSheetDate() { return sheetDate; }
    public void setSheetDate(String sheetDate) { this.sheetDate = sheetDate; }

    public String getConsultantName() { return consultantName; }
    public void setConsultantName(String consultantName) { this.consultantName = consultantName; }

    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }

    public String getReportedExists() { return reportedExists; }
    public void setReportedExists(String reportedExists) { this.reportedExists = reportedExists; }

    public String getReportedPerson() { return reportedPerson; }
    public void setReportedPerson(String reportedPerson) { this.reportedPerson = reportedPerson; }

    public String getReportedAt() { return reportedAt; }
    public void setReportedAt(String reportedAt) { this.reportedAt = reportedAt; }

    public String getFollowUp() { return followUp; }
    public void setFollowUp(String followUp) { this.followUp = followUp; }

    public int getMentalScale() { return mentalScale; }
    public void setMentalScale(int mentalScale) { this.mentalScale = mentalScale; }

    public String getMentalDetail() { return mentalDetail; }
    public void setMentalDetail(String mentalDetail) { this.mentalDetail = mentalDetail; }

    public String getFutureRequest() { return futureRequest; }
    public void setFutureRequest(String futureRequest) { this.futureRequest = futureRequest; }

    public String getFutureRequestOtherDetail() { return futureRequestOtherDetail; }
    public void setFutureRequestOtherDetail(String futureRequestOtherDetail) {
        this.futureRequestOtherDetail = futureRequestOtherDetail;
    }

    public String getSharePermission() { return sharePermission; }
    public void setSharePermission(String sharePermission) { this.sharePermission = sharePermission; }

    public String getShareLimitedTargets() { return shareLimitedTargets; }
    public void setShareLimitedTargets(String shareLimitedTargets) { this.shareLimitedTargets = shareLimitedTargets; }

    public boolean isAdminChecked() { return adminChecked; }
    public void setAdminChecked(boolean adminChecked) { this.adminChecked = adminChecked; }

    public String getFollowUpDraft() { return followUpDraft; }
    public void setFollowUpDraft(String followUpDraft) { this.followUpDraft = followUpDraft; }

    public String getFollowUpAction() { return followUpAction; }
    public void setFollowUpAction(String followUpAction) { this.followUpAction = followUpAction; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getAccessKey() { return accessKey; }
    public void setAccessKey(String accessKey) { this.accessKey = accessKey; }

    // ====== JSPが呼んでいる名前に合わせた getter 群 ======

    /**
     * consult/my.jsp が呼んでいる想定: c.getChatMessages()
     */
    public List<ChatMessage> getChatMessages() {
        if (chatMessages == null) chatMessages = new ArrayList<>();
        return chatMessages;
    }

    /**
     * 既存コード互換: c.getChats()
     * （Repositoryや他JSPが getChats() を使っていても壊れないように）
     */
    public List<ChatMessage> getChats() {
        return getChatMessages();
    }

    public void setChatMessages(List<ChatMessage> chatMessages) {
        this.chatMessages = (chatMessages != null) ? chatMessages : new ArrayList<>();
    }

    // ====== 評価（JSPが呼んでいるメソッド） ======

    public boolean isRated() {
        return reporterRating > 0 || reporterRatedAt != null
                || (reporterFeedback != null && !reporterFeedback.trim().isEmpty());
    }

    public int getReporterRating() { return reporterRating; }
    public void setReporterRating(int reporterRating) { this.reporterRating = reporterRating; }

    public String getReporterFeedback() { return reporterFeedback; }
    public void setReporterFeedback(String reporterFeedback) { this.reporterFeedback = reporterFeedback; }

    public LocalDateTime getReporterRatedAt() { return reporterRatedAt; }
    public void setReporterRatedAt(LocalDateTime reporterRatedAt) { this.reporterRatedAt = reporterRatedAt; }

    // ====== 画面表示用ラベル ======

    public String getStatusLabel() {
        if (status == null || status.trim().isEmpty()) return "";
        switch (status) {
            case "NEW": return "未対応";
            case "CHECKING": return "確認中";
            case "IN_PROGRESS": return "対応中";
            case "DONE": return "対応完了";
            default: return status;
        }
    }

    public String getReportedExistsLabel() {
        if (reportedExists == null || reportedExists.isEmpty()) return "";
        switch (reportedExists) {
            // 新コード
            case "NONE": return "まだ誰にも相談していない";
            case "SOMEONE": return "すでに誰かに相談している";
            // 旧コード（YES/NO）
            case "YES": return "すでに誰かに相談している";
            case "NO": return "まだ誰にも相談していない";
            default: return reportedExists;
        }
    }

    public String getSharePermissionLabel() {
        if (sharePermission == null || sharePermission.isEmpty()) return "";
        switch (sharePermission) {
            case "ALL_OK": return "必要に応じて関係者に共有してよい";
            case "LIMITED": return "共有範囲を限定してほしい";
            case "NO_SHARE": return "相談内容は共有してほしくない";
            default: return sharePermission;
        }
    }

    public List<String> getFutureRequestLabelList() {
        List<String> result = new ArrayList<>();
        if (futureRequest == null || futureRequest.trim().isEmpty()) return result;

        List<String> codes = Arrays.stream(futureRequest.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .collect(Collectors.toList());

        for (String code : codes) {
            switch (code) {
                case "LISTEN":
                case "LISTEN_ONLY":
                case "ONLY_LISTEN":
                    result.add("まず話を聞いてほしい");
                    break;

                case "WORK_CHANGE":
                    result.add("配置転換・業務内容を調整してほしい");
                    break;

                case "ENV_IMPROVE":
                    result.add("職場環境や人間関係を改善してほしい");
                    break;

                case "FORMAL_PROCEDURE":
                    result.add("正式な申し立てや調査を進めてほしい");
                    break;

                case "MENTAL_SUPPORT":
                    result.add("産業医・カウンセラーなど専門家につなげてほしい");
                    break;

                case "ADVISE":
                    result.add("助言やアドバイスがほしい");
                    break;

                case "ARRANGE_MEETING":
                    result.add("面談の場を調整してほしい");
                    break;

                case "KEEP_RECORD":
                    result.add("記録として残しておいてほしい");
                    break;

                case "NOTHING":
                    result.add("特に希望はない");
                    break;

                case "OTHER":
                    result.add("その他の希望");
                    break;

                default:
                    result.add(code);
                    break;
            }
        }
        return result;
    }

    public String getFutureRequestLabelString() {
        List<String> labels = getFutureRequestLabelList();
        return labels.isEmpty() ? "" : String.join("、", labels);
    }

    public String getMentalScaleLabel() {
        if (mentalScale <= 0) return "";
        if (mentalScale >= 9) return mentalScale + "（非常につらい）";
        if (mentalScale >= 7) return mentalScale + "（かなりつらい）";
        if (mentalScale >= 4) return mentalScale + "（ややつらい）";
        return mentalScale + "（比較的落ち着いている）";
    }
    public int getSatisfactionScore() {
        return satisfactionScore;
    }

    public void setSatisfactionScore(int satisfactionScore) {
        this.satisfactionScore = satisfactionScore;
    }

    public String getSatisfactionComment() {
        return satisfactionComment;
    }

    public void setSatisfactionComment(String satisfactionComment) {
        this.satisfactionComment = satisfactionComment;
    }

    public java.time.LocalDateTime getSatisfactionAt() {
        return satisfactionAt;
    }

    public void setSatisfactionAt(java.time.LocalDateTime satisfactionAt) {
        this.satisfactionAt = satisfactionAt;
    }

}
