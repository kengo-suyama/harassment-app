package com.example.harassment.servlet;

import com.example.harassment.auth.AuthService;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class AdminLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // ログインフォームを表示
        request.getRequestDispatcher("/admin_login.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (AuthService.checkAdminLogin(username, password)) {
            // ログイン成功 → セッションに権限を保存
            HttpSession session = request.getSession(true);
            session.setAttribute("loginRole", "ADMIN");

            // 管理一覧画面へ
            response.sendRedirect(request.getContextPath() + "/admin/consult/list");
        } else {
            // 失敗 → エラーメッセージを出してログイン画面に戻す
            request.setAttribute("loginError", "ユーザー名またはパスワードが違います。");
            request.getRequestDispatcher("/admin_login.jsp")
                   .forward(request, response);
        }
    }
}
