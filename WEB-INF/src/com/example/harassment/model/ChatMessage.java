package com.example.harassment.model;

import java.time.LocalDateTime;

/**
 * 相談者↔管理者/マスター のチャット1件
 */
public class ChatMessage {

    // "ADMIN" / "MASTER" / "REPORTER"
    private String senderRole;

    private String message;

    private LocalDateTime sentAt;

    public ChatMessage() {}

    public ChatMessage(String senderRole, String message, LocalDateTime sentAt) {
        this.senderRole = senderRole;
        this.message = message;
        this.sentAt = sentAt;
    }

    // JSPが呼んでいるgetter群
    public String getSenderRole() {
        return senderRole;
    }

    public void setSenderRole(String senderRole) {
        this.senderRole = senderRole;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public LocalDateTime getSentAt() {
        return sentAt;
    }

    public void setSentAt(LocalDateTime sentAt) {
        this.sentAt = sentAt;
    }

    public String getSenderRoleLabel() {
        if (senderRole == null) return "";
        switch (senderRole) {
            case "ADMIN": return "管理者";
            case "MASTER": return "全権管理者";
            case "REPORTER": return "相談者";
            default: return senderRole;
        }
    }
}
