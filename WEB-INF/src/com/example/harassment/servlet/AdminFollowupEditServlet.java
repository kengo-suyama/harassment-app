package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.MemoryConsultationRepository;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class AdminFollowupEditServlet extends HttpServlet {

    private static final MemoryConsultationRepository repository =
            new MemoryConsultationRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        Consultation consultation = null;

        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                consultation = repository.findById(id);
            } catch (NumberFormatException e) {
                // ignore
            }
        }

        if (consultation == null) {
            response.sendRedirect(request.getContextPath() + "/admin/consult/list");
            return;
        }

        request.setAttribute("consultation", consultation);
        request.getRequestDispatcher("/admin/consult_followup_form.jsp")
               .forward(request, response);
    }
}
