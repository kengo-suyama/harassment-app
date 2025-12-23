package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.ConsultationRepository;
import com.example.harassment.repository.RepositoryProvider;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class MasterConsultDetailServlet extends HttpServlet {
    private static final ConsultationRepository repo = RepositoryProvider.get();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (!LoginUtil.isMaster(session)) {
            response.sendRedirect(request.getContextPath() + "/master/login");
            return;
        }

        int id = 0;
        try { id = Integer.parseInt(request.getParameter("id")); } catch (Exception ignored) {}

        Consultation c = repo.findById(id);
        request.setAttribute("consultation", c);

        request.getRequestDispatcher("/master/detail.jsp").forward(request, response);
    }
}

