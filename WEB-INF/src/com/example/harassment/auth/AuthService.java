package com.example.harassment.auth;

public class AuthService {

    // 初期ユーザー名・パスワード（Tomcat起動中のみ有効）
    private static String adminUsername  = "admin";
    private static String adminPassword  = "admin1234";

    private static String masterUsername = "master";
    private static String masterPassword = "master1234";

    // ====== 管理者ログイン判定 ======
    public static boolean checkAdminLogin(String username, String password) {
        return adminUsername.equals(username) && adminPassword.equals(password);
    }

    // ====== マスターログイン判定 ======
    public static boolean checkMasterLogin(String username, String password) {
        return masterUsername.equals(username) && masterPassword.equals(password);
    }

    // ====== 管理者パスワード変更 ======
    public static synchronized boolean changeAdminPassword(
            String currentPassword, String newPassword) {

        if (!adminPassword.equals(currentPassword)) {
            return false;
        }
        adminPassword = newPassword;
        return true;
    }

    // ====== マスターパスワード変更 ======
    public static synchronized boolean changeMasterPassword(
            String currentPassword, String newPassword) {

        if (!masterPassword.equals(currentPassword)) {
            return false;
        }
        masterPassword = newPassword;
        return true;
    }
}
