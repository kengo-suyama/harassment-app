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
  <div class="row g-3">
    <div class="col-lg-4">
      <div class="card shadow-sm">
        <div class="card-body">
          <h2 class="h5">相談者</h2>
          <p class="text-muted small">相談フォームから送信できます。</p>
          <a class="btn btn-primary" href="<%= request.getContextPath() %>/consult/form">相談フォームへ</a>
        </div>
      </div>
    </div>

    <div class="col-lg-4">
      <div class="card shadow-sm">
        <div class="card-body">
          <h2 class="h5">管理者</h2>
          <p class="text-muted small">相談の確認・対応・チャット。</p>
          <a class="btn btn-dark" href="<%= request.getContextPath() %>/admin/login">管理者ログイン</a>
        </div>
      </div>
    </div>

    <div class="col-lg-4">
      <div class="card shadow-sm">
        <div class="card-body">
          <h2 class="h5">マスター</h2>
          <p class="text-muted small">確定対応の閲覧・印刷。</p>
          <a class="btn btn-secondary" href="<%= request.getContextPath() %>/master/login">マスターログイン</a>
        </div>
      </div>
    </div>
  </div>
</div>
</body>
</html>
