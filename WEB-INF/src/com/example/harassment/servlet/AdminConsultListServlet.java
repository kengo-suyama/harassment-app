package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.MemoryConsultationRepository;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class AdminConsultListServlet extends HttpServlet {
    private static final MemoryConsultationRepository repo = MemoryConsultationRepository.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (!LoginUtil.isAdmin(session)) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String nameLike = request.getParameter("name");
        String from = request.getParameter("from");
        String to = request.getParameter("to");
        String sort = request.getParameter("sort");

        List<Consultation> list = repo.search(nameLike, from, to, sort);
        request.setAttribute("list", list);

        request.getRequestDispatcher("/admin/list.jsp").forward(request, response);
    }
}
