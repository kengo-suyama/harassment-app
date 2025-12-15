<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.harassment.model.Consultation" %>

<%
    Consultation c = (Consultation) request.getAttribute("consultation");
%>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>相談内容詳細（管理者）</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container-fluid">
        <span class="navbar-brand">相談内容詳細（管理者）</span>
    </div>
</nav>

<div class="container">
    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <h1 class="h5 mb-3">相談内容詳細</h1>

            <dl class="row">

                <dt class="col-sm-3">シート記入日</dt>
                <dd class="col-sm-9"><%= c.getSheetDate() %></dd>

                <dt class="col-sm-3">相談者氏名</dt>
                <dd class="col-sm-9">
                    <%= (c.getConsultantName() != null && !c.getConsultantName().isEmpty())
                            ? c.getConsultantName()
                            : "（未記入）" %>
                </dd>

                <dt class="col-sm-3">相談の概要</dt>
                <dd class="col-sm-9"><pre class="mb-0"><%= c.getSummary() %></pre></dd>

                <dt class="col-sm-3 mt-3">相談済みか</dt>
                <dd class="col-sm-9 mt-3"><%= c.getReportedExistsLabel() %></dd>

                <dt class="col-sm-3">相談相手</dt>
                <dd class="col-sm-9"><%= c.getReportedPerson() %></dd>

                <dt class="col-sm-3">相談日時</dt>
                <dd class="col-sm-9"><%= c.getReportedAt() %></dd>

                <dt class="col-sm-3">その後の経過</dt>
                <dd class="col-sm-9"><pre class="mb-0"><%= c.getFollowUp() %></pre></dd>

                <dt class="col-sm-3 mt-3">心身の状態</dt>
                <dd class="col-sm-9 mt-3">
                    <%= c.getMentalScaleLabel() %>
                </dd>

                <dt class="col-sm-3">心身の詳細</dt>
                <dd class="col-sm-9"><pre class="mb-0"><%= c.getMentalDetail() %></pre></dd>

                <dt class="col-sm-3 mt-3">今後の希望</dt>
                <dd class="col-sm-9 mt-3">
                    <%= c.getFutureRequestLabelString() %>
                </dd>

                <dt class="col-sm-3">希望の補足</dt>
                <dd class="col-sm-9"><pre class="mb-0"><%= c.getFutureRequestOtherDetail() %></pre></dd>

                <dt class="col-sm-3 mt-3">情報共有の範囲</dt>
                <dd class="col-sm-9 mt-3">
                    <%= c.getSharePermissionLabel() %>
                </dd>

                <dt class="col-sm-3">共有先（限定）</dt>
                <dd class="col-sm-9"><%= c.getShareLimitedTargets() %></dd>

                <dt class="col-sm-3 mt-3">対応ステータス</dt>
                <dd class="col-sm-9 mt-3">
                    <%= c.getStatusLabel() %>
                </dd>

            </dl>
        </div>
    </div>

    <a href="<%= request.getContextPath() %>/admin/consult_list"
       class="btn btn-secondary mb-4">
        一覧へ戻る
    </a>
</div>

</body>
</html>
