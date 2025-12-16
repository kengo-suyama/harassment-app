<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.harassment.model.Consultation" %>
<%@ page import="com.example.harassment.model.FollowUpRecord" %>
<%@ page import="com.example.harassment.model.ChatMessage" %>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>マスター - 対応結果閲覧</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
  <div class="container-fluid">
    <a class="navbar-brand" href="<%= request.getContextPath() %>/">ハラスメント相談システム</a>
    <span class="navbar-text text-white">マスター画面</span>
  </div>
</nav>

<%
  Consultation c = (Consultation) request.getAttribute("consultation");
  if (c == null) {
%>
<div class="container">
  <div class="alert alert-danger">相談情報が見つかりませんでした。</div>
  <a class="btn btn-outline-secondary" href="<%= request.getContextPath() %>/master/consult/list">一覧へ</a>
</div>
<%
    return;
  }
%>

<div class="container">

  <div class="d-flex justify-content-between align-items-center mb-3">
    <h1 class="h4 mb-0">対応結果（ID: <%= c.getId() %>）</h1>
    <a class="btn btn-outline-secondary" href="<%= request.getContextPath() %>/master/consult/list">一覧へ戻る</a>
  </div>

  <div class="card shadow-sm mb-4">
    <div class="card-body">
      <dl class="row mb-0">
        <dt class="col-sm-3">対応状況</dt>
        <dd class="col-sm-9"><strong><%= c.getStatusLabel() %></strong></dd>

        <dt class="col-sm-3">概要</dt>
        <dd class="col-sm-9"><pre class="mb-0"><%= c.getSummary() %></pre></dd>

        <dt class="col-sm-3 mt-3">今後の希望</dt>
        <dd class="col-sm-9 mt-3"><%= c.getFutureRequestLabelString() %></dd>
      </dl>
    </div>
  </div>

  <!-- 対応履歴 -->
  <div class="card shadow-sm mb-4">
    <div class="card-body">
      <h2 class="h6">対応履歴（時系列）</h2>

      <div class="list-group">
        <%
          if (c.getFollowUpHistory() == null || c.getFollowUpHistory().isEmpty()) {
        %>
          <div class="text-muted small">まだ履歴はありません。</div>
        <%
          } else {
            for (FollowUpRecord r : c.getFollowUpHistory()) {
        %>
          <div class="list-group-item">
            <div class="small text-muted"><%= r.getAt() %> / <%= r.getByRoleLabel() %> / <%= r.getCategoryLabel() %></div>
            <pre class="mb-0"><%= r.getText() %></pre>
          </div>
        <%
            }
          }
        %>
      </div>
    </div>
  </div>

  <!-- チャット -->
  <div class="card shadow-sm mb-4">
    <div class="card-body">
      <h2 class="h6">相談者との連絡（簡易チャット）</h2>

      <div class="border rounded p-2 mb-3 bg-white" style="max-height: 320px; overflow:auto;">
        <%
          if (c.getChatMessages() == null || c.getChatMessages().isEmpty()) {
        %>
          <div class="text-muted small">まだメッセージはありません。</div>
        <%
          } else {
            for (ChatMessage m : c.getChatMessages()) {
        %>
          <div class="mb-2">
            <div class="small text-muted"><%= m.getAt() %> / <%= m.getSenderRoleLabel() %></div>
            <div class="bg-light rounded p-2"><%= m.getText() %></div>
          </div>
        <%
            }
          }
        %>
      </div>

      <form method="post" action="<%= request.getContextPath() %>/master/chat/send">
        <input type="hidden" name="id" value="<%= c.getId() %>">
        <div class="mb-2">
          <textarea name="text" class="form-control" rows="3" placeholder="確認事項など"></textarea>
        </div>
        <button class="btn btn-primary" type="submit">送信</button>
      </form>
    </div>
  </div>

  <!-- 満足度 -->
  <div class="card shadow-sm mb-5">
    <div class="card-body">
      <h2 class="h6">満足度（管理者/マスター閲覧用）</h2>
      <%
        if (c.getSatisfactionScore() <= 0) {
      %>
        <div class="text-muted small">まだ満足度は入力されていません。</div>
      <%
        } else {
      %>
        <div class="alert alert-info mb-0">
          <div><strong>評価：</strong> <%= c.getSatisfactionScoreLabel() %></div>
          <div class="small text-muted">記入日時：<%= c.getSatisfactionAt() != null ? c.getSatisfactionAt() : "" %></div>
          <hr>
          <div><strong>コメント：</strong></div>
          <pre class="mb-0"><%= c.getSatisfactionComment() != null ? c.getSatisfactionComment() : "" %></pre>
        </div>
      <%
        }
      %>
    </div>
  </div>

</div>

</body>
</html>
