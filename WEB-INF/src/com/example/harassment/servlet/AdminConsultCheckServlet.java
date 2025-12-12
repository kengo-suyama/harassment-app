package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.MemoryConsultationRepository;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class AdminConsultCheckServlet extends HttpServlet {

    private static final MemoryConsultationRepository repository =
            new MemoryConsultationRepository();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("loginRole"))) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                Consultation c = repository.findById(id);
                if (c != null) {
                    c.setAdminChecked(true);
                    repository.save(c);
                }
            } catch (NumberFormatException ignored) {
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/consult/list");
    }
}
