package com.example.harassment.servlet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class ConsultConfirmServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 下書きを最新化
        DraftUtil.saveDraftToSession(request);

        String detail = request.getParameter("summaryDetail");
        if (detail == null || detail.trim().isEmpty()) {
            request.setAttribute("errorMessage", "「相談内容の概要（※必須）」は必ず入力してください。");
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
