package com.example.harassment.servlet;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * 相談フォーム → 確認画面 を担当するサーブレット
 *
 * POST: フォームから受け取った値を confirm.jsp にフォワード
 * GET : 直アクセスはフォームへ
 */
public class ConsultConfirmServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        request.getRequestDispatcher("/consult/confirm.jsp")
               .forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(request.getContextPath() + "/consult/form");
    }
}
