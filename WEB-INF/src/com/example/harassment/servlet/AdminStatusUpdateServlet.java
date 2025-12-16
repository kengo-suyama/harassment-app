package com.example.harassment.servlet;

import com.example.harassment.repository.MemoryConsultationRepository;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class AdminStatusUpdateServlet extends HttpServlet {

    private static final MemoryConsultationRepository repository =
        MemoryConsultationRepository.getInstance();


    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");

        repository.updateStatus(id, status);

        response.sendRedirect(request.getContextPath() + "/admin/consult/detail?id=" + id);
    }
}

