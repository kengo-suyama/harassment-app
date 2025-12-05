package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.ConsultationRepository;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * 相談フォームの送信を受け取り、相談を登録するサーブレット。
 * POST /consult/submit で呼び出される想定。
 */
public class ConsultSubmitServlet extends HttpServlet {

    // 簡易的に new して使う（static リストなのでインスタンスは共有）
    private final ConsultationRepository repo = new ConsultationRepository();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 文字化け防止
        req.setCharacterEncoding("UTF-8");

        // フォームから値を取得
        String sheetDate       = req.getParameter("sheetDate");
        String consultantName  = req.getParameter("consultantName");
        String summary         = req.getParameter("summary");
        String sharePermission = req.getParameter("sharePermission");

        // モデルに詰める
        Consultation c = new Consultation();
        c.setSheetDate(sheetDate);
        c.setConsultantName(consultantName);
        c.setSummary(summary);
        c.setSharePermission(sharePermission);

        // 保存（受付番号が採番される）
        repo.save(c);

        // 完了画面に渡す値（受付番号など）
        req.setAttribute("savedId", c.getId());

        // 完了JSPへフォワード
        req.getRequestDispatcher("/consult_thanks.jsp").forward(req, resp);
    }
}

    

