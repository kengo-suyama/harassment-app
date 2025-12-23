package com.example.harassment.servlet;

import com.example.harassment.repository.UserRepository;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class AdminLoginServlet extends HttpServlet {

    private static final UserRepository users = new UserRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            email = request.getParameter("username");
        }
        String pass = request.getParameter("password");

        int userId = users.authenticate("ADMIN", email, pass);
        if (userId > 0) {
            HttpSession session = request.getSession(true);
            session.setAttribute("loginRole", "ADMIN");
            session.setAttribute("loginUserId", userId);
            session.setAttribute("loginEmail", email);
            response.sendRedirect(request.getContextPath() + "/admin/consult/list");
            return;
        }

        request.setAttribute("errorMessage", "メールアドレスまたはパスワードが違います。");
        request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
    }
}
