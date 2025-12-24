package com.example.harassment.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class AuditLogRepository {

    public void log(String role, Integer userId, String action,
                    String targetType, Integer targetId,
                    String detail, String ipAddr) {

        String sql = "INSERT INTO audit_logs " +
                "(actor_role, actor_user_id, action, target_type, target_id, detail, ip_addr) " +
                "VALUES (?,?,?,?,?,?,?)";
        try (Connection con = DbUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, safe(role, "ANON"));
            if (userId == null || userId <= 0) {
                ps.setObject(2, null);
            } else {
                ps.setInt(2, userId);
            }
            ps.setString(3, safe(action, "UNKNOWN"));
            ps.setString(4, emptyToNull(targetType));
            if (targetId == null || targetId <= 0) {
                ps.setObject(5, null);
            } else {
                ps.setInt(5, targetId);
            }
            ps.setString(6, emptyToNull(detail));
            ps.setString(7, emptyToNull(ipAddr));
            ps.executeUpdate();
        } catch (Exception e) {
            // 監査ログは失敗しても業務を止めない
        }
    }

    private String safe(String v, String def) {
        if (v == null) return def;
        String t = v.trim();
        return t.isEmpty() ? def : t;
    }

    private String emptyToNull(String v) {
        if (v == null) return null;
        String t = v.trim();
        return t.isEmpty() ? null : t;
    }
}
