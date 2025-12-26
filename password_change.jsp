<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String role = (String) request.getAttribute("role");
    String title = "ユーザー";
    if ("ADMIN".equals(role)) {
        title = "管理者";
    } else if ("MASTER".equals(role)) {
        title = "全権管理者";
    }
    String error = (String) request.getAttribute("error");
    String message = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>パスワード変更</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-4">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h1 class="h5 mb-3"><%= title %> パスワード変更</h1>

                    <% if (error != null) { %>
                        <div class="alert alert-danger"><%= error %></div>
                    <% } else if (message != null) { %>
                        <div class="alert alert-success"><%= message %></div>
                    <% } %>

                    <form action="<%= request.getContextPath() %>/password/change" method="post" autocomplete="off">
                        <div class="mb-3">
                            <label class="form-label">現在のパスワード</label>
                            <input type="password" class="form-control" name="currentPassword" autocomplete="current-password" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">新しいパスワード</label>
                            <input type="password" class="form-control" name="newPassword" autocomplete="new-password" required>
                            <div class="form-text">英字と数字を含む8〜64文字</div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">新しいパスワード（確認用）</label>
                            <input type="password" class="form-control" name="confirmPassword" autocomplete="new-password" required>
                        </div>

                        <div class="d-grid gap-2">
                            <button class="btn btn-primary" type="submit">変更する</button>
                            <a class="btn btn-outline-secondary" href="<%= request.getContextPath() %>/">トップへ戻る</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
