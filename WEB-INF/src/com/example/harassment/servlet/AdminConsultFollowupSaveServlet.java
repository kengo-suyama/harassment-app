package com.example.harassment.servlet;

import com.example.harassment.repository.ConsultationRepository;
import com.example.harassment.repository.RepositoryProvider;

import javax.servlet.http.*;
import java.io.IOException;

public class AdminConsultFollowupSaveServlet extends HttpServlet {
    private static final ConsultationRepository repo = RepositoryProvider.get();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (!LoginUtil.isAdmin(session)) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        int id = 0;
        try { id = Integer.parseInt(request.getParameter("id")); } catch (Exception ignored) {}

        String mode = request.getParameter("mode"); // draft / final
        String text = request.getParameter("followUpText");

        repo.saveFollowup(id, mode, text);
        AuditLogger.log(request, "UPDATE", "CONSULTATION", id, "followup_" + mode);

        response.sendRedirect(request.getContextPath() + "/admin/consult/detail?id=" + id);
    }
}
