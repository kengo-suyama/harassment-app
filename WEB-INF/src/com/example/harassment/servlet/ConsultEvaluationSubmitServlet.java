package com.example.harassment.servlet;

import com.example.harassment.repository.ConsultationRepository;
import com.example.harassment.repository.RepositoryProvider;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class ConsultEvaluationSubmitServlet extends HttpServlet {
    private static final ConsultationRepository repo = RepositoryProvider.get();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        int id = 0;
        try { id = Integer.parseInt(request.getParameter("id")); } catch (Exception ignored) {}
        String token = request.getParameter("token");

        int rating = 3;
        try { rating = Integer.parseInt(request.getParameter("rating")); } catch (Exception ignored) {}

        if (token == null || token.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/consult/status");
            return;
        }

        com.example.harassment.model.Consultation c = repo.findByAccessKey(token.trim());
        if (c == null || c.getId() != id) {
            response.sendRedirect(request.getContextPath() + "/consult/status");
            return;
        }

        repo.saveEvaluation(id, rating, request.getParameter("feedback"));

        if (token != null && !token.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/consult/status/" + token.trim());
        } else {
            response.sendRedirect(request.getContextPath() + "/consult/status");
        }
    }
}

