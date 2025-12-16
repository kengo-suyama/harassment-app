<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.harassment.model.Consultation" %>
<%
  Consultation c = (Consultation) request.getAttribute("consultation");
%>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>送信完了</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<nav class="navbar navbar-dark bg-dark mb-4">
  <div class="container-fluid">
    <a class="navbar-brand" href="<%= request.getContextPath() %>/">ハラスメント相談システム</a>
  </div>
</nav>

<div class="container">
  <div class="card shadow-sm">
    <div class="card-body">
      <h1 class="h5">送信が完了しました</h1>
      <p class="text-muted small">受付番号を控えてください。</p>

      <% if (c != null) { %>
        <div class="alert alert-success">
          受付番号（ID）：<strong><%= c.getId() %></strong><br>
          現在の状況：<strong><%= c.getStatusLabel() %></strong>
        </div>
        <a class="btn btn-primary" href="<%= request.getContextPath() %>/consult/my?id=<%= c.getId() %>">
          状況確認・チャット・評価へ
        </a>
      <% } %>

      <a class="btn btn-outline-secondary" href="<%= request.getContextPath() %>/consult/form">新しい相談</a>
      <a class="btn btn-outline-secondary" href="<%= request.getContextPath() %>/">トップへ</a>
    </div>
  </div>
</div>
</body>
</html>
