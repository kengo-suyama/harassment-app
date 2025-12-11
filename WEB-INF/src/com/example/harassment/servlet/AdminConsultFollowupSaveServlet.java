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
 * 管理者の対応内容を「一時保存」または「提出（確定）」として保存するサーブレット
 */
////@WebServlet("/admin/consult/followup/save")
public class AdminConsultFollowupSaveServlet extends HttpServlet {

    private final MemoryConsultationRepository repository =
            new MemoryConsultationRepository();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String idStr        = request.getParameter("id");
        String followUpText = request.getParameter("followUpText");
        String submitType   = request.getParameter("submitType"); // "draft" or "final"

        try {
            int id = Integer.parseInt(idStr);
            Consultation c = repository.findById(id);
            if (c != null) {

                if ("draft".equals(submitType)) {
                    // 一時保存：ドラフトに保存
                    c.setFollowUpDraft(followUpText);

                } else if ("final".equals(submitType)) {
                    // 提出：確定版として保存し、ドラフトはクリア
                    c.setFollowUpAction(followUpText);
                    c.setFollowUpDraft(null);
                    // 提出されたので「確認済」にしてしまう
                    c.setAdminChecked(true);
                }
            }
        } catch (NumberFormatException e) {
            // ID が不正な場合は何もしない
        }

        // 保存後は詳細画面へ戻す
        response.sendRedirect(request.getContextPath()
                              + "/admin/consult/detail?id=" + idStr);
    }
}
