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

    private static final String FORM_JSP = "/consult/consult_form.jsp";

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        request.getRequestDispatcher(FORM_JSP)
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // 「戻って修正する」から POST されたときも同じ JSP を表示する
        request.setCharacterEncoding("UTF-8");
        request.getRequestDispatcher(FORM_JSP)
               .forward(request, response);
    }
}
