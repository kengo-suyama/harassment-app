<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.harassment.model.Consultation" %>
<%
  Consultation c = (Consultation) request.getAttribute("consultation");
%>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>全権管理者 - 相談詳細</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<nav class="navbar navbar-dark bg-dark mb-4">
  <div class="container-fluid">
    <a class="navbar-brand" href="<%= request.getContextPath() %>/master/consult/list">全権管理者</a>
    <a class="btn btn-outline-light btn-sm" href="<%= request.getContextPath() %>/master/logout">ログアウト</a>
  </div>
</nav>

<div class="container">
  <% if (c == null) { %>
    <div class="alert alert-danger">相談データが見つかりませんでした。</div>
  <% } else { %>

  <div class="d-flex justify-content-between align-items-center mb-3">
    <h1 class="h6 mb-0">相談詳細（ID: <%= c.getId() %>）</h1>
    <a class="btn btn-outline-primary btn-sm" href="<%= request.getContextPath() %>/master/consult/print?id=<%= c.getId() %>">印刷用</a>
  </div>

  <div class="card shadow-sm">
    <div class="card-body">
      <div class="mb-2"><strong>状況：</strong> <%= c.getStatusLabel() %></div>
      <hr>
      <div><strong>相談日：</strong> <%= c.getSheetDate() != null ? c.getSheetDate() : "" %></div>
      <div><strong>氏名：</strong> <%= c.getConsultantName() != null ? c.getConsultantName() : "" %></div>
      <div class="mt-2"><strong>概要：</strong><pre class="mb-0"><%= c.getSummary() != null ? c.getSummary() : "" %></pre></div>

      <hr>
      <div><strong>相談の有無：</strong> <%= c.getReportedExistsLabel() %></div>
      <div><strong>相談相手：</strong> <%= c.getReportedPerson()!=null?c.getReportedPerson():"" %></div>
      <div><strong>相談日時：</strong> <%= c.getReportedAt()!=null?c.getReportedAt():"" %></div>
      <div class="mt-2"><strong>経過：</strong><pre class="mb-0"><%= c.getFollowUp()!=null?c.getFollowUp():"" %></pre></div>

      <hr>
      <div><strong>つらさ：</strong> <%= c.getMentalScaleLabel() %></div>
      <div class="mt-2"><strong>詳細：</strong><pre class="mb-0"><%= c.getMentalDetail()!=null?c.getMentalDetail():"" %></pre></div>

      <hr>
      <div><strong>今後の希望：</strong> <%= c.getFutureRequestLabelString() %></div>
      <div class="mt-2"><strong>その他：</strong><pre class="mb-0"><%= c.getFutureRequestOtherDetail()!=null?c.getFutureRequestOtherDetail():"" %></pre></div>

      <hr>
      <div><strong>共有許可：</strong> <%= c.getSharePermissionLabel() %></div>
      <div><strong>共有範囲：</strong> <%= c.getShareLimitedTargets()!=null?c.getShareLimitedTargets():"" %></div>

      <hr>
      <div><strong>管理者の確定内容：</strong></div>
      <pre class="mb-0"><%= c.getFollowUpAction()!=null?c.getFollowUpAction():"" %></pre>

      <hr>
      <div><strong>相談者アンケート：</strong></div>
      <% if (c.isRated()) { %>
        <div class="alert alert-success mt-2">★ <%= c.getReporterRating() %> / 5</div>
        <pre class="mb-0"><%= c.getReporterFeedback()!=null?c.getReporterFeedback():"" %></pre>
      <% } else { %>
        <div class="text-muted">まだアンケートは届いていません。</div>
      <% } %>

    </div>
  </div>
  <a href="<%= request.getContextPath() %>/master/consult/list"
    class="btn btn-outline-secondary">
   一覧へ戻る
 </a>
  <% } %>
</div>
</body>
</html>
