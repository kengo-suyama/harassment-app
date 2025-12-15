package com.example.harassment.model;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * ハラスメント相談シート 1 件分を表すモデルクラス
 */
public class Consultation {

    private int id;

    private String sheetDate;
    private String consultantName;
    private String summary;

    private String reportedExists;     // YES / NO（フォームの値）
    private String reportedPerson;
    private String reportedAt;         // datetime-local の値（文字列で保持）
    private String followUp;

    private int mentalScale;
    private String mentalDetail;

    // 今後の希望（カンマ区切り）
    private String futureRequest;      // LISTEN_ONLY,WAIT,FACT_CHECK,WARN,WORK_CHANGE,OTHER など
    private String futureRequestOtherDetail;

    private String sharePermission;    // ALL_OK / LIMITED / NO_SHARE
    private String shareLimitedTargets;

    private boolean adminChecked;
    private String followUpDraft;
    private String followUpAction;

    // NEW / CHECKING / IN_PROGRESS / DONE
    private String status;

    // ===== getter/setter =====

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
    public void setFutureRequestOtherDetail(String futureRequestOtherDetail) { this.futureRequestOtherDetail = futureRequestOtherDetail; }

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

    // ===== 日本語ラベル =====

    public String getReportedExistsLabel() {
        if (reportedExists == null || reportedExists.isEmpty()) return "";
        switch (reportedExists) {
            case "YES": return "すでに誰かに相談している";
            case "NO":  return "まだ誰にも相談していない";
            // 旧コード互換
            case "NONE": return "まだ誰にも相談していない";
            case "SOMEONE": return "すでに誰かに相談している";
            default: return reportedExists;
        }
    }

    public String getSharePermissionLabel() {
        if (sharePermission == null || sharePermission.isEmpty()) return "";
        switch (sharePermission) {
            case "ALL_OK": return "必要と判断される関係者には共有してよい";
            case "LIMITED": return "共有する相手を限定してほしい";
            case "NO_SHARE": return "相談窓口以外には共有しないでほしい";
            default: return sharePermission;
        }
    }

    /**
     * ★互換性のために追加：JSPがこれを呼んでも落ちないようにする
     * futureRequest（カンマ区切り）→ 日本語ラベルを「、」で連結
     */
    public String getFutureRequestLabel() {
        return getFutureRequestLabelString();
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
                case "LISTEN_ONLY":
                    result.add("相談したかっただけ（まず話を聞いてほしい）");
                    break;
                case "WAIT":
                    result.add("様子を見たい");
                    break;
                case "FACT_CHECK":
                    result.add("事実確認してほしい");
                    break;
                case "WARN":
                    result.add("行為者に注意してほしい");
                    break;
                case "WORK_CHANGE":
                    result.add("担当変更等、今後の業務について相談したい（配置転換など）");
                    break;
                case "OTHER":
                    result.add("その他");
                    break;

                // 旧コード互換
                case "LISTEN":
                    result.add("まず話を聞いてほしい");
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

                default:
                    result.add(code);
                    break;
            }
        }
        return result;
    }

    public String getFutureRequestLabelString() {
        List<String> labels = getFutureRequestLabelList();
        if (labels.isEmpty()) return "";
        return String.join("、", labels);
    }

    public String getMentalScaleLabel() {
        if (mentalScale <= 0) return "";
        if (mentalScale >= 9) return mentalScale + "（非常につらい）";
        if (mentalScale >= 7) return mentalScale + "（かなりつらい）";
        if (mentalScale >= 4) return mentalScale + "（ややつらい）";
        return mentalScale + "（比較的落ち着いている）";
    }

    /**
     * status（コード） -> 日本語ラベル
     * NEW / CHECKING / IN_PROGRESS / DONE を想定
     */
    public String getStatusLabel() {
        if (status == null || status.isEmpty()) {
            return "";
        }
        switch (status) {
            case "NEW":
                return "未対応";
            case "CHECKING":
                return "確認済";
            case "IN_PROGRESS":
                return "対応中";
            case "DONE":
                return "対応完了";
            default:
                return status;
        }
    }
}
