package com.example.harassment.servlet;

import com.example.harassment.repository.MemoryConsultationRepository;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class ConsultEvaluationSubmitServlet extends HttpServlet {
    private static final MemoryConsultationRepository repo = MemoryConsultationRepository.getInstance();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        int id = 0;
        try { id = Integer.parseInt(request.getParameter("id")); } catch (Exception ignored) {}

        int rating = 3;
        try { rating = Integer.parseInt(request.getParameter("rating")); } catch (Exception ignored) {}

        repo.saveEvaluation(id, rating, request.getParameter("feedback"));

        response.sendRedirect(request.getContextPath() + "/consult/my?id=" + id);
    }
}

