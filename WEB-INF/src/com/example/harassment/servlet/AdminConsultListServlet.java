package com.example.harassment.servlet;

import com.example.harassment.repository.ConsultationRepository;
import com.example.harassment.repository.RepositoryProvider;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class AdminConsultListServlet extends HttpServlet {

    private static final ConsultationRepository repo = RepositoryProvider.get();

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

        // ★repo側に findAll() がある想定（無い場合はあなたのrepoメソッド名に合わせてください）
        request.setAttribute("consultations", repo.findAll());

        request.getRequestDispatcher("/admin/consult/list.jsp").forward(request, response);
    }
}
