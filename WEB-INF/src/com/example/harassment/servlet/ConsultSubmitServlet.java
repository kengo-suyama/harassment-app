package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.ConsultationRepository;
import com.example.harassment.repository.RepositoryProvider;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
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
        String major = request.getParameter("summaryMajor");
        String sub = request.getParameter("summarySub");
        String detail = request.getParameter("summaryDetail");
        c.setSummary(buildSummary(major, sub, detail));

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

        // 送信成功したら下書きを必ず削除
        HttpSession s = request.getSession(false);
        if (s != null) s.removeAttribute("CONSULT_DRAFT");

        request.setAttribute("consultation", c);
        request.getRequestDispatcher("/consult/thanks.jsp").forward(request, response);
    }

    private String buildSummary(String major, String sub, String detail) {
        String m = safe(major);
        String s = safe(sub);
        String d = safe(detail);
        if (m.isEmpty() && s.isEmpty()) return d;
        String category = m;
        if (!s.isEmpty()) {
            category = m.isEmpty() ? s : (m + " / " + s);
        }
        return "CATEGORY: " + category + "\nDETAIL:\n" + d;
    }

    private String safe(String v) {
        return v == null ? "" : v.trim();
    }
}
