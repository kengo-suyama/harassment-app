package com.example.harassment.model;

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
    // reportedExists: "NONE" / "SOMEONE" 等のコード値を想定
    private String reportedExists;           // 「いる」「いない」などのコード
    private String reportedPerson;           // 相談相手
    private String reportedAt;               // 相談日時
    private String followUp;                 // その後の対応（相談者側の自己記入）

    // 心身の状態
    private int mentalScale;                 // 1〜10
    private String mentalDetail;             // 心身の状態の詳細

    // 今後の希望（カンマ区切りで複数コードを保存）
    // 例: "LISTEN,WORK_CHANGE,ENV_IMPROVE"
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

    // ====== 通常の getter / setter ======

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

    public boolean isAdminChecked() {
        return adminChecked;
    }

    public void setAdminChecked(boolean adminChecked) {
        this.adminChecked = adminChecked;
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

    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    // 後方互換：古いJSPが getFutureRequestLabel() を呼んでも落ちないようにする
    public String getFutureRequestLabel() {
        return getFutureRequestLabelString();
    }


    // ====== 画面表示用の「日本語ラベル」getter ======

    /**
     * reportedExists（コード） -> 日本語ラベル
     */
    public String getReportedExistsLabel() {
        if (reportedExists == null || reportedExists.isEmpty()) {
            return "";
        }
        switch (reportedExists) {
            case "NONE":
                return "まだ誰にも相談していない";
            case "SOMEONE":
                return "すでに誰かに相談している";
            default:
                return reportedExists; // 不明なコードはそのまま表示
        }
    }

    /**
     * sharePermission（コード） -> 日本語ラベル
     */
    public String getSharePermissionLabel() {
        if (sharePermission == null || sharePermission.isEmpty()) {
            return "";
        }
        switch (sharePermission) {
            case "ALL_OK":
                return "必要に応じて関係者に共有してよい";
            case "LIMITED":
                return "共有範囲を限定してほしい";
            case "NO_SHARE":
                return "相談内容は共有してほしくない";
            default:
                return sharePermission;
        }
    }

    /**
     * futureRequest（カンマ区切りコード列） -> 日本語ラベルのリスト
     *
     * 例: "LISTEN,WORK_CHANGE"
     *   -> ["話を聞いてほしい", "配置転換・業務内容を調整してほしい"]
     */
    public List<String> getFutureRequestLabelList() {
        List<String> result = new ArrayList<>();
        if (futureRequest == null || futureRequest.trim().isEmpty()) {
            return result;
        }

        List<String> codes = Arrays.stream(futureRequest.split(","))
                                   .map(String::trim)
                                   .filter(s -> !s.isEmpty())
                                   .collect(Collectors.toList());

        for (String code : codes) {
            switch (code) {
                case "LISTEN":
                    result.add("まず話を聞いてほしい");
                    break;
                case "WORK_CHANGE":
                    // ★ ここを日本語に修正（ご要望の箇所）
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
                case "OTHER":
                    result.add("その他の希望");
                    break;
                default:
                    // 想定外のコードはそのまま出す
                    result.add(code);
                    break;
            }
        }
        return result;
    }

    /**
     * futureRequest の日本語ラベルを「、」区切りで 1 つの文字列にまとめたもの
     * 画面に 1 行で表示したいとき用。
     */
    public String getFutureRequestLabelString() {
        List<String> labels = getFutureRequestLabelList();
        if (labels.isEmpty()) {
            return "";
        }
        return String.join("、", labels);
    }

    /**
     * メンタルスケールの簡易ラベル
     * 例: 8 -> "8（かなりつらい）"
     */
    public String getMentalScaleLabel() {
        if (mentalScale <= 0) {
            return "";
        }
        if (mentalScale >= 9) {
            return mentalScale + "（非常につらい）";
        } else if (mentalScale >= 7) {
            return mentalScale + "（かなりつらい）";
        } else if (mentalScale >= 4) {
            return mentalScale + "（ややつらい）";
        } else {
            return mentalScale + "（比較的落ち着いている）";
        }
    }
}
