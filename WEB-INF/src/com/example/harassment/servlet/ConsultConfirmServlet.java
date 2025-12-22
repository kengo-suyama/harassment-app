package com.example.harassment.servlet;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class ConsultConfirmServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 下書きを最新化（既にある想定）
        DraftUtil.saveDraftToSession(request);

        String summary = request.getParameter("summary");
        if (summary == null || summary.trim().isEmpty()) {
            request.setAttribute("errorMessage", "「相談内容の概要（※）」は必須です。");
            request.getRequestDispatcher("/consult/form.jsp").forward(request, response);
            return;
        }

        request.getRequestDispatcher("/consult/confirm.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/consult/form");
    }
}
