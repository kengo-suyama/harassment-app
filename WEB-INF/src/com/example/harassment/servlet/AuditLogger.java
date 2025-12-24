package com.example.harassment.servlet;

import com.example.harassment.repository.AuditLogRepository;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class AuditLogger {
    private static final AuditLogRepository repo = new AuditLogRepository();

    public static void log(HttpServletRequest request, String action,
                           String targetType, Integer targetId, String detail) {
        if (request == null) return;

        HttpSession session = request.getSession(false);
        String role = session != null ? String.valueOf(session.getAttribute("loginRole")) : "ANON";
        Integer userId = null;
        if (session != null) {
            Object idObj = session.getAttribute("loginUserId");
            if (idObj instanceof Integer) {
                userId = (Integer) idObj;
            }
        }
        String ip = getClientIp(request);
        repo.log(role, userId, action, targetType, targetId, detail, ip);
    }

    private static String getClientIp(HttpServletRequest request) {
        String xff = request.getHeader("X-Forwarded-For");
        if (xff != null && !xff.trim().isEmpty()) {
            int comma = xff.indexOf(',');
            return (comma > 0 ? xff.substring(0, comma) : xff).trim();
        }
        String xr = request.getHeader("X-Real-IP");
        if (xr != null && !xr.trim().isEmpty()) return xr.trim();
        return request.getRemoteAddr();
    }
}
