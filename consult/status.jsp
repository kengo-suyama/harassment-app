<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>相談状況の確認</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
  <div class="container-fluid">
    <a class="navbar-brand" href="<%= request.getContextPath() %>/">ハラスメント相談システム</a>
    <span class="navbar-text text-white">相談状況の確認</span>
  </div>
</nav>

<div class="container">
  <div class="row justify-content-center">
    <div class="col-lg-7">

      <%
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (errorMessage != null && !errorMessage.isEmpty()) {
      %>
      <div class="alert alert-danger"><%= errorMessage %></div>
      <% } %>

      <div class="card shadow-sm">
        <div class="card-body">
          <h1 class="h5">照合キーを入力</h1>

          <form method="post" action="<%= request.getContextPath() %>/consult/status">
            <div class="mb-3">
              <label class="form-label">照合キー</label>
              <input type="text" name="token" class="form-control" required placeholder="例：A1B2C3D4EF5G6H7I">
            </div>

            <button class="btn btn-primary" type="submit">確認する</button>
            <a class="btn btn-outline-secondary ms-2" href="<%= request.getContextPath() %>/">戻る</a>
          </form>
        </div>
      </div>

    </div>
  </div>
</div>

</body>
</html>
