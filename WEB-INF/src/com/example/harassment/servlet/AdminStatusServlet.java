package com.example.harassment.servlet;

import com.example.harassment.repository.ConsultationRepository;
import com.example.harassment.repository.RepositoryProvider;

import javax.servlet.http.*;
import java.io.IOException;

public class AdminStatusServlet extends HttpServlet {
    private static final ConsultationRepository repo = RepositoryProvider.get();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (!LoginUtil.isAdmin(session)) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        int id = 0;
        try { id = Integer.parseInt(request.getParameter("id")); } catch (Exception ignored) {}
        String status = request.getParameter("status"); // UNCONFIRMED/CONFIRMED/REVIEWING/IN_PROGRESS/DONE

        repo.setStatus(id, status);
        AuditLogger.log(request, "UPDATE", "CONSULTATION", id, "status=" + status);

        response.sendRedirect(request.getContextPath() + "/admin/consult/detail?id=" + id);
    }
}

