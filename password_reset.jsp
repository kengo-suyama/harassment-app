<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String roleLabel = (String) request.getAttribute("roleLabel");
    if (roleLabel == null) roleLabel = "管理者";
%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title><%= roleLabel %> - パスワード変更</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-5">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h1 class="h5 mb-3"><%= roleLabel %> - パスワード変更</h1>
                    <p class="text-muted small mb-3">
                        現在のパスワードを確認した上で、新しいパスワードを設定します。
                    </p>

                    <%
                        String error = (String) request.getAttribute("error");
                        String message = (String) request.getAttribute("message");
                        if (error != null) {
                    %>
                        <div class="alert alert-danger"><%= error %></div>
                    <% } else if (message != null) { %>
                        <div class="alert alert-success"><%= message %></div>
                    <% } %>

                    <form method="post">
                        <div class="mb-3">
                            <label class="form-label">現在のパスワード</label>
                            <input type="password" name="currentPassword" class="form-control" autocomplete="current-password" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">新しいパスワード</label>
                            <input type="password" name="newPassword" class="form-control" autocomplete="new-password" required>
                            <div class="form-text">英字と数字を含む8〜64文字</div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">新しいパスワード（確認用）</label>
                            <input type="password" name="confirmPassword" class="form-control" autocomplete="new-password" required>
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
