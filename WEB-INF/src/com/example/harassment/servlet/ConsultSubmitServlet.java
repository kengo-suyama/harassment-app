package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.MemoryConsultationRepository;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class ConsultSubmitServlet extends HttpServlet {

    // メモリリポジトリ（全リクエストで共有）
    private static final MemoryConsultationRepository repository =
            new MemoryConsultationRepository();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // ===== 1. フォームの値を取得 =====

        String sheetDate = request.getParameter("sheetDate");
        String consultantName = request.getParameter("consultantName");
        String summary = request.getParameter("summary");

        String reportedExists = request.getParameter("reportedExists");
        String reportedPerson = request.getParameter("reportedPerson");
        String reportedAt = request.getParameter("reportedAt");
        String followUp = request.getParameter("followUp");

        String mentalScaleParam = request.getParameter("mentalScale");
        Integer mentalScale = null;
        if (mentalScaleParam != null && !mentalScaleParam.isBlank()) {
            try {
                mentalScale = Integer.parseInt(mentalScaleParam);
            } catch (NumberFormatException e) {
                mentalScale = null;
            }
        }
        String mentalDetail = request.getParameter("mentalDetail");

        String[] futureRequestValues = request.getParameterValues("futureRequest");
        String futureRequest = null;
        if (futureRequestValues != null && futureRequestValues.length > 0) {
            futureRequest = String.join(",", futureRequestValues);
        }

        String futureRequestOtherDetail = request.getParameter("futureRequestOtherDetail");

        String sharePermission = request.getParameter("sharePermission");
        String shareLimitedTargets = request.getParameter("shareLimitedTargets");

        // ===== 2. モデルに詰める =====
        Consultation c = new Consultation();
        c.setSheetDate(sheetDate);
        c.setConsultantName(consultantName);
        c.setSummary(summary);

        c.setReportedExists(reportedExists);
        c.setReportedPerson(reportedPerson);
        c.setReportedAt(reportedAt);
        c.setFollowUp(followUp);

        c.setMentalScale(mentalScale);
        c.setMentalDetail(mentalDetail);

        c.setFutureRequest(futureRequest);
        c.setFutureRequestOtherDetail(futureRequestOtherDetail);

        c.setSharePermission(sharePermission);
        c.setShareLimitedTargets(shareLimitedTargets);

        // ===== 3. メモリ上に保存 =====
        repository.save(c);

       // ===== 4. 完了画面へフォワード =====
request.setAttribute("consultation", c);
request.getRequestDispatcher("/consult/consult_thanks.jsp")
       .forward(request, response);

 
    }
}
