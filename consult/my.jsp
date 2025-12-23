<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.harassment.model.Consultation" %>
<%@ page import="com.example.harassment.model.ChatMessage" %>
<%@ page import="java.util.List" %>
<%
  Consultation c = (Consultation) request.getAttribute("consultation");
%>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>状況確認</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    .bubble { border-radius: 12px; padding: 10px 12px; max-width: 85%; white-space: pre-wrap; }
    .bubble.reporter { background:#f1f3f5; }
    .bubble.admin { background:#d1e7ff; }
    .msgrow { display:flex; margin-bottom:10px; }
    .msgrow.left { justify-content:flex-start; }
    .msgrow.right { justify-content:flex-end; }
    .meta { font-size: 12px; color:#6c757d; }
  </style>
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
  <div class="container-fluid">
    <a class="navbar-brand" href="<%= request.getContextPath() %>/">ハラスメント相談システム</a>
    <span class="navbar-text text-white">状況確認</span>
  </div>
</nav>

<div class="container">
  <% if (c == null) { %>
    <div class="alert alert-danger">相談が見つかりません。id を確認してください。</div>
    <a class="btn btn-outline-secondary" href="<%= request.getContextPath() %>/consult/form">フォームへ</a>
  <% } else { %>

  <div class="row g-3">
    <div class="col-lg-5">
      <div class="card shadow-sm">
        <div class="card-body">
          <h1 class="h6">相談情報（ID: <%= c.getId() %>）</h1>
          <div class="mb-2"><strong>状況：</strong> <%= c.getStatusLabel() %></div>
          <hr>
          <div class="mb-2"><strong>記入日：</strong> <%= c.getSheetDate() %></div>
          <div class="mb-2"><strong>氏名：</strong> <%= (c.getConsultantName()==null||c.getConsultantName().isEmpty())?"（未記入）":c.getConsultantName() %></div>
          <div class="mb-2"><strong>概要：</strong><pre class="mb-0"><%= c.getSummary() %></pre></div>
          <hr>
          <div class="mb-2"><strong>相談の有無：</strong> <%= c.getReportedExistsLabel() %></div>
          <div class="mb-2"><strong>今後の希望：</strong> <%= c.getFutureRequestLabelString() %></div>
          <hr>
          <div class="mb-2"><strong>管理者の確定対応：</strong></div>
          <pre class="mb-0"><%= c.getFollowUpAction()!=null?c.getFollowUpAction():"（まだ確定対応はありません）" %></pre>
        </div>
      </div>
    </div>

    <div class="col-lg-7">
      <%
        List<ChatMessage> msgs = c.getChatMessages();
        boolean hasNew = false;
        if (msgs != null && !msgs.isEmpty()) {
          ChatMessage last = msgs.get(msgs.size() - 1);
          hasNew = !"REPORTER".equals(last.getSenderRole());
        }
      %>
      <div class="card shadow-sm mb-3">
        <div class="card-body">
          <h2 class="h6 mb-3">
            チャット
            <% if (hasNew) { %><span class="badge bg-warning text-dark ms-2">新着</span><% } %>
          </h2>

          <%
            if (msgs == null || msgs.isEmpty()) {
          %>
            <div class="text-muted">まだメッセージはありません。</div>
          <%
            } else {
              for (ChatMessage m : msgs) {
                boolean isAdmin = "ADMIN".equals(m.getSenderRole());
          %>
            <div class="msgrow <%= isAdmin ? "left":"right" %>">
              <div>
                <div class="bubble <%= isAdmin ? "admin":"reporter" %>"><%= m.getMessage() %></div>
                <div class="meta"><%= m.getSenderRoleLabel() %> <% if(m.getSentAt()!=null){ %> / <%= m.getSentAt().toString().replace('T',' ') %><% } %></div>
              </div>
            </div>
          <%
              }
            }
          %>

          <hr>
          <form method="post" action="<%= request.getContextPath() %>/consult/chat/send">
            <input type="hidden" name="id" value="<%= c.getId() %>">
            <input type="hidden" name="token" value="<%= c.getLookupKey() %>">
            <textarea class="form-control mb-2" name="text" rows="3" placeholder="確認したいこと、面談希望日時など"></textarea>
            <button class="btn btn-primary" type="submit">送信</button>
          </form>
        </div>
      </div>

      <div class="card shadow-sm">
        <div class="card-body">
          <h2 class="h6 mb-3">最終評価</h2>

          <% if (!"DONE".equals(c.getStatus())) { %>
            <div class="text-muted">対応が「対応完了」になった後に評価できます（現在：<%= c.getStatusLabel() %>）。</div>
          <% } else if (c.isRated()) { %>
            <div class="alert alert-success">
              評価送信済みです。ありがとうございました。<br>
              ★ <%= c.getReporterRating() %> / 5
              <pre class="mb-0"><%= c.getReporterFeedback()!=null?c.getReporterFeedback():"" %></pre>
            </div>
          <% } else { %>
            <form method="post" action="<%= request.getContextPath() %>/consult/eval/submit">
              <input type="hidden" name="id" value="<%= c.getId() %>">
              <input type="hidden" name="token" value="<%= c.getLookupKey() %>">
              <div class="mb-2">
                <label class="form-label">満足度（1〜5）</label>
                <select class="form-select" name="rating">
                  <option value="5">5（とても満足）</option>
                  <option value="4">4（満足）</option>
                  <option value="3" selected>3（普通）</option>
                  <option value="2">2（不満）</option>
                  <option value="1">1（とても不満）</option>
                </select>
              </div>
              <div class="mb-2">
                <label class="form-label">コメント（任意）</label>
                <textarea class="form-control" name="feedback" rows="3" placeholder="改善点など"></textarea>
              </div>
              <button class="btn btn-success" type="submit">評価を送信</button>
            </form>
          <% } %>

        </div>
      </div>

    </div>
  </div>

  <% } %>
</div>
</body>
</html>
