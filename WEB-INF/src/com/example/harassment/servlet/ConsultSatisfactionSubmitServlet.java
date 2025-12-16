package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.MemoryConsultationRepository;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;

public class ConsultSatisfactionSubmitServlet extends HttpServlet {

    // ★ 必ず getInstance() を使う（new しない）
    private static final MemoryConsultationRepository repository =
        MemoryConsultationRepository.getInstance();


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

        // 照合キー
        String key = request.getParameter("key");

        Consultation c = repository.findByIdAndKey(
                id,
                key != null ? key.trim() : ""
        );

        if (c == null) {
            // 不正アクセス or 照合失敗
            response.sendRedirect(request.getContextPath() + "/consult/status");
            return;
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

        c.setSatisfactionScore(score);
        c.setSatisfactionComment(comment);
        c.setSatisfactionAt(LocalDateTime.now());

        // 念のため保存（メモリ保持でも呼んでOK）
        repository.update(c);

        // 結果画面へ
        request.setAttribute("consultation", c);
        request.getRequestDispatcher("/consult/status_view.jsp")
                .forward(request, response);
    }
}
