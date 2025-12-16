package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.MemoryConsultationRepository;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * 相談者が「受付番号(ID) + 照合キー」で状況確認する
 * GET : 入力フォーム
 * POST: 照合して表示
 */
public class ConsultStatusServlet extends HttpServlet {

    private static final MemoryConsultationRepository repository =
        MemoryConsultationRepository.getInstance();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        request.getRequestDispatcher("/consult/status.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String idStr = request.getParameter("id");
        String key = request.getParameter("key");

        int id = 0;
        try { id = Integer.parseInt(idStr); } catch (Exception e) { /* ignore */ }

        Consultation c = repository.findByIdAndKey(id, key != null ? key.trim() : "");
        if (c == null) {
            request.setAttribute("errorMessage", "受付番号または照合キーが一致しませんでした。");
            request.getRequestDispatcher("/consult/status.jsp").forward(request, response);
            return;
        }

        request.setAttribute("consultation", c);
        request.getRequestDispatcher("/consult/status_view.jsp")
                .forward(request, response);
    }
}
