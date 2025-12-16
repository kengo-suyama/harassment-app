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
}
