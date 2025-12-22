<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.harassment.model.Consultation" %>
<%@ page import="com.example.harassment.model.ChatMessage" %>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>相談状況 - 確認</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
  <div class="container-fluid">
    <a class="navbar-brand" href="<%= request.getContextPath() %>/">ハラスメント相談システム</a>
    <span class="navbar-text text-white">相談状況</span>
  </div>
</nav>

<%
  Consultation c = (Consultation) request.getAttribute("consultation");
  if (c == null) {
%>
<div class="container">
  <div class="alert alert-danger">相談情報が見つかりませんでした。</div>
  <a class="btn btn-outline-secondary" href="<%= request.getContextPath() %>/consult/status">戻る</a>
</div>
<%
    return;
  }
%>

<div class="container">
  <div class="card shadow-sm mb-4">
    <div class="card-body">
      <h1 class="h5 mb-3">現在の対応状況</h1>

      <dl class="row mb-0">
        <dt class="col-sm-4">受付番号</dt>
        <dd class="col-sm-8"><%= c.getId() %></dd>

        <dt class="col-sm-4">対応状況</dt>
        <dd class="col-sm-8"><strong><%= c.getStatusLabel() %></strong></dd>

        <dt class="col-sm-4">相談概要</dt>
        <dd class="col-sm-8"><pre class="mb-0"><%= c.getSummary() %></pre></dd>
      </dl>
    </div>
  </div>

  <!-- チャット -->
  <div class="card shadow-sm mb-4">
    <div class="card-body">
      <%
        java.util.List<ChatMessage> msgs = c.getChatMessages();
        boolean hasNew = false;
        if (msgs != null && !msgs.isEmpty()) {
          ChatMessage last = msgs.get(msgs.size() - 1);
          hasNew = !"REPORTER".equals(last.getSenderRole());
        }
      %>
      <h2 class="h6">
        連絡（簡易チャット）
        <% if (hasNew) { %><span class="badge bg-warning text-dark ms-2">新着</span><% } %>
      </h2>

      <div class="border rounded p-2 mb-3 bg-white" style="max-height: 320px; overflow:auto;">
        <%
          if (msgs == null || msgs.isEmpty()) {
        %>
          <div class="text-muted small">まだメッセージはありません。</div>
        <%
          } else {
            for (ChatMessage m : msgs) {
        %>
          <div class="mb-2">
            <div class="small text-muted"><%= m.getSenderRoleLabel() %><% if (m.getSentAt() != null) { %> / <%= m.getSentAt().toString().replace('T',' ') %><% } %></div>
            <div class="bg-light rounded p-2"><%= m.getMessage() %></div>
          </div>
        <%
            }
          }
        %>
      </div>

      <form method="post" action="<%= request.getContextPath() %>/consult/chat/send">
        <input type="hidden" name="id" value="<%= c.getId() %>">
        <input type="hidden" name="key" value="<%= c.getLookupKey() %>">

        <div class="mb-2">
          <textarea name="message" class="form-control" rows="3" placeholder="確認したいこと、面談希望日時など"></textarea>
        </div>
        <button class="btn btn-primary" type="submit">送信</button>
        <a class="btn btn-outline-secondary ms-2" href="<%= request.getContextPath() %>/consult/status">別の受付番号で確認</a>
      </form>
    </div>
  </div>

  <!-- 満足度（DONE のとき表示） -->
  <%
    boolean done = "DONE".equals(c.getStatus());
    boolean already = c.getSatisfactionScore() > 0;
    if (done) {
  %>
  <div class="card shadow-sm mb-5">
    <div class="card-body">
      <h2 class="h6">今回の対応の満足度（完了後）</h2>

      <%
        if (already) {
      %>
        <div class="alert alert-success mb-0">
          送信済みです：<strong><%= c.getSatisfactionScoreLabel() %></strong>
          <div class="small text-muted">記入日時：<%= c.getSatisfactionAt() != null ? c.getSatisfactionAt() : "" %></div>
        </div>
      <%
        } else {
      %>
      <form method="post" action="<%= request.getContextPath() %>/consult/satisfaction/submit">
        <input type="hidden" name="id" value="<%= c.getId() %>">
        <input type="hidden" name="key" value="<%= c.getLookupKey() %>">

        <div class="mb-2">
          <label class="form-label">満足度（1〜5）</label>
          <select name="score" class="form-select" required>
            <option value="">選択してください</option>
            <option value="1">1（不満）</option>
            <option value="2">2（やや不満）</option>
            <option value="3">3（普通）</option>
            <option value="4">4（満足）</option>
            <option value="5">5（とても満足）</option>
          </select>
        </div>

        <div class="mb-3">
          <label class="form-label">コメント（任意）</label>
          <textarea name="comment" class="form-control" rows="3"></textarea>
        </div>

        <button class="btn btn-success" type="submit">送信する</button>
      </form>
      <%
        }
      %>
    </div>
  </div>
  <%
    }
  %>

</div>

</body>
</html>
