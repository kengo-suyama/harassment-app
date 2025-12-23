package com.example.harassment.servlet;

import com.example.harassment.repository.UserRepository;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class PasswordResetServlet extends HttpServlet {

    private static final UserRepository users = new UserRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = getRole();
        request.setAttribute("role", role);
        request.setAttribute("roleLabel", roleLabel(role));
        request.getRequestDispatcher("/password_reset.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String role = getRole();
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (currentPassword == null || currentPassword.trim().isEmpty()) {
            request.setAttribute("error", "現在のパスワードを入力してください。");
            forward(role, request, response);
            return;
        }

        if (newPassword == null || newPassword.trim().isEmpty()) {
            request.setAttribute("error", "新しいパスワードを入力してください。");
            forward(role, request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "新しいパスワードと確認用パスワードが一致しません。");
            forward(role, request, response);
            return;
        }

        boolean updated = users.changePasswordByRole(role, currentPassword, newPassword);
        if (!updated) {
            request.setAttribute("error", "現在のパスワードが正しくありません。");
            forward(role, request, response);
            return;
        }

        request.setAttribute("message", "パスワードを変更しました。");
        forward(role, request, response);
    }

    private void forward(String role, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("role", role);
        request.setAttribute("roleLabel", roleLabel(role));
        request.getRequestDispatcher("/password_reset.jsp").forward(request, response);
    }

    private String getRole() {
        String role = getInitParameter("role");
        return (role == null || role.trim().isEmpty()) ? "ADMIN" : role.trim();
    }

    private String roleLabel(String role) {
        return "MASTER".equalsIgnoreCase(role) ? "全権管理者" : "管理者";
    }
}
