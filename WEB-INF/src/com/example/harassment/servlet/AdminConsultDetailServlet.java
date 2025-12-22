package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.MemoryConsultationRepository;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class AdminConsultDetailServlet extends HttpServlet {

    private static final MemoryConsultationRepository repo = MemoryConsultationRepository.getInstance();

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession s = request.getSession(false);
        return s != null && "ADMIN".equals(String.valueOf(s.getAttribute("loginRole")));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String idStr = request.getParameter("id");
        Consultation c = null;
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idStr.trim());
                // ★repo側に findById(int) がある想定
                c = repo.findById(id);
            } catch (Exception ignored) {}
        }

        request.setAttribute("consultation", c);
        request.getRequestDispatcher("/admin/consult/detail.jsp").forward(request, response);
    }
}
