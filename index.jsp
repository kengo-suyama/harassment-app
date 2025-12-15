<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>ハラスメント相談システム</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
  <div class="container-fluid">
    <span class="navbar-brand">ハラスメント相談システム</span>
  </div>
</nav>

<div class="container">
  <div class="row justify-content-center">
    <div class="col-lg-8">
      <div class="card shadow-sm">
        <div class="card-body">
          <h1 class="h4 mb-3">トップ</h1>
          <p class="text-muted">相談シートを入力して送信できます。</p>

          <a href="<%= request.getContextPath() %>/consult/form" class="btn btn-primary">
            相談シートを入力する
          </a>

          <hr>

          <a href="<%= request.getContextPath() %>/admin/login" class="btn btn-outline-dark me-2">
            管理者ログイン
          </a>
          <a href="<%= request.getContextPath() %>/master/login" class="btn btn-outline-dark">
            マスターログイン
          </a>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
