<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.harassment.model.Consultation" %>

<%
    String ctx = request.getContextPath();
    Consultation c = (Consultation) request.getAttribute("consultation");
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
            ご相談内容を受け付けました。担当者が内容を確認して対応します。
          </p>
        </div>
      </div>

      <% if (c != null) { %>
        <div class="card shadow-sm">
          <div class="card-header">入力内容（概要）</div>
          <div class="card-body">
            <div class="mb-2">
              <div class="text-muted small">相談日</div>
              <div><%= (c.getSheetDate() == null ? "" : c.getSheetDate()) %></div>
            </div>
            <div>
              <div class="text-muted small">相談概要</div>
              <div style="white-space: pre-wrap;"><%= (c.getSummary() == null ? "" : c.getSummary()) %></div>
            </div>
          </div>
        </div>

        <div class="card shadow-sm mt-3">
          <div class="card-header">照合キー</div>
          <div class="card-body">
            <p class="mb-2 text-danger"><strong>必ず控えておいてください。</strong></p>
            <div class="display-6 fw-bold mb-2"><%= c.getAccessKey() %></div>
            <p class="text-muted small mb-2">
              経過確認は「対応状況の確認」から照合キーを入力してください。
            </p>
            <p class="text-muted small mb-0">
              メール送信機能は未設定です。
            </p>
            <div class="mt-3">
              <a class="btn btn-outline-secondary btn-sm" href="<%= ctx %>/">トップへ戻る</a>
              <a class="btn btn-outline-primary btn-sm ms-2" href="<%= ctx %>/consult/status">対応状況の確認</a>
            </div>
          </div>
        </div>
      <% } %>

    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
