package com.example.harassment.model;

/**
 * ハラスメント相談1件分を表すモデルクラス
 * まずは最低限の項目だけ持たせておきます。
 */
public class Consultation {

    private int id;                  // 受付番号（アプリ内で採番）
    private String sheetDate;        // シート記入日（簡単のため String）
    private String consultantName;   // 相談者氏名
    private String summary;          // 相談の概要
    private String sharePermission;  // 共有可否（ALL_OK / LIMITED / NO_SHARE）

    // 外部機関に提供して良いかの簡易判定（後でマスター権限で使用）
    public boolean canShareOutside() {
        return "ALL_OK".equals(sharePermission) || "LIMITED".equals(sharePermission);
    }

    // ---- getter / setter ----

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

    public String getSharePermission() {
        return sharePermission;
    }
    public void setSharePermission(String sharePermission) {
        this.sharePermission = sharePermission;
    }
}

