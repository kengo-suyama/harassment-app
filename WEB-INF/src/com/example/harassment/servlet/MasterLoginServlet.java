package com.example.harassment.servlet;

import com.example.harassment.auth.AuthService;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class MasterLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/master_login.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (AuthService.checkMasterLogin(username, password)) {
            HttpSession session = request.getSession(true);
            session.setAttribute("loginRole", "MASTER");

            // マスター用のトップ（とりあえず同じ一覧へ飛ばしてもOK）
            response.sendRedirect(request.getContextPath() + "/admin/consult/list");
        } else {
            request.setAttribute("loginError", "ユーザー名またはパスワードが違います。");
            request.getRequestDispatcher("/master_login.jsp")
                   .forward(request, response);
        }
    }
}
