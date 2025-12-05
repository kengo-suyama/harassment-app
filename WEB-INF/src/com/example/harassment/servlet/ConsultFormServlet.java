package com.example.harassment.servlet;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class ConsultFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // ここを修正
        req.getRequestDispatcher("/consult_form.jsp").forward(req, resp);
        //  ※ consult_form.jsp が「harassment-app直下」にある前提です
    }
}
