<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.harassment.model.Consultation" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>管理者画面 - 対応内容入力</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container-fluid">
        <a href="<%= request.getContextPath() %>/" class="navbar-brand">
            ハラスメント相談システム
        </a>
        <span class="navbar-text text-white">管理者画面</span>
    </div>
</nav>

<%
    Consultation c = (Consultation) request.getAttribute("consultation");
    if (c == null) {
%>
<div class="container">
    <div class="alert alert-danger mt-3">
        相談情報が見つかりませんでした。
    </div>
</div>
<%
    } else {
%>

<div class="container">
    <h1 class="h4 mb-3">対応内容の入力 (ID: <%= c.getId() %>)</h1>

    <div class="mb-3">
        <p><strong>相談者：</strong> <%= c.getConsultantName() %></p>
        <p><strong>相談の概要：</strong><br>
            <pre class="mb-0"><%= c.getSummary() %></pre>
        </p>
    </div>

    <form method="post"
          action="<%= request.getContextPath() %>/admin/consult/followup/save">

        <input type="hidden" name="id" value="<%= c.getId() %>">

        <div class="mb-3">
            <label for="followUpText" class="form-label">対応内容（下書き／確定）</label>
            <textarea id="followUpText" name="followUpText" rows="8"
                      class="form-control"><%= c.getFollowUpDraft() != null ? c.getFollowUpDraft() :
                           (c.getFollowUpAction() != null ? c.getFollowUpAction() : "") %></textarea>
        </div>

        <div class="d-flex justify-content-between">
            <a href="<%= request.getContextPath() %>/admin/consult/detail?id=<%= c.getId() %>"
               class="btn btn-outline-secondary">
                戻る
            </a>

            <div>
                <button type="submit" name="mode" value="draft"
                        class="btn btn-outline-primary me-2">
                    一時保存
                </button>
                <button type="submit" name="mode" value="final"
                        class="btn btn-primary">
                    確定して登録
                </button>
            </div>
        </div>
    </form>
</div>

<%
    }
%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
