package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.MemoryConsultationRepository;

import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 管理者が「内容確認済」にチェックするためのサーブレット
 */
// @WebServlet("/admin/consult/check")
public class AdminConsultCheckServlet extends HttpServlet {

    private final MemoryConsultationRepository repository = new MemoryConsultationRepository();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        try {
            int id = Integer.parseInt(idStr);
            Consultation c = repository.findById(id);
            if (c != null) {
                c.setAdminChecked(true);
            }
        } catch (NumberFormatException e) {
            // 何もしない（ログだけ出したければここで）
        }

        response.sendRedirect(request.getContextPath() + "/admin/consult/list");
    }
}
