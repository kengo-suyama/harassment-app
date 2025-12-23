package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.ConsultationRepository;
import com.example.harassment.repository.RepositoryProvider;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class AdminFollowupEditServlet extends HttpServlet {
    private static final ConsultationRepository repo = RepositoryProvider.get();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (!LoginUtil.isAdmin(session)) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        int id = 0;
        try { id = Integer.parseInt(request.getParameter("id")); } catch (Exception ignored) {}

        Consultation c = repo.findById(id);
        request.setAttribute("consultation", c);

        request.getRequestDispatcher("/admin/followup_edit.jsp").forward(request, response);
    }
}
