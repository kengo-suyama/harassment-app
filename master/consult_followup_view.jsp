<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.harassment.model.Consultation" %>

<%
    Consultation c = (Consultation) request.getAttribute("consultation");
%>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>相談対応状況（マスター）</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container-fluid">
        <span class="navbar-brand">相談対応状況（マスター）</span>
    </div>
</nav>

<div class="container">
    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <h1 class="h5 mb-3">相談内容・対応状況</h1>

            <dl class="row">

                <dt class="col-sm-3">相談の概要</dt>
                <dd class="col-sm-9"><pre class="mb-0"><%= c.getSummary() %></pre></dd>

                <dt class="col-sm-3 mt-3">今後の希望</dt>
                <dd class="col-sm-9 mt-3">
                    <%= c.getFutureRequestLabelString() %>
                </dd>

                <dt class="col-sm-3">希望の補足</dt>
                <dd class="col-sm-9"><pre class="mb-0"><%= c.getFutureRequestOtherDetail() %></pre></dd>

                <dt class="col-sm-3 mt-3">管理者対応内容</dt>
                <dd class="col-sm-9 mt-3">
                    <pre class="mb-0">
<%= (c.getFollowUpAction() != null && !c.getFollowUpAction().isEmpty())
        ? c.getFollowUpAction()
        : "（対応内容はまだ登録されていません）" %>
                    </pre>
                </dd>

                <dt class="col-sm-3 mt-3">現在の対応状況</dt>
                <dd class="col-sm-9 mt-3">
                    <%= c.getStatusLabel() %>
                </dd>

            </dl>
        </div>
    </div>

    <a href="<%= request.getContextPath() %>/master/consult_list"
       class="btn btn-secondary mb-4">
        一覧へ戻る
    </a>
</div>

</body>
</html>
