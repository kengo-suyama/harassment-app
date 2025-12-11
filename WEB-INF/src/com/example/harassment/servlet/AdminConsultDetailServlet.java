package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.MemoryConsultationRepository;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 管理者 / マスター用 相談詳細画面サーブレット
 */
public class AdminConsultDetailServlet extends HttpServlet {

    private static final MemoryConsultationRepository repository = new MemoryConsultationRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // ===== 権限チェック（管理者 or マスターのみ） =====
        HttpSession session = request.getSession(false);
        String role = null;
        if (session != null) {
            role = (String) session.getAttribute("loginRole");
        }

        if (role == null || !(role.equals("ADMIN") || role.equals("MASTER"))) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // ===== パラメータから ID を取得 =====
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            // ID が無い → 一覧に戻す
            response.sendRedirect(request.getContextPath() + "/admin/consult/list");
            return;
        }

        // ★★ ここを long ではなく int にするのがポイント！ ★★
        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            // 数値変換できなければ一覧に戻すか、エラーページへ
            response.sendRedirect(request.getContextPath() + "/admin/consult/list");
            return;
        }

        // ===== リポジトリから1件取得 =====
        Consultation consultation = repository.findById(id);

        if (consultation == null) {
            // 該当データ無し → 専用 JSP か一覧に戻す
            request.setAttribute("message", "指定されたIDの相談は見つかりませんでした。");
            request.getRequestDispatcher("/admin/consult_not_found.jsp")
                    .forward(request, response);
            return;
        }

        // ===== 画面に渡す =====
        request.setAttribute("consultation", consultation);
        request.setAttribute("loginRole", role);

        // ===== 詳細画面へフォワード =====
        request.getRequestDispatcher("/admin/consult_detail.jsp")
                .forward(request, response);
    }
}
