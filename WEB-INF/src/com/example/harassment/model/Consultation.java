package com.example.harassment.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * ハラスメント相談シート1件を表すモデル。
 */
public class Consultation {

    // ====== 基本 ======
    private int id;
    private String sheetDate;                // シート記録日（文字列でOK）
    private String consultantName;           // 相談者名（任意）
    private String contactEmail;             // Email（未使用）
    private String summary;                  // 相談概要

    // ====== 発生後の状況 ======
    private String reportedExists;           // 相談有無
    private String reportedPerson;           // 相談相手
    private String reportedAt;               // 相談日時
    private String followUp;                 // その後の対応（相談者側記入）

    // ====== 心身の状態 ======
    private int mentalScale;                 // 1-10
    private String mentalDetail;             // 詳細

    // ====== 今後の希望 ======
    private String futureRequest;            // カンマ区切りのコード
    private String futureRequestOtherDetail; // その他の詳細

    // ====== 共有許可 ======
    private String sharePermission;          // ALL_OK / LIMITED / NO_SHARE
    private String shareLimitedTargets;      // 限定相手

    // ====== 管理者対応 ======
    private boolean adminChecked;            // 確認済み
    private String followUpDraft;            // 下書き
    private String followUpAction;           // 確定内容

    // ====== ステータス ======
    private String status;                   // UNCONFIRMED / CONFIRMED / REVIEWING / IN_PROGRESS / DONE

    // ====== 照合キー ======
    private String accessKey;

    // ====== チャット ======
    private List<ChatMessage> chatMessages = new ArrayList<>();

    // ====== 対応履歴 ======
    private List<FollowUpRecord> followUpHistory = new ArrayList<>();

    // ====== 通知 ======
    private int unreadForReporter;
    private int unreadForAdmin;
    private String latestChatMessage;
    private String latestChatSenderRole;
    private LocalDateTime latestChatAt;
    private LocalDateTime lastReporterReadAt;
    private LocalDateTime lastAdminReadAt;

    // ====== 相談者評価 ======
    private int reporterRating;              // 1-5、未評価は0
    private String reporterFeedback;
    private LocalDateTime reporterRatedAt;

    // ====== 相談者満足度（未使用） ======
    private int satisfactionScore;
    private String satisfactionComment;
    private LocalDateTime satisfactionAt;

    // ====== getter / setter ======
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getSheetDate() { return sheetDate; }
    public void setSheetDate(String sheetDate) { this.sheetDate = sheetDate; }

    public String getConsultantName() { return consultantName; }
    public void setConsultantName(String consultantName) { this.consultantName = consultantName; }

    public String getContactEmail() { return contactEmail; }
    public void setContactEmail(String contactEmail) { this.contactEmail = contactEmail; }

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

    public String getLookupKey() { return accessKey; }

    public List<ChatMessage> getChatMessages() {
        if (chatMessages == null) chatMessages = new ArrayList<>();
        return chatMessages;
    }

    public List<ChatMessage> getChats() {
        return getChatMessages();
    }

    public void setChatMessages(List<ChatMessage> chatMessages) {
        this.chatMessages = (chatMessages != null) ? chatMessages : new ArrayList<>();
    }

    public List<FollowUpRecord> getFollowUpHistory() {
        if (followUpHistory == null) followUpHistory = new ArrayList<>();
        return followUpHistory;
    }

    public void setFollowUpHistory(List<FollowUpRecord> followUpHistory) {
        this.followUpHistory = (followUpHistory != null) ? followUpHistory : new ArrayList<>();
    }

    public int getUnreadForReporter() { return unreadForReporter; }
    public void setUnreadForReporter(int unreadForReporter) { this.unreadForReporter = unreadForReporter; }

    public int getUnreadForAdmin() { return unreadForAdmin; }
    public void setUnreadForAdmin(int unreadForAdmin) { this.unreadForAdmin = unreadForAdmin; }

    public String getLatestChatMessage() { return latestChatMessage; }
    public void setLatestChatMessage(String latestChatMessage) { this.latestChatMessage = latestChatMessage; }

    public String getLatestChatSenderRole() { return latestChatSenderRole; }
    public void setLatestChatSenderRole(String latestChatSenderRole) { this.latestChatSenderRole = latestChatSenderRole; }

    public LocalDateTime getLatestChatAt() { return latestChatAt; }
    public void setLatestChatAt(LocalDateTime latestChatAt) { this.latestChatAt = latestChatAt; }

    public LocalDateTime getLastReporterReadAt() { return lastReporterReadAt; }
    public void setLastReporterReadAt(LocalDateTime lastReporterReadAt) { this.lastReporterReadAt = lastReporterReadAt; }

    public LocalDateTime getLastAdminReadAt() { return lastAdminReadAt; }
    public void setLastAdminReadAt(LocalDateTime lastAdminReadAt) { this.lastAdminReadAt = lastAdminReadAt; }

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

    public int getSatisfactionScore() { return satisfactionScore; }
    public void setSatisfactionScore(int satisfactionScore) { this.satisfactionScore = satisfactionScore; }

    public String getSatisfactionComment() { return satisfactionComment; }
    public void setSatisfactionComment(String satisfactionComment) { this.satisfactionComment = satisfactionComment; }

    public LocalDateTime getSatisfactionAt() { return satisfactionAt; }
    public void setSatisfactionAt(LocalDateTime satisfactionAt) { this.satisfactionAt = satisfactionAt; }

    // ====== 表示用ラベル ======
    public String getStatusLabel() {
        if (status == null || status.trim().isEmpty()) return "";
        switch (status) {
            case "UNCONFIRMED": return "未確認";
            case "CONFIRMED": return "確認";
            case "REVIEWING": return "対応検討中";
            case "IN_PROGRESS": return "対応中";
            case "DONE": return "対応済";
            case "NEW": return "未確認";
            case "CHECKING": return "確認";
            default: return status;
        }
    }

    public String getSummaryCategoryLabel() {
        SummaryParts parts = parseSummary(summary);
        return parts.category;
    }

    public String getSummaryDetail() {
        SummaryParts parts = parseSummary(summary);
        return parts.detail;
    }

    public String getReportedExistsLabel() {
        if (reportedExists == null || reportedExists.isEmpty()) return "";
        switch (reportedExists) {
            case "NONE": return "まだ誰にも相談していない";
            case "SOMEONE": return "すでに誰かに相談している";
            case "YES": return "すでに誰かに相談している";
            case "NO": return "まだ誰にも相談していない";
            default: return reportedExists;
        }
    }

    public String getSharePermissionLabel() {
        if (sharePermission == null || sharePermission.isEmpty()) return "";
        switch (sharePermission) {
            case "ALL_OK": return "必要に応じて関係者へ共有してよい";
            case "LIMITED": return "共有範囲を限定してほしい";
            case "NO_SHARE": return "相談窓口以外には共有しないでほしい";
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
                    result.add("職場環境・人間関係を改善してほしい");
                    break;
                case "FORMAL_PROCEDURE":
                    result.add("正式な申し立てや調査を進めてほしい");
                    break;
                case "MENTAL_SUPPORT":
                    result.add("専門家（産業医・カウンセラー等）につなげてほしい");
                    break;
                case "ADVISE":
                    result.add("助言・アドバイスがほしい");
                    break;
                case "ARRANGE_MEETING":
                    result.add("面談の場を調整してほしい");
                    break;
                case "KEEP_RECORD":
                    result.add("記録として残してほしい");
                    break;
                case "NOTHING":
                    result.add("特に希望はない");
                    break;
                case "OTHER":
                    result.add("その他");
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

    public String getSatisfactionScoreLabel() {
        if (satisfactionScore <= 0) return "";
        switch (satisfactionScore) {
            case 1: return "1（不満）";
            case 2: return "2（やや不満）";
            case 3: return "3（普通）";
            case 4: return "4（満足）";
            case 5: return "5（とても満足）";
            default: return String.valueOf(satisfactionScore);
        }
    }

    private static SummaryParts parseSummary(String s) {
        if (s == null || s.trim().isEmpty()) return new SummaryParts("", "");
        String text = s.trim();
        String category = "";
        String detail = text;
        if (text.startsWith("CATEGORY:")) {
            int lineEnd = text.indexOf('\n');
            if (lineEnd < 0) lineEnd = text.length();
            category = text.substring("CATEGORY:".length(), lineEnd).trim();
            int detailPos = text.indexOf("DETAIL:");
            if (detailPos >= 0) {
                detail = text.substring(detailPos + "DETAIL:".length()).trim();
            } else if (lineEnd < text.length()) {
                detail = text.substring(lineEnd + 1).trim();
            } else {
                detail = "";
            }
        }
        return new SummaryParts(category, detail);
    }

    private static class SummaryParts {
        final String category;
        final String detail;
        SummaryParts(String category, String detail) {
            this.category = category == null ? "" : category;
            this.detail = detail == null ? "" : detail;
        }
    }
}
