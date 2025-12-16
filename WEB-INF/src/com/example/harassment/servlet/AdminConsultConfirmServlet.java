package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.MemoryConsultationRepository;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * 管理者：相談内容の確認/詳細へ遷移させる想定のサーブレット（例）
 * id を受け取り、相談を取得して JSP に渡す
 */
public class AdminConsultConfirmServlet extends HttpServlet {

    private static final MemoryConsultationRepository repository =
            MemoryConsultationRepository.getInstance();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String idStr = request.getParameter("id");
        int id = 0;
        try { id = Integer.parseInt(idStr); } catch (Exception ignore) {}

        Consultation c = repository.findById(id);

        if (c == null) {
            request.setAttribute("errorMessage", "相談情報が見つかりませんでした (id=" + id + ")");
        } else {
            request.setAttribute("consultation", c);
        }

        // 遷移先はあなたの構成に合わせて調整
        // 例：/admin/confirm.jsp など
        request.getRequestDispatcher("/admin/confirm.jsp")
               .forward(request, response);
    }
}
