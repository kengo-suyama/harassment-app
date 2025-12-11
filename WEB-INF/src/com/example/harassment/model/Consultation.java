package com.example.harassment.model;

public class Consultation {

    // 連番ID
    private int id;

    // ====== 相談シートの主な項目 ======
    private String sheetDate;                // シート記入日（文字列でOK）
    private String consultantName;           // 相談者氏名（任意）
    private String summary;                  // 相談の概要

    // 発生後の状況
    private String reportedExists;           // 「いる」「いない」
    private String reportedPerson;           // 相談相手
    private String reportedAt;               // 相談日時
    private String followUp;                 // その後の対応

    // 心身の状態
    private int mentalScale;                 // 1〜10
    private String mentalDetail;             // 心身の状態の詳細

    // 今後の希望
    // チェックボックス複数選択をカンマ区切りで保存しておく
    private String futureRequest;
    private String futureRequestOtherDetail;

    // 共有の可否
    private String sharePermission;          // ALL_OK / LIMITED / NO_SHARE
    private String shareLimitedTargets;

    // 管理者対応欄
    private String followUpDraft;            // 管理者の対応案（下書き）
    private String followUpAction;           // 確定した対応内容
    private boolean adminChecked;            // 管理者確認フラグ

    // ====== getter / setter ======

    public int getId() {
        return id;
    }

    public void setId(int id) {
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

    public int getMentalScale() {
        return mentalScale;
    }

    public void setMentalScale(int mentalScale) {
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

    public String getFollowUpDraft() {
        return followUpDraft;
    }

    public void setFollowUpDraft(String followUpDraft) {
        this.followUpDraft = followUpDraft;
    }

    public String getFollowUpAction() {
        return followUpAction;
    }

    public void setFollowUpAction(String followUpAction) {
        this.followUpAction = followUpAction;
    }

    public boolean isAdminChecked() {
        return adminChecked;
    }

    public void setAdminChecked(boolean adminChecked) {
        this.adminChecked = adminChecked;
    }
}
