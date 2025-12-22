<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,com.example.harassment.model.Consultation" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>管理者画面 - 相談一覧</title>
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
        <span class="navbar-text text-white">管理者画面</span>
    </div>
</nav>

<div class="container">
    <h1 class="h4 mb-3">相談一覧</h1>

    <%
        List<Consultation> consultations =
                (List<Consultation>) request.getAttribute("consultations");
    %>

    <table class="table table-sm table-striped align-middle">
        <thead>
        <tr>
            <th>ID</th>
            <th>相談日</th>
            <th>氏名</th>
            <th>概要</th>
            <th>確認</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <%
            if (consultations == null || consultations.isEmpty()) {
        %>
        <tr>
            <td colspan="6" class="text-center text-muted">
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
            <td>
                <%
                    if (c.isAdminChecked()) {
                %>
                <span class="badge bg-success">確認済</span>
                <%
                    } else {
                %>
                <span class="badge bg-secondary">未確認</span>
                <%
                    }
                %>
            </td>
            <td>
                <!-- 詳細ボタン -->
                <a href="<%= request.getContextPath() %>/admin/consult/detail?id=<%= c.getId() %>"
                   class="btn btn-sm btn-outline-primary">
                    詳細
                </a>

                <!-- 確認チェックボタン（未確認のときだけ） -->
                <%
                    if (!c.isAdminChecked()) {
                %>
                <form method="post"
                      action="<%= request.getContextPath() %>/admin/consult/check"
                      class="d-inline">
                    <input type="hidden" name="id" value="<%= c.getId() %>">
                    <button type="submit" class="btn btn-sm btn-outline-success">
                        確認チェック
                    </button>
                </form>
                <%
                    }
                %>
            </td>
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
