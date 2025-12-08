<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>パスワード変更</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>
<body class="bg-light">

<%
    String role = (String) request.getAttribute("role");
    String title = "ユーザー";
    if ("ADMIN".equals(role)) {
        title = "管理者";
    } else if ("MASTER".equals(role)) {
        title = "マスター";
    }
%>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-4">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h1 class="h5 mb-3"><%= title %> パスワード変更</h1>

                    <%
                        String error = (String) request.getAttribute("error");
                        String message = (String) request.getAttribute("message");
                        if (error != null) {
                    %>
                        <div class="alert alert-danger"><%= error %></div>
                    <% } else if (message != null) { %>
                        <div class="alert alert-success"><%= message %></div>
                    <% } %>

                    <form action="<%= request.getContextPath() %>/password/change" method="post">
                        <div class="mb-3">
                            <label class="form-label">現在のパスワード</label>
                            <input type="password" class="form-control" name="currentPassword" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label
