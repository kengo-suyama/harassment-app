package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.ConsultationRepository;
import com.example.harassment.repository.RepositoryProvider;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 相談者用の照合キー確認
 * GET : 入力フォーム or 照合キー付きの表示
 * POST: 照合キー入力 -> リダイレクト
 */
public class ConsultStatusServlet extends HttpServlet {

    private static final ConsultationRepository repository = RepositoryProvider.get();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || "/".equals(pathInfo) || pathInfo.trim().isEmpty()) {
            request.getRequestDispatcher("/consult/status.jsp").forward(request, response);
            return;
        }

        String token = pathInfo.startsWith("/") ? pathInfo.substring(1) : pathInfo;
        Consultation c = repository.findByAccessKey(token.trim());
        if (c == null) {
            request.setAttribute("errorMessage", "照合キーが一致しませんでした。");
            request.getRequestDispatcher("/consult/status.jsp").forward(request, response);
            return;
        }

        repository.markChatRead(c.getId(), "REPORTER");
        request.setAttribute("consultation", c);
        request.getRequestDispatcher("/consult/status_view.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String token = request.getParameter("token");
        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("errorMessage", "照合キーを入力してください。");
            request.getRequestDispatcher("/consult/status.jsp").forward(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/consult/status/" + token.trim());
    }
}
