package com.example.harassment.servlet;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

public final class DraftUtil {

    // ★ このキー名を全アプリで固定（保存も削除もここだけを見る）
    public static final String DRAFT_KEY = "CONSULT_DRAFT";

    private DraftUtil() {}

    /** request.getParameterMap() をコピーしてセッションへ保存 */
    public static void saveDraftToSession(HttpServletRequest request) {
        HttpSession session = request.getSession(true);

        Map<String, String[]> src = request.getParameterMap();
        Map<String, String[]> copy = new HashMap<>();

        for (Map.Entry<String, String[]> e : src.entrySet()) {
            String k = e.getKey();
            String[] v = e.getValue();
            if (v == null) {
                copy.put(k, null);
            } else {
                String[] vv = new String[v.length];
                System.arraycopy(v, 0, vv, 0, v.length);
                copy.put(k, vv);
            }
        }

        session.setAttribute(DRAFT_KEY, copy);
    }

    /** セッションの下書きを削除 */
    public static void clearDraft(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute(DRAFT_KEY);
        }
    }
}
