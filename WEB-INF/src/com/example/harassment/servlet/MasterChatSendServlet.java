package com.example.harassment.servlet;

import com.example.harassment.repository.MemoryConsultationRepository;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class MasterChatSendServlet extends HttpServlet {

    private static final MemoryConsultationRepository repository =
        MemoryConsultationRepository.getInstance();


    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        int id = Integer.parseInt(request.getParameter("id"));
        String text = request.getParameter("text");

        if (text != null && !text.trim().isEmpty()) {
            repository.addChat(id, "MASTER", text.trim());
        }
        response.sendRedirect(request.getContextPath() + "/master/consult/followup/view?id=" + id);
    }
}

