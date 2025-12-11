package com.example.harassment.auth;

/**
 * 管理者 / マスターログイン用の簡易認証サービス（メモリ保存）
 * 本番では DB や外部認証に置き換えることを想定。
 */
public class AuthService {

    // デモ用の初期パスワード
    private static String adminPassword  = "admin123";   // 管理者
    private static String masterPassword = "master123";  // マスター

    // ==== ログインチェック ====

    public static boolean checkAdminLogin(String username, String password) {
        // 例: ユーザー名は固定「admin」のみ許可
        if (!"admin".equals(username)) {
            return false;
        }
        return adminPassword.equals(password);
    }

    public static boolean checkMasterLogin(String username, String password) {
        // 例: ユーザー名は固定「master」のみ許可
        if (!"master".equals(username)) {
            return false;
        }
        return masterPassword.equals(password);
    }

    // ==== パスワード変更 ====

    public static boolean changeAdminPassword(String currentPassword, String newPassword) {
        if (!adminPassword.equals(currentPassword)) {
            return false;
        }
        adminPassword = newPassword;
        return true;
    }

    public static boolean changeMasterPassword(String currentPassword, String newPassword) {
        if (!masterPassword.equals(currentPassword)) {
            return false;
        }
        masterPassword = newPassword;
        return true;
    }

    // （必要に応じて getter を追加しても良い）
    public static String getAdminPassword() {
        return adminPassword;
    }

    public static String getMasterPassword() {
        return masterPassword;
    }
}
