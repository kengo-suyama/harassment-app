package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.ConsultationRepository;
import com.example.harassment.repository.RepositoryProvider;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;

public class ConsultSubmitServlet extends HttpServlet {

    private static final ConsultationRepository repo = RepositoryProvider.get();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/consult/form");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Consultation c = new Consultation();

        String sheetDate = request.getParameter("sheetDate");
        if (sheetDate == null || sheetDate.trim().isEmpty()) {
            sheetDate = LocalDate.now().toString();
        }
        c.setSheetDate(sheetDate);

        c.setConsultantName(request.getParameter("consultantName"));
        c.setContactEmail(request.getParameter("contactEmail"));
        c.setSummary(request.getParameter("summary"));

        c.setReportedExists(request.getParameter("reportedExists"));
        c.setReportedPerson(request.getParameter("reportedPerson"));
        c.setReportedAt(request.getParameter("reportedAt"));
        c.setFollowUp(request.getParameter("followUp"));

        int mentalScale = 0;
        String ms = request.getParameter("mentalScale");
        if (ms != null && !ms.trim().isEmpty()) {
            try { mentalScale = Integer.parseInt(ms.trim()); } catch (Exception ignored) {}
        }
        c.setMentalScale(mentalScale);
        c.setMentalDetail(request.getParameter("mentalDetail"));

        String[] futureRequests = request.getParameterValues("futureRequest");
        c.setFutureRequest((futureRequests != null && futureRequests.length > 0) ? String.join(",", futureRequests) : "");
        c.setFutureRequestOtherDetail(request.getParameter("futureRequestOtherDetail"));

        c.setSharePermission(request.getParameter("sharePermission"));
        c.setShareLimitedTargets(request.getParameter("shareLimitedTargets"));

        c.setAdminChecked(false);
        c.setFollowUpDraft(null);
        c.setFollowUpAction(null);
        c.setStatus("UNCONFIRMED");

        repo.save(c);

        String contactEmail = request.getParameter("contactEmail");
        String statusUrl = buildStatusUrl(request, c.getId(), c.getAccessKey());
        request.setAttribute("statusUrl", statusUrl);
        if (!isBlank(contactEmail)) {
            request.setAttribute("mailNotice",
                    "メール送信機能は未設定のため、以下のリンクを手動で送付してください。");
            request.setAttribute("mailtoUrl", buildMailto(contactEmail, statusUrl, c.getId(), c.getAccessKey()));
        } else {
            request.setAttribute("mailNotice",
                    "経過確認用URLを控えてください。メール送信機能は未設定です。");
        }

        // ★送信成功したら下書きを必ず消す（固定）
        HttpSession s = request.getSession(false);
        if (s != null) s.removeAttribute("CONSULT_DRAFT");

        request.setAttribute("consultation", c);
        request.getRequestDispatcher("/consult/thanks.jsp").forward(request, response);

    }

    private static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private static String buildBaseUrl(HttpServletRequest request) {
        String scheme = request.getScheme();
        String host = request.getServerName();
        int port = request.getServerPort();
        boolean defaultPort = ("http".equalsIgnoreCase(scheme) && port == 80)
                || ("https".equalsIgnoreCase(scheme) && port == 443);
        String base = scheme + "://" + host + (defaultPort ? "" : ":" + port);
        return base + request.getContextPath();
    }

    private static String buildStatusUrl(HttpServletRequest request, int id, String key) {
        String base = buildBaseUrl(request);
        String safeKey = key == null ? "" : key;
        String encodedKey = URLEncoder.encode(safeKey, StandardCharsets.UTF_8);
        return base + "/consult/status?id=" + id + "&key=" + encodedKey;
    }

    private static String buildMailto(String to, String statusUrl, int id, String key) {
        String subject = "相談受付：経過確認URL";
        String body = "以下のURLから相談の経過をご確認ください。\n\n"
                + statusUrl + "\n\n"
                + "受付番号: " + id + "\n"
                + "照合キー: " + (key == null ? "" : key) + "\n";
        return "mailto:" + urlEncode(to)
                + "?subject=" + urlEncode(subject)
                + "&body=" + urlEncode(body);
    }

    private static String urlEncode(String value) {
        return URLEncoder.encode(value == null ? "" : value, StandardCharsets.UTF_8);
    }
}
