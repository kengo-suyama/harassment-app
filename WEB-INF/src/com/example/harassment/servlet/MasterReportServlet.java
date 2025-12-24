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

    private static final Map<String, List<String>> CATEGORY_MAP = buildCategoryMap();
    private static final List<String> CATEGORY_ORDER = buildCategoryOrder();

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
                AuditLogger.log(request, "EXPORT", "REPORT", null, "month=" + year + "-" + month);
                writeCsv(response, year, month, monthResult);
            } else {
                AuditLogger.log(request, "EXPORT", "REPORT", null, "year=" + year);
                writeCsv(response, year, null, yearResult);
            }
            return;
        }

        AuditLogger.log(request, "VIEW", "REPORT", null, "year=" + year + ",month=" + month);
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
                    String category = extractCategory(summary);
                    if (category.isEmpty()) {
                        String text = safe(summary) + " " + safe(followup);
                        category = classify(text);
                    }
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
            if (!result.categoryCounts.containsKey(row.category)) {
                result.categoryCounts.put(row.category, 0);
            }
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
        if (t.contains("セクハラ")) return "ハラスメント / セクシュアルハラスメント（セクハラ）";
        if (t.contains("パワハラ")) return "ハラスメント / パワーハラスメント（パワハラ）";
        if (t.contains("モラハラ")) return "ハラスメント / モラルハラスメント（モラハラ）";
        if (t.contains("マタハラ")) return "ハラスメント / マタニティハラスメント（マタハラ）";
        if (t.contains("パタハラ")) return "ハラスメント / パタニティハラスメント（パタハラ）";
        if (t.contains("いじめ") || t.contains("虐め")) return "人間関係・いじめ / いじめ／嫌がらせ";
        if (t.contains("無視")) return "人間関係・いじめ / 無視／仲間外れ";
        if (t.contains("暴言") || t.contains("罵倒")) return "人間関係・いじめ / 侮辱・暴言・人格否定";
        if (t.contains("残業") || t.contains("休日出勤")) return "労務（勤務/残業/休暇） / 無理な納期・残業強要";
        if (t.contains("有給")) return "労務（勤務/残業/休暇） / 有給が取れない／取らせない";
        if (t.contains("賃金") || t.contains("残業代")) return "評価・処遇 / 賃金未払い／残業代未払い";
        if (t.contains("不正") || t.contains("横領") || t.contains("改ざん")) return "不正・コンプラ / 改ざん・虚偽報告";
        if (t.contains("個人情報") || t.contains("SNS")) return "情報・SNS / 個人情報の漏えい／誤送信";
        if (t.contains("安全") || t.contains("事故")) return "安全・環境 / 安全対策不足（転倒・感染・防災）";
        if (t.contains("カスハラ") || t.contains("顧客")) return "顧客/利用者対応（カスハラ等） / 利用者・患者からの暴言/暴力";
        if (t.contains("メンタル") || t.contains("不眠")) return "メンタル/健康 / メンタル不調（うつ不安等）";
        return "その他 / どれにも当てはまらない（その他）";
    }

    private String extractCategory(String summary) {
        if (summary == null || summary.trim().isEmpty()) return "";
        String text = summary.trim();
        if (!text.startsWith("CATEGORY:")) return "";
        int lineEnd = text.indexOf('\n');
        if (lineEnd < 0) lineEnd = text.length();
        return text.substring("CATEGORY:".length(), lineEnd).trim();
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
                out.println(c + "," + result.categoryCounts.getOrDefault(c, 0));
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

    private static Map<String, List<String>> buildCategoryMap() {
        Map<String, List<String>> map = new LinkedHashMap<>();
        map.put("ハラスメント", Arrays.asList(
                "セクシュアルハラスメント（セクハラ）",
                "パワーハラスメント（パワハラ）",
                "モラルハラスメント（モラハラ）",
                "マタニティハラスメント（マタハラ）",
                "パタニティハラスメント（パタハラ）",
                "ケアハラスメント（介護・看護・通院等への配慮不足）",
                "エイジハラスメント（年齢）",
                "ルッキズム（容姿）",
                "ジェンダーハラスメント（性別役割の押し付け等）",
                "SOGIハラスメント（性的指向・性自認）",
                "カスタマーハラスメント（カスハラ：顧客・利用者から）",
                "アルコールハラスメント（飲酒強要等）",
                "スモークハラスメント（受動喫煙・喫煙強要）",
                "テクノロジーハラスメント（IT/スキル差を嘲る、デジタル強要）",
                "リモートハラスメント（オンラインでの圧・監視・嫌がらせ）"
        ));
        map.put("人間関係・いじめ", Arrays.asList(
                "いじめ／嫌がらせ",
                "無視／仲間外れ",
                "陰口／悪評の流布",
                "侮辱・暴言・人格否定",
                "からかい／嘲笑",
                "嫌なあだ名・呼び方",
                "連絡を回さない／情報遮断",
                "業務から外す／干す",
                "過剰な監視・詮索",
                "私生活への過干渉",
                "チーム内の派閥・対立"
        ));
        map.put("労務（勤務/残業/休暇）", Arrays.asList(
                "業務量が過多（キャパ超え）",
                "不公平な業務配分",
                "無理な納期・残業強要",
                "休日出勤の強要",
                "休憩が取れない",
                "有給が取れない／取らせない",
                "早出・サービス残業の強要",
                "シフトが不公平（希望が通らない等）",
                "突然のシフト変更",
                "業務範囲外の仕事の強要",
                "危険作業の強要／安全配慮不足",
                "体調不良でも休ませない"
        ));
        map.put("評価・処遇", Arrays.asList(
                "不当な評価・査定",
                "昇給・昇格に不満／不透明",
                "降格・配置転換が納得できない",
                "賃金未払い／残業代未払い",
                "手当・交通費の不支給",
                "契約更新されない／雇止め不安",
                "退職強要（辞めろと言われる等）",
                "懲戒・処分が不当だと感じる",
                "正社員/非正規で扱いが不公平"
        ));
        map.put("不正・コンプラ", Arrays.asList(
                "横領・金銭不正",
                "会社備品の私物化",
                "経費不正",
                "改ざん・虚偽報告",
                "取引先との癒着",
                "利益相反",
                "法令違反（労基/安全/個人情報等）",
                "ハラスメントの隠蔽",
                "反社・不適切取引の疑い"
        ));
        map.put("情報・SNS", Arrays.asList(
                "個人情報の漏えい／誤送信",
                "機密情報の持ち出し",
                "社内チャットでの誹謗中傷",
                "SNSでの晒し・悪口",
                "勝手な写真撮影・共有",
                "監視・盗み見（画面/メール/スマホ）",
                "パスワードの共有強要"
        ));
        map.put("安全・環境", Arrays.asList(
                "職場の衛生が悪い",
                "温度/騒音/臭い等の環境問題",
                "休憩室が使えない",
                "設備不良・故障放置",
                "安全対策不足（転倒・感染・防災）",
                "防護具・備品が足りない",
                "事故・ヒヤリハットが多い"
        ));
        map.put("顧客/利用者対応（カスハラ等）", Arrays.asList(
                "利用者・患者からの暴言/暴力",
                "家族からのクレーム・過剰要求",
                "セクハラ行為（利用者/患者）",
                "不当な返金要求・土下座要求等",
                "ルール無視（面会/撮影/持込）",
                "脅迫・口コミで脅す"
        ));
        map.put("メンタル/健康", Arrays.asList(
                "ストレス・不眠・体調悪化",
                "メンタル不調（うつ不安等）",
                "パニック・出社困難",
                "職場復帰の不安",
                "産業医/面談希望",
                "休職/復職の相談"
        ));
        map.put("その他", Arrays.asList(
                "どれにも当てはまらない（その他）",
                "まず話を聞いてほしい（相談のみ）",
                "匿名で相談したい（匿名希望）",
                "緊急（今すぐ対応希望）"
        ));
        return map;
    }

    private static List<String> buildCategoryOrder() {
        List<String> list = new ArrayList<>();
        for (Map.Entry<String, List<String>> e : CATEGORY_MAP.entrySet()) {
            for (String sub : e.getValue()) {
                list.add(e.getKey() + " / " + sub);
            }
        }
        return list;
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
