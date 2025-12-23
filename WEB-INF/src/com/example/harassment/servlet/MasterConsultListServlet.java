package com.example.harassment.servlet;

import com.example.harassment.model.Consultation;
import com.example.harassment.repository.ConsultationRepository;
import com.example.harassment.repository.RepositoryProvider;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class MasterConsultListServlet extends HttpServlet {
    private static final ConsultationRepository repo = RepositoryProvider.get();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (!LoginUtil.isMaster(session)) {
            response.sendRedirect(request.getContextPath() + "/master/login");
            return;
        }

        String nameLike = request.getParameter("name");
        String from = request.getParameter("from");
        String to = request.getParameter("to");
        String sort = request.getParameter("sort");
        String sortKey = sort;
        if (sort == null || sort.trim().isEmpty() || "newest".equals(sort)) {
            sortKey = "id_desc";
        } else if ("oldest".equals(sort)) {
            sortKey = "id_asc";
        } else if ("mental_desc".equals(sort)) {
            sortKey = "mental_desc";
        } else if ("unconfirmed".equals(sort)) {
            sortKey = "unconfirmed_first";
        }

        List<Consultation> list = repo.search(nameLike, from, to, sortKey);
        request.setAttribute("list", list);

        request.getRequestDispatcher("/master/list.jsp").forward(request, response);
    }
}
