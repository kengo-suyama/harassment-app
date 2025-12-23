package com.example.harassment.servlet;

import com.example.harassment.repository.ConsultationRepository;
import com.example.harassment.repository.RepositoryProvider;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class ConsultSatisfactionSubmitServlet extends HttpServlet {

    // ★ 必ず getInstance() を使う（new しない）
    private static final ConsultationRepository repository =
        RepositoryProvider.get();


    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 受付番号
        int id = 0;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (Exception e) {
            // 無視
        }

        String key = request.getParameter("token");
        if (key == null || key.trim().isEmpty()) {
            key = request.getParameter("key");
        }

        // 満足度スコア
        int score = 0;
        try {
            score = Integer.parseInt(request.getParameter("score"));
        } catch (Exception e) {
            // 無視
        }

        // コメント
        String comment = request.getParameter("comment");

        /* =========================
           ★ ここが今回の追加部分
           ========================= */

        if (key == null || key.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/consult/status");
            return;
        }

        repository.saveSatisfaction(id, key.trim(), score, comment);

        response.sendRedirect(request.getContextPath() + "/consult/status/" + key.trim());
    }
}
