package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.ConsultationRepository;
import com.example.harassment.repository.RepositoryProvider;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 管理者向けの相談確認画面。
 */
public class AdminConsultConfirmServlet extends HttpServlet {

    private static final ConsultationRepository repository =
            RepositoryProvider.get();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (!LoginUtil.isAdmin(session)) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String idStr = request.getParameter("id");
        int id = 0;
        try { id = Integer.parseInt(idStr); } catch (Exception ignore) {}

        Consultation c = repository.findById(id);

        if (c == null) {
            request.setAttribute("errorMessage", "相談情報が見つかりませんでした。（id=" + id + "）");
        } else {
            request.setAttribute("consultation", c);
            AuditLogger.log(request, "VIEW", "CONSULTATION", c.getId(), "admin_confirm");
        }

        request.getRequestDispatcher("/admin/confirm.jsp")
               .forward(request, response);
    }
}
