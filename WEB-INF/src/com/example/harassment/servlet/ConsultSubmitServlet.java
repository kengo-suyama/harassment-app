package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.MemoryConsultationRepository;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;

public class ConsultSubmitServlet extends HttpServlet {

    private static final MemoryConsultationRepository repo = MemoryConsultationRepository.getInstance();

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
        c.setSummary(request.getParameter("summary"));

        c.setReportedExists(request.getParameter("reportedExists")); // NONE/SOMEONE
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

        c.setStatus("NEW");

        repo.save(c);

        request.setAttribute("consultation", c);
        request.getRequestDispatcher("/consult/thanks.jsp").forward(request, response);
    }
}
