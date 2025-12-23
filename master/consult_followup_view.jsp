<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.harassment.model.Consultation" %>
<%@ page import="com.example.harassment.model.FollowUpRecord" %>
<%@ page import="com.example.harassment.model.ChatMessage" %>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>全権管理者 - 対応結果閲覧</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
  <div class="container-fluid">
    <a class="navbar-brand" href="<%= request.getContextPath() %>/master/consult/list">全権管理者</a>
    <span class="navbar-text text-white">全権管理者画面</span>
  </div>
</nav>

<%
  Consultation c = (Consultation) request.getAttribute("consultation");
  if (c == null) {
%>
<div class="container">
  <div class="alert alert-danger">逶ｸ隲・ュ蝣ｱ縺瑚ｦ九▽縺九ｊ縺ｾ縺帙ｓ縺ｧ縺励◆縲・/div>
  <a class="btn btn-outline-secondary" href="<%= request.getContextPath() %>/master/consult/list">荳隕ｧ縺ｸ</a>
</div>
<%
    return;
  }
%>

<div class="container">

  <div class="d-flex justify-content-between align-items-center mb-3">
    <h1 class="h4 mb-0">蟇ｾ蠢懃ｵ先棡・・D: <%= c.getId() %>・・/h1>
    <a class="btn btn-outline-secondary" href="<%= request.getContextPath() %>/master/consult/list">荳隕ｧ縺ｸ謌ｻ繧・/a>
  </div>

  <div class="card shadow-sm mb-4">
    <div class="card-body">
      <dl class="row mb-0">
        <dt class="col-sm-3">蟇ｾ蠢懃憾豕・/dt>
        <dd class="col-sm-9"><strong><%= c.getStatusLabel() %></strong></dd>

        <dt class="col-sm-3">讎りｦ・/dt>
        <dd class="col-sm-9"><pre class="mb-0"><%= c.getSummary() %></pre></dd>

        <dt class="col-sm-3 mt-3">莉雁ｾ後・蟶梧悍</dt>
        <dd class="col-sm-9 mt-3"><%= c.getFutureRequestLabelString() %></dd>
      </dl>
    </div>
  </div>

  <!-- 蟇ｾ蠢懷ｱ･豁ｴ -->
  <div class="card shadow-sm mb-4">
    <div class="card-body">
      <h2 class="h6">蟇ｾ蠢懷ｱ･豁ｴ・域凾邉ｻ蛻暦ｼ・/h2>

      <div class="list-group">
        <%
          if (c.getFollowUpHistory() == null || c.getFollowUpHistory().isEmpty()) {
        %>
          <div class="text-muted small">縺ｾ縺螻･豁ｴ縺ｯ縺ゅｊ縺ｾ縺帙ｓ縲・/div>
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

  <!-- 繝√Ε繝・ヨ -->
  <div class="card shadow-sm mb-4">
    <div class="card-body">
      <h2 class="h6">逶ｸ隲・・→縺ｮ騾｣邨｡・育ｰ｡譏薙メ繝｣繝・ヨ・・/h2>

      <div class="border rounded p-2 mb-3 bg-white" style="max-height: 320px; overflow:auto;">
        <%
          if (c.getChatMessages() == null || c.getChatMessages().isEmpty()) {
        %>
          <div class="text-muted small">縺ｾ縺繝｡繝・そ繝ｼ繧ｸ縺ｯ縺ゅｊ縺ｾ縺帙ｓ縲・/div>
        <%
          } else {
            for (ChatMessage m : c.getChatMessages()) {
        %>
          <div class="mb-2">
            <div class="small text-muted"><%= m.getSenderRoleLabel() %><% if (m.getSentAt() != null) { %> / <%= m.getSentAt().toString().replace(''T'','' '') %><% } %></div>
            <div class="bg-light rounded p-2"><%= m.getMessage() %></div>
          </div>
        <%
            }
          }
        %>
      </div>

      <form method="post" action="<%= request.getContextPath() %>/master/chat/send">
        <input type="hidden" name="id" value="<%= c.getId() %>">
        <div class="mb-2">
          <textarea name="text" class="form-control" rows="3" placeholder="遒ｺ隱堺ｺ矩・↑縺ｩ"></textarea>
        </div>
        <button class="btn btn-primary" type="submit">騾∽ｿ｡</button>
      </form>
    </div>
  </div>

  <!-- 貅雜ｳ蠎ｦ -->
  <div class="card shadow-sm mb-5">
    <div class="card-body">
      <h2 class="h6">貅雜ｳ蠎ｦ・育ｮ｡逅・・繝槭せ繧ｿ繝ｼ髢ｲ隕ｧ逕ｨ・・/h2>
      <%
        if (c.getSatisfactionScore() <= 0) {
      %>
        <div class="text-muted small">縺ｾ縺貅雜ｳ蠎ｦ縺ｯ蜈･蜉帙＆繧後※縺・∪縺帙ｓ縲・/div>
      <%
        } else {
      %>
        <div class="alert alert-info mb-0">
          <div><strong>隧穂ｾ｡・・/strong> <%= c.getSatisfactionScoreLabel() %></div>
          <div class="small text-muted">險伜・譌･譎ゑｼ・%= c.getSatisfactionAt() != null ? c.getSatisfactionAt() : "" %></div>
          <hr>
          <div><strong>繧ｳ繝｡繝ｳ繝茨ｼ・/strong></div>
          <pre class="mb-0"><%= c.getSatisfactionComment() != null ? c.getSatisfactionComment() : "" %></pre>
        </div>
      <%
        }
      %>
    </div>
  </div>
  <a href="<%= request.getContextPath() %>/master/consult/list"
    class="btn btn-outline-secondary">
   荳隕ｧ縺ｸ謌ｻ繧・
 </a>
 
</div>

</body>
</html>

