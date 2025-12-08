<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.harassment.model.Consultation" %>
<%
    Consultation c = (Consultation) request.getAttribute("consultation");
%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>相談受付完了</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-5">
    <div class="card shadow-sm">
        <div class="card-body">
            <h1 class="h4 mb-3">相談を受け付けました</h1>
            <p>ご相談ありがとうございます。担当者が内容を確認します。</p>

            <hr>

            <p class="mb-1"><strong>シート記入日：</strong><%= c.getSheetDate() %></p>
            <p class="mb-1"><strong>相談者氏名：</strong><%= c.getConsultantName() %></p>
            <p class="mb-1"><strong>相談概要：</strong><br><pre><%= c.getSummary() %></pre></p>

            <a href="<%= request.getContextPath() %>/" class="btn btn-primary mt-3">トップへ戻る</a>
        </div>
    </div>
</div>
</body>
</html>
