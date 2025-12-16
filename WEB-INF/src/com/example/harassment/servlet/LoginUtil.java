package com.example.harassment.servlet;

import javax.servlet.http.HttpSession;

public class LoginUtil {
    public static boolean isAdmin(HttpSession session) {
        return session != null && "ADMIN".equals(session.getAttribute("loginRole"));
    }
    public static boolean isMaster(HttpSession session) {
        return session != null && "MASTER".equals(session.getAttribute("loginRole"));
    }
}

