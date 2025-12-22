package com.example.harassment.servlet;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class ConsultFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // フラッシュ表示（下書き削除後など）
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object info = session.getAttribute("FLASH_INFO");
            if (info != null) {
                request.setAttribute("infoMessage", String.valueOf(info));
                session.removeAttribute("FLASH_INFO");
            }
            Object err = session.getAttribute("FLASH_ERROR");
            if (err != null) {
                request.setAttribute("errorMessage", String.valueOf(err));
                session.removeAttribute("FLASH_ERROR");
            }
        }

        request.getRequestDispatcher("/consult/form.jsp").forward(request, response);
    }

    // ★ confirm.jsp の「戻って修正する」がPOSTしてくるので、POSTでも同じ表示をする
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
