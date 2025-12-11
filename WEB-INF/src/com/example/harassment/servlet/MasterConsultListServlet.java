package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.MemoryConsultationRepository;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class MasterConsultListServlet extends HttpServlet {

    private static final MemoryConsultationRepository repository =
            new MemoryConsultationRepository();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"MASTER".equals(session.getAttribute("loginRole"))) {
            response.sendRedirect(request.getContextPath() + "/master/login");
            return;
        }

        List<Consultation> consultations = repository.findAll();
        request.setAttribute("consultations", consultations);

        request.getRequestDispatcher("/master/consult_list.jsp")
               .forward(request, response);
    }
}
