package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.MemoryConsultationRepository;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class ConsultSubmitServlet extends HttpServlet {

    private static final MemoryConsultationRepository repository =
            new MemoryConsultationRepository();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // ====== フォーム値の取得 ======
        String sheetDate = request.getParameter("sheetDate");
        String consultantName = request.getParameter("consultantName");
        String summary = request.getParameter("summary");

        String reportedExists = request.getParameter("reportedExists");
        String reportedPerson = request.getParameter("reportedPerson");
        String reportedAt = request.getParameter("reportedAt");
        String followUp = request.getParameter("followUp");

        String mentalScaleStr = request.getParameter("mentalScale");
        String mentalDetail = request.getParameter("mentalDetail");

        String[] futureRequestValues = request.getParameterValues("futureRequest");
        String futureRequestOtherDetail = request.getParameter("futureRequestOtherDetail");

        String sharePermission = request.getParameter("sharePermission");
        String shareLimitedTargets = request.getParameter("shareLimitedTargets");

        // ====== Consultation へ詰める ======
        Consultation c = new Consultation();

        c.setSheetDate(sheetDate);
        c.setConsultantName(consultantName);
        c.setSummary(summary);

        c.setReportedExists(reportedExists);
        c.setReportedPerson(reportedPerson);
        c.setReportedAt(reportedAt);
        c.setFollowUp(followUp);

        int mentalScale = 0;
        try {
            if (mentalScaleStr != null && !mentalScaleStr.isEmpty()) {
                mentalScale = Integer.parseInt(mentalScaleStr);
            }
        } catch (NumberFormatException e) {
            mentalScale = 0;
        }
        c.setMentalScale(mentalScale);
        c.setMentalDetail(mentalDetail);

        if (futureRequestValues != null && futureRequestValues.length > 0) {
            String joined = String.join(",", futureRequestValues);
            c.setFutureRequest(joined);
        } else {
            c.setFutureRequest(null);
        }
        c.setFutureRequestOtherDetail(futureRequestOtherDetail);

        c.setSharePermission(sharePermission);
        c.setShareLimitedTargets(shareLimitedTargets);

        // 管理者確認フラグ 初期値 false
        c.setAdminChecked(false);

        // ====== 保存 ======
        repository.save(c);

        // 完了画面へ
        request.setAttribute("consultation", c);
        request.getRequestDispatcher("/consult_thanks.jsp")
               .forward(request, response);
    }
}
