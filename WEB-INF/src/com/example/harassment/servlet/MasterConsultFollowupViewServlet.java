package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.MemoryConsultationRepository;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class MasterConsultFollowupViewServlet extends HttpServlet {

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

        String idStr = request.getParameter("id");
        Consultation consultation = null;

        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                consultation = repository.findById(id);   // ★ インスタンスメソッドとして呼び出す
            } catch (NumberFormatException e) {
                // ignore
            }
        }

        if (consultation == null) {
            response.sendRedirect(request.getContextPath() + "/master/consult/list");
            return;
        }

        request.setAttribute("consultation", consultation);
        request.getRequestDispatcher("/master/consult_followup_view.jsp")
               .forward(request, response);
    }
}
