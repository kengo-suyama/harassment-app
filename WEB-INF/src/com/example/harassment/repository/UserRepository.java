package com.example.harassment.repository;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;

public class UserRepository {

    public int authenticate(String role, String email, String password) {
        String sql = "SELECT id, password_hash, password_algo, active FROM users WHERE role=? AND email=?";
        try (Connection con = DbUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, role);
            ps.setString(2, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return -1;
                if (rs.getInt("active") != 1) return -1;
                String hash = rs.getString("password_hash");
                String algo = rs.getString("password_algo");
                if (!matches(password, hash, algo)) return -1;
                int id = rs.getInt("id");
                updateLastLogin(id);
                return id;
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public boolean changePassword(int userId, String currentPassword, String newPassword) {
        String sql = "SELECT password_hash, password_algo FROM users WHERE id=?";
        try (Connection con = DbUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return false;
                String hash = rs.getString("password_hash");
                String algo = rs.getString("password_algo");
                if (!matches(currentPassword, hash, algo)) return false;
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        String newHash = hashPassword(newPassword);
        String update = "UPDATE users SET password_hash=?, password_algo=? WHERE id=?";
        try (Connection con = DbUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(update)) {
            ps.setString(1, newHash);
            ps.setString(2, "SHA256");
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public boolean changePasswordByRole(String role, String currentPassword, String newPassword) {
        String sql = "SELECT id, password_hash, password_algo FROM users WHERE role=? AND active=1";
        int userId = -1;
        String hash = null;
        String algo = null;
        try (Connection con = DbUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return false;
                userId = rs.getInt("id");
                hash = rs.getString("password_hash");
                algo = rs.getString("password_algo");
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        if (!matches(currentPassword, hash, algo)) return false;

        String newHash = hashPassword(newPassword);
        String update = "UPDATE users SET password_hash=?, password_algo=? WHERE id=?";
        try (Connection con = DbUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(update)) {
            ps.setString(1, newHash);
            ps.setString(2, "SHA256");
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private boolean matches(String password, String hash, String algo) {
        if (password == null || hash == null) return false;
        if ("SHA256".equalsIgnoreCase(algo) || algo == null || algo.isEmpty()) {
            return hashPassword(password).equalsIgnoreCase(hash);
        }
        return false;
    }

    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] bytes = md.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(bytes.length * 2);
            for (byte b : bytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("パスワードのハッシュ化に失敗しました。", e);
        }
    }

    private void updateLastLogin(int userId) {
        String sql = "UPDATE users SET last_login_at=? WHERE id=?";
        try (Connection con = DbUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception ignored) {
        }
    }
}
