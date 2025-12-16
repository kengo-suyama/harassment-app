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
  <title>管理者 - 相談詳細</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<nav class="navbar navbar-dark bg-dark mb-4">
  <div class="container-fluid">
    <a class="navbar-brand" href="<%= request.getContextPath() %>/admin/consult/list">管理者</a>
    <a class="btn btn-outline-light btn-sm" href="<%= request.getContextPath() %>/admin/logout">ログアウト</a>
  </div>
</nav>

<div class="container">
  <% if (c == null) { %>
    <div class="alert alert-danger">相談が見つかりません。</div>
  <% } else { %>

  <div class="row g-3">
    <div class="col-lg-6">

      <div class="card shadow-sm mb-3">
        <div class="card-body">
          <h1 class="h6">相談シート（ID: <%= c.getId() %>）</h1>
          <div class="mb-2"><strong>状況：</strong> <%= c.getStatusLabel() %></div>

          <form class="row g-2 mb-3" method="post" action="<%= request.getContextPath() %>/admin/consult/status">
            <input type="hidden" name="id" value="<%= c.getId() %>">
            <div class="col-8">
              <select class="form-select" name="status">
                <option value="NEW" <%= "NEW".equals(c.getStatus())?"selected":"" %>>未対応</option>
                <option value="CHECKING" <%= "CHECKING".equals(c.getStatus())?"selected":"" %>>確認中</option>
                <option value="IN_PROGRESS" <%= "IN_PROGRESS".equals(c.getStatus())?"selected":"" %>>対応中</option>
                <option value="DONE" <%= "DONE".equals(c.getStatus())?"selected":"" %>>対応完了</option>
              </select>
            </div>
            <div class="col-4">
              <button class="btn btn-primary w-100" type="submit">更新</button>
            </div>
          </form>

          <form method="post" action="<%= request.getContextPath() %>/admin/consult/check" class="mb-3">
            <input type="hidden" name="id" value="<%= c.getId() %>">
            <input type="hidden" name="checked" value="<%= c.isAdminChecked() ? "false":"true" %>">
            <button class="btn btn-outline-success" type="submit">
              <%= c.isAdminChecked() ? "確認済みを解除" : "確認済みにする" %>
            </button>
          </form>

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
          <div class="d-flex justify-content-between align-items-center">
            <div><strong>確定対応：</strong></div>
            <a class="btn btn-sm btn-outline-primary" href="<%= request.getContextPath() %>/admin/consult/followup/edit?id=<%= c.getId() %>">対応入力</a>
          </div>
          <pre class="mb-0 mt-2"><%= c.getFollowUpAction()!=null?c.getFollowUpAction():"（未確定）" %></pre>
        </div>
      </div>

      <div class="card shadow-sm">
        <div class="card-body">
          <h2 class="h6">相談者の最終評価</h2>
          <% if (c.isRated()) { %>
            <div class="alert alert-success">★ <%= c.getReporterRating() %> / 5</div>
            <pre class="mb-0"><%= c.getReporterFeedback()!=null?c.getReporterFeedback():"" %></pre>
          <% } else { %>
            <div class="text-muted">まだ評価は届いていません。</div>
          <% } %>
        </div>
      </div>

    </div>

    <div class="col-lg-6">
      <div class="card shadow-sm">
        <div class="card-body">
          <h2 class="h6 mb-3">チャット</h2>

          <%
            List<ChatMessage> msgs = c.getChatMessages();
            if (msgs == null || msgs.isEmpty()) {
          %>
            <div class="text-muted">まだメッセージはありません。</div>
          <%
            } else {
              for (ChatMessage m : msgs) {
          %>
            <div class="border rounded p-2 mb-2">
              <div class="small text-muted"><%= m.getSenderRoleLabel() %> <% if(m.getSentAt()!=null){ %> / <%= m.getSentAt().toString().replace('T',' ') %><% } %></div>
              <pre class="mb-0"><%= m.getMessage() %></pre>
            </div>
          <%
              }
            }
          %>

          <hr>
          <form method="post" action="<%= request.getContextPath() %>/admin/consult/chat/send">
            <input type="hidden" name="id" value="<%= c.getId() %>">
            <textarea class="form-control mb-2" name="message" rows="3" placeholder="相談者への確認、面談日時の提案など"></textarea>
            <button class="btn btn-primary" type="submit">送信</button>
          </form>
        </div>
      </div>
    </div>

  </div>

  <% } %>
</div>
</body>
</html>
