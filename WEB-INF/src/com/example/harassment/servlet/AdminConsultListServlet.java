package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.MemoryConsultationRepository;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class AdminConsultListServlet extends HttpServlet {

    private final MemoryConsultationRepository repository =  new MemoryConsultationRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Consultation> list = repository.findAll();
        request.setAttribute("consultations", list);

        // ★ ここが JSP のパス（先頭スラッシュ + /admin/consult_list.jsp）
        request.getRequestDispatcher("/admin/consult_list.jsp")
               .forward(request, response);
    }
}
