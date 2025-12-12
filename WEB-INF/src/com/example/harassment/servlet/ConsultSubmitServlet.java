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

        // ===== フォームの値を詰める =====
        c.setSheetDate(request.getParameter("sheetDate"));
        c.setConsultantName(request.getParameter("consultantName"));
        c.setSummary(request.getParameter("summary"));

        c.setReportedExists(request.getParameter("reportedExists"));
        c.setReportedPerson(request.getParameter("reportedPerson"));
        c.setReportedAt(request.getParameter("reportedAt"));
        c.setFollowUp(request.getParameter("followUp"));

        String mentalScaleStr = request.getParameter("mentalScale");
        int mentalScale = 0;
        try {
            mentalScale = Integer.parseInt(mentalScaleStr);
        } catch (NumberFormatException e) {
            // 変換できなければ 0 のまま
        }
        c.setMentalScale(mentalScale);
        c.setMentalDetail(request.getParameter("mentalDetail"));

        // 未来の希望（チェックボックス複数）をカンマ区切りにする
        String[] futureRequests = request.getParameterValues("futureRequest");
        if (futureRequests != null && futureRequests.length > 0) {
            c.setFutureRequest(String.join(",", futureRequests));
        } else {
            c.setFutureRequest("");
        }
        c.setFutureRequestOtherDetail(
                request.getParameter("futureRequestOtherDetail")
        );

        c.setSharePermission(request.getParameter("sharePermission"));
        c.setShareLimitedTargets(
                request.getParameter("shareLimitedTargets")
        );

        // 管理者対応欄の初期化
        c.setAdminChecked(false);
        c.setFollowUpDraft(null);
        c.setFollowUpAction(null);

        // ステータス初期値（今後拡張予定）
        c.setStatus("NEW"); // 未対応

        // ===== 保存 =====
        repository.save(c);

        // 確認用に 1件だけ渡してサンクス画面へ
        request.setAttribute("consultation", c);
        request.getRequestDispatcher("/consult/thanks.jsp")
       .forward(request, response);

    }
}
