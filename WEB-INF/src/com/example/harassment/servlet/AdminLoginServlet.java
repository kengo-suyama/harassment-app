package com.example.harassment.servlet;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class AdminLoginServlet extends HttpServlet {

    // デモ用（必要なら後でDB化）
    private static final String ADMIN_PASS = "admin";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String pass = request.getParameter("password");

        if (ADMIN_PASS.equals(pass)) {
            HttpSession session = request.getSession(true);
            session.setAttribute("loginRole", "ADMIN");
            response.sendRedirect(request.getContextPath() + "/admin/consult/list");
            return;
        }

        request.setAttribute("errorMessage", "パスワードが違います。");
        request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
    }
}
