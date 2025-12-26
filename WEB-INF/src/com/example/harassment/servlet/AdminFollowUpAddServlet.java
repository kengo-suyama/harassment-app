package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.ConsultationRepository;
import com.example.harassment.repository.RepositoryProvider;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;

public class AdminFollowUpAddServlet extends HttpServlet {

    private static final ConsultationRepository repository =
        RepositoryProvider.get();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (!LoginUtil.isAdmin(session)) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        String category = request.getParameter("category");
        String text = request.getParameter("text");
        LocalDateTime followUpAt = parseFollowUpAt(request.getParameter("followUpAt"));

        Consultation c = repository.findById(id);
        if (c == null) {
            response.sendRedirect(request.getContextPath() + "/admin/consult/list");
            return;
        }

        if (c.getFollowUpHistory() != null && c.getFollowUpHistory().size() >= 5) {
            session.setAttribute("followupError", "対応履歴は最大5件までです。");
            response.sendRedirect(request.getContextPath() + "/admin/consult/detail?id=" + id);
            return;
        }

        if (text != null && !text.trim().isEmpty()) {
            repository.addFollowUp(id, "ADMIN", category, text.trim(), followUpAt);
            AuditLogger.log(request, "UPDATE", "CONSULTATION", id, "followup_add");
        } else {
            session.setAttribute("followupError", "対応内容を入力してください。");
        }

        response.sendRedirect(request.getContextPath() + "/admin/consult/detail?id=" + id);
    }

    private LocalDateTime parseFollowUpAt(String value) {
        if (value == null) return null;
        String v = value.trim();
        if (v.isEmpty()) return null;
        if (v.length() == 16) {
            v = v + ":00";
        }
        try {
            return LocalDateTime.parse(v);
        } catch (Exception e) {
            return null;
        }
    }
}
