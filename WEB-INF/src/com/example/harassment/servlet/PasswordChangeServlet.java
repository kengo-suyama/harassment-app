package com.example.harassment.servlet;

import com.example.harassment.repository.UserRepository;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class PasswordChangeServlet extends HttpServlet {

    private static final UserRepository users = new UserRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String role = (String) session.getAttribute("loginRole");
        if (role == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        request.setAttribute("role", role);
        request.getRequestDispatcher("/password_change.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String role = (String) session.getAttribute("loginRole");
        if (role == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword     = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        String pwError = validateNewPassword(newPassword);
        if (pwError != null) {
            request.setAttribute("role", role);
            request.setAttribute("error", pwError);
            request.getRequestDispatcher("/password_change.jsp").forward(request, response);
            return;
        }

        if (newPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("role", role);
            request.setAttribute("error", "新しいパスワードと確認用パスワードが一致しません。");
            request.getRequestDispatcher("/password_change.jsp").forward(request, response);
            return;
        }

        Integer userId = (Integer) session.getAttribute("loginUserId");
        if (userId == null || userId <= 0) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        boolean changed = users.changePassword(userId, currentPassword, newPassword);
        if (!changed) {
            request.setAttribute("role", role);
            request.setAttribute("error", "現在のパスワードが正しくありません。");
            request.getRequestDispatcher("/password_change.jsp").forward(request, response);
            return;
        }

        request.setAttribute("role", role);
        request.setAttribute("message", "パスワードを変更しました。");
        request.getRequestDispatcher("/password_change.jsp").forward(request, response);
    }

    private String validateNewPassword(String password) {
        if (password == null || password.trim().isEmpty()) {
            return "新しいパスワードを入力してください。";
        }
        String p = password.trim();
        if (p.length() < 8 || p.length() > 64) {
            return "パスワードは8〜64文字で入力してください。";
        }
        boolean hasLetter = p.matches(".*[A-Za-z].*");
        boolean hasDigit = p.matches(".*[0-9].*");
        if (!hasLetter || !hasDigit) {
            return "パスワードは英字と数字の両方を含めてください。";
        }
        return null;
    }
}
