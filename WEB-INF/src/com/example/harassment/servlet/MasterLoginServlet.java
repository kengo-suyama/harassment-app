package com.example.harassment.servlet;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class MasterLoginServlet extends HttpServlet {

    private static final String MASTER_PASS = "master";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/master/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String pass = request.getParameter("password");

        if (MASTER_PASS.equals(pass)) {
            HttpSession session = request.getSession(true);
            session.setAttribute("loginRole", "MASTER");
            response.sendRedirect(request.getContextPath() + "/master/consult/list");
            return;
        }

        request.setAttribute("errorMessage", "パスワードが違います。");
        request.getRequestDispatcher("/master/login.jsp").forward(request, response);
    }
}
