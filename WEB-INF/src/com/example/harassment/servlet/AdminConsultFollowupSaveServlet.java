package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.MemoryConsultationRepository;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class AdminConsultFollowupSaveServlet extends HttpServlet {

    private static final MemoryConsultationRepository repository =
            new MemoryConsultationRepository();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("loginRole"))) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String idStr = request.getParameter("id");
        String mode = request.getParameter("mode"); // "draft" or "final"
        String followUpText = request.getParameter("followUpText");

        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/consult/list");
            return;
        }

        int id = Integer.parseInt(idStr);
        Consultation c = repository.findById(id);
        if (c == null) {
            response.sendRedirect(request.getContextPath() + "/admin/consult/list");
            return;
        }

        if ("draft".equals(mode)) {
            // 一時保存
            c.setFollowUpDraft(followUpText);
            // adminChecked はまだ false のままでもOK
        } else if ("final".equals(mode)) {
            // 確定
            c.setFollowUpAction(followUpText);
            c.setFollowUpDraft(null);
            c.setAdminChecked(true);
        }

        repository.save(c);

        // 詳細画面に戻る
        response.sendRedirect(
                request.getContextPath() + "/admin/consult/detail?id=" + c.getId()
        );
    }
}
