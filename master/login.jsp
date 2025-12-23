<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>全権管理者ログイン</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5" style="max-width:520px;">
  <div class="card shadow-sm">
    <div class="card-body">
      <h1 class="h5 mb-3">全権管理者ログイン</h1>
      <p class="text-muted small mb-4">
        全権管理者用のログインです。相談一覧・詳細・評価の確認ができます。
      </p>

      <%
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (errorMessage != null && !errorMessage.isEmpty()) {
      %>
        <div class="alert alert-danger"><%= errorMessage %></div>
      <%
        }
      %>

      <form method="post" action="<%= request.getContextPath() %>/master/login">
        <label class="form-label">メールアドレス</label>
        <input class="form-control mb-3" type="email" name="email" placeholder="master@local.test" required>
        <label class="form-label">パスワード</label>
        <input class="form-control mb-3" type="password" name="password" required>
        <button class="btn btn-secondary w-100" type="submit">ログイン</button>
      </form>

      <a class="btn btn-outline-secondary w-100 mt-2" href="<%= request.getContextPath() %>/">トップへ</a>
    </div>
  </div>
</div>
</body>
</html>
