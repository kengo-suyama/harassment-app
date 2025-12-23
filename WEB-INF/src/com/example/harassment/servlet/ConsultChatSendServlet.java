package com.example.harassment.servlet;

import com.example.harassment.repository.ConsultationRepository;
import com.example.harassment.repository.RepositoryProvider;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class ConsultChatSendServlet extends HttpServlet {
    private static final ConsultationRepository repo = RepositoryProvider.get();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String token = request.getParameter("token");
        String idStr = request.getParameter("id");
        int id = 0;
        try { id = Integer.parseInt(idStr); } catch (Exception ignored) {}

        String text = request.getParameter("text");
        if (text == null || text.trim().isEmpty()) {
            text = request.getParameter("message");
        }

        if (token != null && !token.trim().isEmpty()) {
            com.example.harassment.model.Consultation c = repo.findByAccessKey(token.trim());
            if (c != null) {
                id = c.getId();
            }
        }

        if (id > 0) {
            repo.appendChat(id, "REPORTER", text);
        }

        if (token != null && !token.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/consult/status/" + token.trim());
        } else {
            response.sendRedirect(request.getContextPath() + "/consult/status");
        }
    }
}
