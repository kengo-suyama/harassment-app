<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.harassment.model.Consultation" %>
<%
  Consultation c = (Consultation) request.getAttribute("consultation");
%>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>印刷 - 相談シート</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    @media print {
      .no-print { display:none !important; }
      pre { white-space: pre-wrap; }
    }
  </style>
</head>
<body class="bg-white">
<div class="container my-3">
  <div class="no-print d-flex justify-content-between mb-3">
    <a class="btn btn-outline-secondary" href="<%= request.getContextPath() %>/master/consult/detail?id=<%= c!=null?c.getId():0 %>">戻る</a>
    <button class="btn btn-primary" onclick="window.print()">このページを印刷</button>
  </div>

  <% if (c == null) { %>
    <div class="alert alert-danger">相談が見つかりません。</div>
  <% } else { %>
    <h1 class="h5 mb-3">ハラスメント相談シート（印刷）</h1>
    <div class="mb-2"><strong>ID：</strong> <%= c.getId() %></div>
    <div class="mb-2"><strong>状況：</strong> <%= c.getStatusLabel() %></div>
    <hr>
    <div><strong>記入日：</strong> <%= c.getSheetDate() %></div>
    <div><strong>氏名：</strong> <%= (c.getConsultantName()==null||c.getConsultantName().isEmpty())?"（未記入）":c.getConsultantName() %></div>
    <div class="mt-2"><strong>概要：</strong><pre class="mb-0"><%= c.getSummary() %></pre></div>
    <hr>
    <div><strong>相談の有無：</strong> <%= c.getReportedExistsLabel() %></div>
    <div><strong>相談相手：</strong> <%= c.getReportedPerson()!=null?c.getReportedPerson():"" %></div>
    <div><strong>相談日時：</strong> <%= c.getReportedAt()!=null?c.getReportedAt():"" %></div>
    <div class="mt-2"><strong>その後の対応：</strong><pre class="mb-0"><%= c.getFollowUp()!=null?c.getFollowUp():"" %></pre></div>
    <hr>
    <div><strong>しんどさ：</strong> <%= c.getMentalScaleLabel() %></div>
    <div class="mt-2"><strong>詳細：</strong><pre class="mb-0"><%= c.getMentalDetail()!=null?c.getMentalDetail():"" %></pre></div>
    <hr>
    <div><strong>今後の希望：</strong> <%= c.getFutureRequestLabelString() %></div>
    <div class="mt-2"><strong>その他：</strong><pre class="mb-0"><%= c.getFutureRequestOtherDetail()!=null?c.getFutureRequestOtherDetail():"" %></pre></div>
    <hr>
    <div><strong>共有：</strong> <%= c.getSharePermissionLabel() %></div>
    <div><strong>限定相手：</strong> <%= c.getShareLimitedTargets()!=null?c.getShareLimitedTargets():"" %></div>
    <hr>
    <div><strong>管理者の確定対応：</strong></div>
    <pre class="mb-0"><%= c.getFollowUpAction()!=null?c.getFollowUpAction():"（未確定）" %></pre>
    <hr>
    <div><strong>相談者の評価：</strong></div>
    <% if (c.isRated()) { %>
      <div>★ <%= c.getReporterRating() %> / 5</div>
      <pre class="mb-0"><%= c.getReporterFeedback()!=null?c.getReporterFeedback():"" %></pre>
    <% } else { %>
      <div class="text-muted">未提出</div>
    <% } %>
  <% } %>
</div>
</body>
</html>
