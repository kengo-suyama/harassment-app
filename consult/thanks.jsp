<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.harassment.model.Consultation" %>

<%
    String ctx = request.getContextPath();
    Consultation c = (Consultation) request.getAttribute("consultation");
    String statusUrl = (String) request.getAttribute("statusUrl");
    String mailtoUrl = (String) request.getAttribute("mailtoUrl");
    String mailNotice = (String) request.getAttribute("mailNotice");
%>

<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>送信完了 - ハラスメント相談システム</title>
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

      <div class="card shadow-sm mb-4">
        <div class="card-body">
          <h1 class="h4 mb-3">送信が完了しました</h1>
          <p class="mb-0">
            ご相談内容を受け付けました。ありがとうございました。
          </p>
        </div>
      </div>

      <% if (c != null) { %>
        <div class="card shadow-sm">
          <div class="card-header">受付内容（概要）</div>
          <div class="card-body">
            <div class="mb-2">
              <div class="text-muted small">記入日</div>
              <div><%= (c.getSheetDate() == null ? "" : c.getSheetDate()) %></div>
            </div>
            <div>
              <div class="text-muted small">相談内容の概要</div>
              <div style="white-space: pre-wrap;"><%= (c.getSummary() == null ? "" : c.getSummary()) %></div>
            </div>
          </div>
        </div>

        <div class="card shadow-sm mt-3">
          <div class="card-header">相談者専用ページ</div>
          <div class="card-body">
            <p class="mb-2">以下のURLから相談状況を確認できます。メール等で保存してください。</p>
            <div class="mb-2">
              <div class="text-muted small">照合キー</div>
              <div><strong><%= c.getAccessKey() %></strong></div>
            </div>
            <div class="mb-2">
              <div class="text-muted small">専用URL</div>
              <div>
                <a href="<%= ctx %>/consult/status/<%= c.getAccessKey() %>">
                  <%= ctx %>/consult/status/<%= c.getAccessKey() %>
                </a>
              </div>
            </div>
            <a class="btn btn-outline-secondary btn-sm" href="<%= ctx %>/">トップへ戻る</a>
          </div>
        </div>
      <% } %>

      <% if (statusUrl != null && !statusUrl.isEmpty()) { %>
        <div class="card shadow-sm mt-4">
          <div class="card-header">Status URL</div>
          <div class="card-body">
            <% if (mailNotice != null && !mailNotice.isEmpty()) { %>
              <div class="alert alert-warning small mb-2"><%= mailNotice %></div>
            <% } %>
            <div class="mb-2">
              <a href="<%= statusUrl %>"><%= statusUrl %></a>
            </div>
            <input class="form-control" value="<%= statusUrl %>" readonly>
            <% if (mailtoUrl != null && !mailtoUrl.isEmpty()) { %>
              <a class="btn btn-outline-primary btn-sm mt-2" href="<%= mailtoUrl %>">Open mail app</a>
            <% } %>
          </div>
        </div>
      <% } %>

    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
