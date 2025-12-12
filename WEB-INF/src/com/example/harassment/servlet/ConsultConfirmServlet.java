package com.example.harassment.servlet;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * 相談フォーム → 確認画面 を担当するサーブレット
 *
 * POST: フォームから受け取った値をそのまま confirm.jsp に渡す
 * GET : 直接URL叩かれたときは相談フォーム(/consult/form)にリダイレクト
 */
public class ConsultConfirmServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // ここでは値は request.getParameter(...) で取得可能
        // confirm.jsp でそのまま request.getParameter(...) を使って表示できる
        request.getRequestDispatcher("/consult/confirm.jsp")
               .forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // 直接 /consult/confirm に GET で来た場合はフォーム画面へ戻す
        response.sendRedirect(request.getContextPath() + "/consult/form");
    }
}
