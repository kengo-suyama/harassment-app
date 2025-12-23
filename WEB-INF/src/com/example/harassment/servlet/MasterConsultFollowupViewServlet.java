package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.ConsultationRepository;
import com.example.harassment.repository.RepositoryProvider;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class MasterConsultFollowupViewServlet extends HttpServlet {

    private static final ConsultationRepository repository =
        RepositoryProvider.get();


    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"MASTER".equals(session.getAttribute("loginRole"))) {
            response.sendRedirect(request.getContextPath() + "/master/login");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/master/consult/list");
            return;
        }

        int id = Integer.parseInt(idStr);
        Consultation c = repository.findById(id);
        if (c == null || c.getFollowUpAction() == null) {
            response.sendRedirect(request.getContextPath() + "/master/consult/list");
            return;
        }

        request.setAttribute("consultation", c);
        request.getRequestDispatcher("/master/consult_followup_view.jsp")
               .forward(request, response);
    }
}
