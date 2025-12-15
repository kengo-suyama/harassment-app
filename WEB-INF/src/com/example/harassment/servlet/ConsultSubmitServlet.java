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

        Consultation c = new Consultation();

        c.setSheetDate(request.getParameter("sheetDate"));
        c.setConsultantName(request.getParameter("consultantName"));
        c.setSummary(request.getParameter("summary"));

        c.setReportedExists(request.getParameter("reportedExists"));
        c.setReportedPerson(request.getParameter("reportedPerson"));
        c.setReportedAt(request.getParameter("reportedAt"));
        c.setFollowUp(request.getParameter("followUp"));

        int mentalScale = 0;
        try {
            String mentalScaleStr = request.getParameter("mentalScale");
            if (mentalScaleStr != null && !mentalScaleStr.isEmpty()) {
                mentalScale = Integer.parseInt(mentalScaleStr);
            }
        } catch (NumberFormatException e) {
            mentalScale = 0;
        }
        c.setMentalScale(mentalScale);
        c.setMentalDetail(request.getParameter("mentalDetail"));

        // チェックボックス複数 → カンマ区切り
        String[] futureRequests = request.getParameterValues("futureRequest");
        if (futureRequests != null && futureRequests.length > 0) {
            c.setFutureRequest(String.join(",", futureRequests));
        } else {
            c.setFutureRequest("");
        }
        c.setFutureRequestOtherDetail(request.getParameter("futureRequestOtherDetail"));

        c.setSharePermission(request.getParameter("sharePermission"));
        c.setShareLimitedTargets(request.getParameter("shareLimitedTargets"));

        // 管理者対応欄 初期化
        c.setAdminChecked(false);
        c.setFollowUpDraft(null);
        c.setFollowUpAction(null);

        // ステータス初期値
        c.setStatus("NEW");

        repository.save(c);

        request.setAttribute("consultation", c);
        request.getRequestDispatcher("/consult/thanks.jsp")
               .forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // GET直アクセスはフォームへ（405回避）
        response.sendRedirect(request.getContextPath() + "/consult/form");
    }
}
