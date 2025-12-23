package com.example.harassment.servlet;

import com.example.harassment.repository.DbUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class MasterReportServlet extends HttpServlet {

    private static final List<String> CATEGORY_ORDER = Arrays.asList(
            "いじめ",
            "無視",
            "暴言",
            "暴力",
            "セクハラ",
            "パワハラ",
            "モラハラ",
            "嫌がらせ",
            "誹謗中傷",
            "その他"
    );

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (!LoginUtil.isMaster(session)) {
            response.sendRedirect(request.getContextPath() + "/master/login");
            return;
        }

        LocalDate now = LocalDate.now();
        int year = parseInt(request.getParameter("year"), now.getYear());
        int month = parseInt(request.getParameter("month"), now.getMonthValue());

        String format = request.getParameter("format");
        String scope = request.getParameter("scope"); // year / month

        ReportResult yearResult = loadReport(year, null);
        ReportResult monthResult = loadReport(year, month);

        if ("csv".equalsIgnoreCase(format)) {
            if ("month".equalsIgnoreCase(scope)) {
                writeCsv(response, year, month, monthResult);
            } else {
                writeCsv(response, year, null, yearResult);
            }
            return;
        }

        request.setAttribute("year", year);
        request.setAttribute("month", month);
        request.setAttribute("yearResult", yearResult);
        request.setAttribute("monthResult", monthResult);
        request.getRequestDispatcher("/master/report.jsp").forward(request, response);
    }

    private int parseInt(String value, int def) {
        if (value == null || value.trim().isEmpty()) return def;
        try {
            return Integer.parseInt(value.trim());
        } catch (Exception e) {
            return def;
        }
    }

    private ReportResult loadReport(int year, Integer month) {
        ReportResult result = new ReportResult(year, month);

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT id, sheet_date, created_at, summary, follow_up_action, reporter_rating ");
        sql.append("FROM consultations ");
        sql.append("WHERE YEAR(COALESCE(sheet_date, DATE(created_at))) = ? ");
        if (month != null) {
            sql.append("AND MONTH(COALESCE(sheet_date, DATE(created_at))) = ? ");
        }
        sql.append("ORDER BY id");

        try (Connection con = DbUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            ps.setInt(1, year);
            if (month != null) {
                ps.setInt(2, month);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("id");
                    String summary = rs.getString("summary");
                    String followup = rs.getString("follow_up_action");
                    String text = safe(summary) + " " + safe(followup);
                    String category = classify(text);

                    ReportRow row = new ReportRow(id, category, rs.getInt("reporter_rating"));
                    result.rows.add(row);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        result.totalCount = result.rows.size();
        int ratingSum = 0;
        int ratingCount = 0;
        for (String c : CATEGORY_ORDER) {
            result.categoryCounts.put(c, 0);
        }
        for (ReportRow row : result.rows) {
            result.categoryCounts.put(row.category, result.categoryCounts.get(row.category) + 1);
            if (row.rating > 0) {
                ratingSum += row.rating;
                ratingCount += 1;
            }
        }
        result.avgRating = ratingCount > 0 ? ((double) ratingSum / ratingCount) : 0.0;

        return result;
    }

    private String classify(String text) {
        String t = safe(text);
        if (t.contains("いじめ") || t.contains("虐め")) return "いじめ";
        if (t.contains("無視")) return "無視";
        if (t.contains("暴言") || t.contains("罵倒")) return "暴言";
        if (t.contains("暴力") || t.contains("殴")) return "暴力";
        if (t.contains("セクハラ")) return "セクハラ";
        if (t.contains("パワハラ")) return "パワハラ";
        if (t.contains("モラハラ")) return "モラハラ";
        if (t.contains("嫌がらせ") || t.contains("嫌がらせ行為")) return "嫌がらせ";
        if (t.contains("誹謗中傷") || t.contains("中傷")) return "誹謗中傷";
        return "その他";
    }

    private void writeCsv(HttpServletResponse response, int year, Integer month, ReportResult result) throws IOException {
        String name = (month == null)
                ? "report_" + year + ".csv"
                : "report_" + year + "_" + String.format(Locale.US, "%02d", month) + ".csv";

        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=" + name);

        try (PrintWriter out = response.getWriter()) {
            out.print('\uFEFF');
            if (month == null) {
                out.println("year,total_count,avg_rating");
                out.println(year + "," + result.totalCount + "," + String.format(Locale.US, "%.2f", result.avgRating));
            } else {
                out.println("year,month,total_count,avg_rating");
                out.println(year + "," + month + "," + result.totalCount + "," + String.format(Locale.US, "%.2f", result.avgRating));
            }
            out.println();
            out.println("category,count");
            for (String c : CATEGORY_ORDER) {
                out.println(c + "," + result.categoryCounts.get(c));
            }
            out.println();
            out.println("id,category,rating");
            for (ReportRow row : result.rows) {
                out.println(row.id + "," + row.category + "," + (row.rating > 0 ? row.rating : ""));
            }
        }
    }

    private String safe(String s) {
        return (s == null) ? "" : s;
    }

    public static class ReportResult {
        private final int year;
        private final Integer month;
        private int totalCount;
        private double avgRating;
        private final Map<String, Integer> categoryCounts = new LinkedHashMap<>();
        private final List<ReportRow> rows = new ArrayList<>();

        ReportResult(int year, Integer month) {
            this.year = year;
            this.month = month;
        }

        public int getYear() { return year; }
        public Integer getMonth() { return month; }
        public int getTotalCount() { return totalCount; }
        public double getAvgRating() { return avgRating; }
        public Map<String, Integer> getCategoryCounts() { return categoryCounts; }
        public List<ReportRow> getRows() { return rows; }
    }

    public static class ReportRow {
        private final int id;
        private final String category;
        private final int rating;

        ReportRow(int id, String category, int rating) {
            this.id = id;
            this.category = category;
            this.rating = rating;
        }

        public int getId() { return id; }
        public String getCategory() { return category; }
        public int getRating() { return rating; }
    }
}
