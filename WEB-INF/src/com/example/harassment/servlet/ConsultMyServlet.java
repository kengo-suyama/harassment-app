package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.ConsultationRepository;
import com.example.harassment.repository.RepositoryProvider;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class ConsultMyServlet extends HttpServlet {
    private static final ConsultationRepository repo = RepositoryProvider.get();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");
        Consultation c;
        if (token != null && !token.trim().isEmpty()) {
            c = repo.findByAccessKey(token.trim());
        } else {
            int id = 0;
            try { id = Integer.parseInt(request.getParameter("id")); } catch (Exception ignored) {}
            c = repo.findById(id);
        }
        if (c != null) {
            repo.markChatRead(c.getId(), "REPORTER");
        }
        request.setAttribute("consultation", c);

        request.getRequestDispatcher("/consult/my.jsp").forward(request, response);
    }
}
