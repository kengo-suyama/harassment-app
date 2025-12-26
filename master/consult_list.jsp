<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,com.example.harassment.model.Consultation" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>全権管理者画面 - 対応結果一覧</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container-fluid">
        <a href="<%= request.getContextPath() %>/" class="navbar-brand">
            ハラスメント相談システム
        </a>
        <span class="navbar-text text-white">全権管理者画面</span>
    </div>
</nav>

<div class="container">
    <h1 class="h4 mb-3">対応結果一覧（確定済のみ）</h1>

    <%
        List<Consultation> consultations =
                (List<Consultation>) request.getAttribute("consultations");
    %>

    <div class="table-responsive">
    <table class="table table-sm table-striped align-middle">
        <thead>
        <tr>
            <th>ID</th>
            <th>相談日</th>
            <th>氏名</th>
            <th>概要</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <%
            if (consultations == null || consultations.isEmpty()) {
        %>
        <tr>
            <td colspan="5" class="text-center text-muted">
                まだ確定した対応結果はありません。
            </td>
        </tr>
        <%
            } else {
                for (Consultation c : consultations) {
        %>
        <tr>
            <td><%= c.getId() %></td>
            <td><%= c.getSheetDate() %></td>
            <td><%= c.getConsultantName() %></td>
            <td><%= c.getSummary() %></td>
            <td>
                <a href="<%= request.getContextPath() %>/master/consult/followup/view?id=<%= c.getId() %>"
                   class="btn btn-sm btn-outline-primary">
                    結果を見る
                </a>
            </td>
        </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>
    </div>

    <a href="<%= request.getContextPath() %>/" class="btn btn-outline-secondary btn-sm">
        トップへ戻る
    </a>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
