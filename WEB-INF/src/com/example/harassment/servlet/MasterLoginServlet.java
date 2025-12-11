package com.example.harassment.servlet;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class MasterLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/master_login.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 仮の認証ロジック
        if ("master".equals(username) && "master1234".equals(password)) {

            HttpSession httpSession = request.getSession(true);
            httpSession.setAttribute("loginRole", "MASTER");

            // ★ ログイン成功後はマスター用一覧サーブレットにリダイレクト
            response.sendRedirect(request.getContextPath() + "/master/consult/list");
            return;
        }

        // 認証失敗時
        request.setAttribute("loginError", "ユーザー名またはパスワードが違います。");
        request.getRequestDispatcher("/master_login.jsp")
               .forward(request, response);
    }
}
