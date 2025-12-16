package com.example.harassment.servlet;

import javax.servlet.http.*;
import java.io.IOException;

public class MasterLogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();
        response.sendRedirect(request.getContextPath() + "/master/login");
    }
}

