<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.harassment.model.Consultation" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    Consultation c = (Consultation) request.getAttribute("consultation");

    HttpSession session = request.getSession(false);
    String role = null;
    if (session != null) {
        role = (String) session.getAttribute("loginRole");
    }
    boolean isMaster = "MASTER".equals(role);
%>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>その後の対応内容（マスター） - ハラスメント相談システム</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container-fluid">
        <span class="navbar-brand">マスター画面 - その後の対応</span>
        <% if (isMaster) { %>
            <span class="badge bg-warning text-dark">マスター</span>
        <% } else { %>
            <span class="badge bg-secondary">未ログイン</span>
        <% } %>
    </div>
</nav>

<div class="container mb-5">

    <% if (!isMaster) { %>

        <div class="alert alert-danger">
            この画面はマスターログインした方のみが閲覧できます。
        </div>
        <a href="<%= request.getContextPath() %>/" class="btn btn-outline-secondary">
            トップに戻る
        </a>

    <% } else if (c == null) { %>

        <div class="alert alert-danger">
            該当する相談データが見つかりませんでした。
        </div>
        <a href="<%= request.getContextPath() %>/master/consult/list"
           class="btn btn-outline-secondary">
            一覧に戻る
        </a>

    <% } else { %>

        <div class="card shadow-sm mb-3">
            <div class="card-body">
                <h1 class="h5 mb-3">相談情報</h1>
                <dl class="row mb-0">
                    <dt class="col-sm-3">相談ID</dt>
                    <dd class="col-sm-9"><%= c.getId() %></dd>

                    <dt class="col-sm-3">記入日</dt>
                    <dd class="col-sm-9"><%= c.getSheetDate() != null ? c.getSheetDate() : "" %></dd>

                    <dt class="col-sm-3">相談者</dt>
                    <dd class="col-sm-9">
                        <%= c.getConsultantName() != null ? c.getConsultantName() : "（未記入）" %>
                    </dd>
                </dl>
            </div>
        </div>

        <div class="card shadow-sm">
            <div class="card-body">
                <h2 class="h5 mb-3">管理者のその後の対応内容</h2>

                <% if (c.getFollowUpAction() != null && !c.getFollowUpAction().isEmpty()) { %>
                    <pre class="bg-light p-3 border rounded mb-0"><%= c.getFollowUpAction() %></pre>
                <% } else { %>
                    <p class="text-muted mb-0">
                        管理者による対応内容はまだ登録されていません。
                    </p>
                <% } %>
            </div>
        </div>

        <div class="mt-3 mb-5">
            <a href="<%= request.getContextPath() %>/master/consult/list"
               class="btn btn-outline-secondary">
                一覧に戻る
            </a>
        </div>

    <% } %>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
