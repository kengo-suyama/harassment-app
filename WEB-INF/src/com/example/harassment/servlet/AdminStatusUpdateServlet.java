package com.example.harassment.servlet;

import com.example.harassment.repository.ConsultationRepository;
import com.example.harassment.repository.RepositoryProvider;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class AdminStatusUpdateServlet extends HttpServlet {

    private static final ConsultationRepository repository =
        RepositoryProvider.get();


    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (!LoginUtil.isAdmin(session)) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");

        repository.updateStatus(id, status);

        response.sendRedirect(request.getContextPath() + "/admin/consult/detail?id=" + id);
    }
}

