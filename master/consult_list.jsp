<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,com.example.harassment.model.Consultation" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>マスター画面 - 相談一覧</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container-fluid">
        <a href="<%= request.getContextPath() %>/" class="navbar-brand">ハラスメント相談システム</a>
        <span class="navbar-text text-white">マスター画面</span>
    </div>
</nav>

<div class="container">
    <h1 class="h4 mb-3">相談一覧（マスター用）</h1>

    <%
        List<Consultation> consultations =
                (List<Consultation>) request.getAttribute("consultations");
    %>

    <table class="table table-sm table-striped">
        <thead>
        <tr>
            <th>ID</th>
            <th>シート記入日</th>
            <th>相談者</th>
            <th>相談概要</th>
        </tr>
        </thead>
        <tbody>
        <%
            if (consultations == null || consultations.isEmpty()) {
        %>
            <tr>
                <td colspan="4" class="text-center text-muted">
                    まだ相談は登録されていません。
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
            </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>

    <a href="<%= request.getContextPath() %>/" class="btn btn-outline-secondary btn-sm">
        トップへ戻る
    </a>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
