package com.example.harassment.servlet;

import com.example.harassment.repository.MemoryConsultationRepository;

import javax.servlet.http.*;
import java.io.IOException;

public class AdminConsultCheckServlet extends HttpServlet {
    private static final MemoryConsultationRepository repo = MemoryConsultationRepository.getInstance();

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
        boolean checked = "true".equals(request.getParameter("checked"));

        repo.setAdminChecked(id, checked);

        response.sendRedirect(request.getContextPath() + "/admin/consult/detail?id=" + id);
    }
}
