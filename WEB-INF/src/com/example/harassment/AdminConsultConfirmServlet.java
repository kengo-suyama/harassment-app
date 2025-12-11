package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.MemoryConsultationRepository;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class AdminConsultConfirmServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                Consultation c = MemoryConsultationRepository.findById(id);
                if (c != null) {
                    c.setAdminChecked(true);   // ← このメソッドは Consultation に用意しておいてください
                    MemoryConsultationRepository.save(c);
                }
            } catch (NumberFormatException e) {
                // 必要ならログ出力
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/consult/list");
    }
}
