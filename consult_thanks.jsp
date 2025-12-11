<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.harassment.model.Consultation" %>
<%
    Consultation c = (Consultation) request.getAttribute("consultation");
%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>ハラスメント相談 送信完了</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container-fluid">
        <a href="<%= request.getContextPath() %>/" class="navbar-brand text-decoration-none">
            ハラスメント相談フォーム
        </a>
    </div>
</nav>

<div class="container">
    <div class="row justify-content-center mb-4">
        <div class="col-lg-8">

            <div class="card shadow-sm">
                <div class="card-body">
                    <h1 class="h4 mb-3">ご相談を受け付けました</h1>

                    <p class="text-muted">
                        ご記入いただいた内容は、相談窓口の管理者・マスター権限者のみが確認します。<br>
                        必要に応じて、担当者から連絡させていただきます。
                    </p>

                    <hr>

                    <% if (c != null) { %>
                        <h2 class="h5 mb-3">送信内容（概要）</h2>
                        <dl class="row">
                            <dt class="col-sm-4">シート記入日</dt>
                            <dd class="col-sm-8"><%= c.getSheetDate() %></dd>

                            <dt class="col-sm-4">相談者氏名</dt>
                            <dd class="col-sm-8">
                                <%= (c.getConsultantName() == null || c.getConsultantName().isEmpty())
                                        ? "（未記入）" : c.getConsultantName() %>
                            </dd>

                            <dt class="col-sm-4">相談の概要</dt>
                            <dd class="col-sm-8">
                                <pre class="mb-0"><%= c.getSummary() %></pre>
                            </dd>
                        </dl>
                    <% } %>

                    <div class="mt-4 d-flex justify-content-between">
                        <a href="<%= request.getContextPath() %>/" class="btn btn-outline-secondary">
                            トップに戻る
                        </a>

                        <!-- 管理者ログインへのショートカット（必要なければ削除OK） -->
                        <div>
                            <a href="<%= request.getContextPath() %>/admin/login" class="btn btn-sm btn-secondary me-2">
                                管理者ログイン
                            </a>
                            <a href="<%= request.getContextPath() %>/master/login" class="btn btn-sm btn-secondary">
                                マスターログイン
                            </a>
                        </div>
                    </div>

                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
