package com.example.harassment.servlet;

import com.example.harassment.repository.ConsultationRepository;
import com.example.harassment.repository.RepositoryProvider;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class MasterChatSendServlet extends HttpServlet {

    private static final ConsultationRepository repository =
        RepositoryProvider.get();


    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (!LoginUtil.isMaster(session)) {
            response.sendRedirect(request.getContextPath() + "/master/login");
            return;
        }
        int id = Integer.parseInt(request.getParameter("id"));
        String text = request.getParameter("text");

        if (text != null && !text.trim().isEmpty()) {
            repository.addChat(id, "MASTER", text.trim());
            AuditLogger.log(request, "UPDATE", "CONSULTATION", id, "chat_send");
        }
        response.sendRedirect(request.getContextPath() + "/master/consult/followup/view?id=" + id);
    }
}

