package com.example.harassment.model;

public class Consultation {

    private long id;                    // メモリ内で採番するID

    private String sheetDate;           // シート記入日 (yyyy-MM-dd 文字列)
    private String consultantName;      // 相談者氏名
    private String summary;             // 相談の概要

    // 発生後の状況
    private String reportedExists;      // YES / NO
    private String reportedPerson;      // 相談相手
    private String reportedAt;          // 相談日時 (文字列のまま)
    private String followUp;            // その後の対応

    // 心身の状態
    private Integer mentalScale;        // 1〜10
    private String mentalDetail;        // 心身の状態の詳細

    // 今後の希望
    private String futureRequest;       // カンマ区切りで保存 (例: "TALK_ONLY,WATCH")
    private String futureRequestOtherDetail;

    // 共有可否
    private String sharePermission;     // ALL_OK / LIMITED / NO_SHARE
    private String shareLimitedTargets;

    // ===== Getter / Setter =====

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getSheetDate() {
        return sheetDate;
    }

    public void setSheetDate(String sheetDate) {
        this.sheetDate = sheetDate;
    }

    public String getConsultantName() {
        return consultantName;
    }

    public void setConsultantName(String consultantName) {
        this.consultantName = consultantName;
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public String getReportedExists() {
        return reportedExists;
    }

    public void setReportedExists(String reportedExists) {
        this.reportedExists = reportedExists;
    }

    public String getReportedPerson() {
        return reportedPerson;
    }

    public void setReportedPerson(String reportedPerson) {
        this.reportedPerson = reportedPerson;
    }

    public String getReportedAt() {
        return reportedAt;
    }

    public void setReportedAt(String reportedAt) {
        this.reportedAt = reportedAt;
    }

    public String getFollowUp() {
        return followUp;
    }

    public void setFollowUp(String followUp) {
        this.followUp = followUp;
    }

    public Integer getMentalScale() {
        return mentalScale;
    }

    public void setMentalScale(Integer mentalScale) {
        this.mentalScale = mentalScale;
    }

    public String getMentalDetail() {
        return mentalDetail;
    }

    public void setMentalDetail(String mentalDetail) {
        this.mentalDetail = mentalDetail;
    }

    public String getFutureRequest() {
        return futureRequest;
    }

    public void setFutureRequest(String futureRequest) {
        this.futureRequest = futureRequest;
    }

    public String getFutureRequestOtherDetail() {
        return futureRequestOtherDetail;
    }

    public void setFutureRequestOtherDetail(String futureRequestOtherDetail) {
        this.futureRequestOtherDetail = futureRequestOtherDetail;
    }

    public String getSharePermission() {
        return sharePermission;
    }

    public void setSharePermission(String sharePermission) {
        this.sharePermission = sharePermission;
    }

    public String getShareLimitedTargets() {
        return shareLimitedTargets;
    }

    public void setShareLimitedTargets(String shareLimitedTargets) {
        this.shareLimitedTargets = shareLimitedTargets;
    }
}
