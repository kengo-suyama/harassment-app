<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.harassment.model.Consultation" %>
<%
  Consultation c = (Consultation) request.getAttribute("consultation");
%>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>管理者 - 対応入力</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<nav class="navbar navbar-dark bg-dark mb-4">
  <div class="container-fluid">
    <a class="navbar-brand" href="<%= request.getContextPath() %>/admin/consult/list">管理者</a>
    <a class="btn btn-outline-light btn-sm" href="<%= request.getContextPath() %>/admin/logout">ログアウト</a>
  </div>
</nav>

<div class="container">
  <% if (c == null) { %>
    <div class="alert alert-danger">相談が見つかりません。</div>
  <% } else { %>

  <div class="card shadow-sm">
    <div class="card-body">
      <h1 class="h6">対応内容入力（ID: <%= c.getId() %>）</h1>
      <div class="text-muted small mb-3">下書き／確定を選択して保存できます。</div>

      <form method="post" action="<%= request.getContextPath() %>/admin/consult/followup/save">
        <input type="hidden" name="id" value="<%= c.getId() %>">
        <div class="mb-3">
          <textarea class="form-control" name="followUpText" rows="10"><%= c.getFollowUpDraft()!=null?c.getFollowUpDraft():(c.getFollowUpAction()!=null?c.getFollowUpAction():"") %></textarea>
        </div>

        <div class="d-flex justify-content-between">
          <a class="btn btn-outline-secondary" href="<%= request.getContextPath() %>/admin/consult/detail?id=<%= c.getId() %>">戻る</a>
          <div class="d-flex gap-2">
            <button class="btn btn-outline-primary" type="submit" name="mode" value="draft">一時保存</button>
            <button class="btn btn-primary" type="submit" name="mode" value="final">確定して登録</button>
          </div>
        </div>
      </form>
    </div>
  </div>

  <% } %>
</div>
</body>
</html>
