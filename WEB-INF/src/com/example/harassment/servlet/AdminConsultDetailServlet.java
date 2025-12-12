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
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("loginRole"))) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/consult/list");
            return;
        }

        int id = Integer.parseInt(idStr);
        Consultation c = repository.findById(id);
        if (c == null) {
            response.sendRedirect(request.getContextPath() + "/admin/consult/list");
            return;
        }

        request.setAttribute("consultation", c);
        request.getRequestDispatcher("/admin/consult_detail.jsp")
               .forward(request, response);
    }
}
