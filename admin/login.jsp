<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String ctx = request.getContextPath();
    String error = (String) request.getAttribute("errorMessage");
    String user = request.getParameter("email");
    if (user == null) user = request.getParameter("username");
    if (user == null) user = "";
%>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>管理者ログイン - ハラスメント相談システム</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
  <div class="container-fluid">
    <a class="navbar-brand" href="<%= ctx %>/">ハラスメント相談システム</a>
    <span class="navbar-text text-white">管理者ログイン</span>
  </div>
</nav>

<div class="container">
  <div class="row justify-content-center">
    <div class="col-md-6 col-lg-5">

      <% if (error != null && !error.trim().isEmpty()) { %>
        <div class="alert alert-danger"><%= error %></div>
      <% } %>

      <div class="card shadow-sm">
        <div class="card-body">
          <h1 class="h5 mb-3">管理者ログイン</h1>
          <p class="text-muted small mb-4">
            管理者用のログインページです。
          </p>

          <form method="post" action="<%= ctx %>/admin/login">
            <div class="mb-3">
              <label class="form-label">メールアドレス</label>
              <input type="text"
                     name="email"
                     class="form-control"
                     autocomplete="username"
                     value="<%= user %>"
                     required>
            </div>

            <div class="mb-3">
              <label class="form-label">パスワード</label>
              <input type="password"
                     name="password"
                     class="form-control"
                     autocomplete="current-password"
                     required>
            </div>

            <div class="d-grid gap-2">
              <button type="submit" class="btn btn-primary">ログイン</button>
              <a href="<%= ctx %>/admin/password/reset" class="btn btn-outline-secondary">パスワード変更はこちら</a>
              <a href="<%= ctx %>/" class="btn btn-outline-secondary">トップへ戻る</a>
            </div>
          </form>
        </div>
      </div>

      <div class="text-muted small mt-3">
        ・ログイン後に管理者画面へ移動します。
      </div>

    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
