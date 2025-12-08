package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.MemoryConsultationRepository;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class AdminConsultDetailServlet extends HttpServlet {

    private static final MemoryConsultationRepository repository =
            new MemoryConsultationRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            // idが無い場合は一覧にリダイレクト
            response.sendRedirect(request.getContextPath() + "/admin/consult/list");
            return;
        }

        long id;
        try {
            id = Long.parseLong(idParam);
        } catch (NumberFormatException e) {
            // 変なidは一覧へ
            response.sendRedirect(request.getContextPath() + "/admin/consult/list");
            return;
        }

        Consultation consultation = repository.findById(id);
        if (consultation == null) {
            // 該当データなし → 簡易メッセージ付きで一覧へ
            request.setAttribute("notFoundId", id);
            request.getRequestDispatcher("/admin/consult_not_found.jsp")
                   .forward(request, response);
            return;
        }

        request.setAttribute("consultation", consultation);
        request.getRequestDispatcher("/admin/consult_detail.jsp")
               .forward(request, response);
    }
}
