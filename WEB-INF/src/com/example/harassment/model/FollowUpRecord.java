package com.example.harassment.model;

import java.time.LocalDateTime;

public class FollowUpRecord {
    private LocalDateTime at;
    private String byRole;   // ADMIN / MASTER など
    private String category; // 初回面談/フォロー/産業医 など（自由）
    private String text;

    public FollowUpRecord(LocalDateTime at, String byRole, String category, String text) {
        this.at = at;
        this.byRole = byRole;
        this.category = category;
        this.text = text;
    }

    public LocalDateTime getAt() { return at; }
    public String getByRole() { return byRole; }
    public String getCategory() { return category; }
    public String getText() { return text; }

    public String getByRoleLabel() {
        if (byRole == null) return "";
        switch (byRole) {
            case "ADMIN": return "管理者";
            case "MASTER": return "全権管理者";
            case "REPORTER": return "相談者";
            default: return byRole;
        }
    }

    public String getCategoryLabel() {
        if (category == null || category.trim().isEmpty()) return "";
        switch (category) {
            case "ROUND_1": return "第1回";
            case "ROUND_2": return "第2回";
            case "ROUND_3": return "第3回";
            case "ROUND_4": return "第4回";
            case "ROUND_5": return "第5回";
            case "OCC_HEALTH": return "産業医/専門家連携";
            case "NOTE": return "メモ";
            default: return category;
        }
    }
}
