package com.example.harassment.servlet;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * 相談フォーム表示用サーブレット
 *
 * /consult/form (GET/POST) で相談フォームを表示する。
 * JSP は /consult/consult_form.jsp を利用。
 */
public class ConsultFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        request.getRequestDispatcher("/consult/consult_form.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // confirm から「戻って修正する」で POST された値をそのままフォームへ
        request.setCharacterEncoding("UTF-8");
        request.getRequestDispatcher("/consult/consult_form.jsp")
               .forward(request, response);
    }
}
