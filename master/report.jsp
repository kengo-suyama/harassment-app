<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.harassment.servlet.MasterReportServlet.ReportResult" %>
<%@ page import="java.util.Map" %>
<%
    Integer year = (Integer) request.getAttribute("year");
    Integer month = (Integer) request.getAttribute("month");
    ReportResult yearResult = (ReportResult) request.getAttribute("yearResult");
    ReportResult monthResult = (ReportResult) request.getAttribute("monthResult");
    if (year == null) year = java.time.LocalDate.now().getYear();
    if (month == null) month = java.time.LocalDate.now().getMonthValue();
%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>全権管理者 - 年間/月間レポート</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container-fluid">
        <a class="navbar-brand" href="<%= request.getContextPath() %>/master/consult/list">全権管理者</a>
        <a class="btn btn-outline-light btn-sm" href="<%= request.getContextPath() %>/master/logout">ログアウト</a>
    </div>
</nav>

<div class="container">
    <div class="card shadow-sm mb-3">
        <div class="card-body">
            <h1 class="h5 mb-3">年間/月間レポート</h1>

            <form class="row g-2" method="get" action="<%= request.getContextPath() %>/master/report">
                <div class="col-md-3">
                    <label class="form-label small text-muted">年</label>
                    <input type="number" class="form-control" name="year" value="<%= year %>" min="2000" max="2100">
                </div>
                <div class="col-md-3">
                    <label class="form-label small text-muted">月</label>
                    <input type="number" class="form-control" name="month" value="<%= month %>" min="1" max="12">
                </div>
                <div class="col-md-3 d-grid">
                    <button class="btn btn-primary" type="submit">表示</button>
                </div>
                <div class="col-md-3 d-grid">
                    <a class="btn btn-outline-secondary"
                       href="<%= request.getContextPath() %>/master/report?year=<%= year %>&format=csv&scope=year">
                        年間CSV
                    </a>
                </div>
                <div class="col-md-3 d-grid">
                    <a class="btn btn-outline-secondary"
                       href="<%= request.getContextPath() %>/master/report?year=<%= year %>&month=<%= month %>&format=csv&scope=month">
                        月間CSV
                    </a>
                </div>
            </form>
        </div>
    </div>

    <div class="card shadow-sm mb-3">
        <div class="card-body">
            <h2 class="h6">年間サマリー（<%= year %>年）</h2>
            <div class="row g-3">
                <div class="col-md-4">
                    <div class="border rounded p-3 bg-white">
                        <div class="text-muted small">相談件数</div>
                        <div class="h4 mb-0"><%= yearResult != null ? yearResult.getTotalCount() : 0 %></div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="border rounded p-3 bg-white">
                        <div class="text-muted small">アンケート平均</div>
                        <div class="h4 mb-0"><%= yearResult != null ? String.format(java.util.Locale.US, "%.2f", yearResult.getAvgRating()) : "0.00" %></div>
                    </div>
                </div>
            </div>
            <p class="text-muted small mt-2 mb-0">アンケート平均は評価が入力された案件のみで算出します。</p>
        </div>
    </div>

    <div class="card shadow-sm mb-3">
        <div class="card-body">
            <h2 class="h6">月間サマリー（<%= year %>年 <%= month %>月）</h2>
            <div class="row g-3">
                <div class="col-md-4">
                    <div class="border rounded p-3 bg-white">
                        <div class="text-muted small">相談件数</div>
                        <div class="h4 mb-0"><%= monthResult != null ? monthResult.getTotalCount() : 0 %></div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="border rounded p-3 bg-white">
                        <div class="text-muted small">アンケート平均</div>
                        <div class="h4 mb-0"><%= monthResult != null ? String.format(java.util.Locale.US, "%.2f", monthResult.getAvgRating()) : "0.00" %></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="card shadow-sm mb-3">
        <div class="card-body">
            <h2 class="h6">カテゴリ別（年間）</h2>
            <div class="table-responsive">
                <table class="table table-sm">
                    <thead>
                    <tr>
                        <th>カテゴリ</th>
                        <th>件数</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (yearResult == null || yearResult.getCategoryCounts().isEmpty()) {
                    %>
                        <tr><td colspan="2" class="text-muted">データがありません。</td></tr>
                    <%
                        } else {
                            for (Map.Entry<String, Integer> e : yearResult.getCategoryCounts().entrySet()) {
                    %>
                        <tr>
                            <td><%= e.getKey() %></td>
                            <td><%= e.getValue() %></td>
                        </tr>
                    <%
                            }
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="card shadow-sm mb-3">
        <div class="card-body">
            <h2 class="h6">カテゴリ別（月間）</h2>
            <div class="table-responsive">
                <table class="table table-sm">
                    <thead>
                    <tr>
                        <th>カテゴリ</th>
                        <th>件数</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (monthResult == null || monthResult.getCategoryCounts().isEmpty()) {
                    %>
                        <tr><td colspan="2" class="text-muted">データがありません。</td></tr>
                    <%
                        } else {
                            for (Map.Entry<String, Integer> e : monthResult.getCategoryCounts().entrySet()) {
                    %>
                        <tr>
                            <td><%= e.getKey() %></td>
                            <td><%= e.getValue() %></td>
                        </tr>
                    <%
                            }
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <a class="btn btn-outline-secondary" href="<%= request.getContextPath() %>/master/consult/list">一覧へ戻る</a>
</div>

</body>
</html>
