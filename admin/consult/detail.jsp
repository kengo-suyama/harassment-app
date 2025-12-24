<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.harassment.model.Consultation" %>
<%@ page import="com.example.harassment.model.ChatMessage" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>相談詳細 - 管理者</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
  <div class="container-fluid">
    <a href="<%= request.getContextPath() %>/admin/consult/list" class="navbar-brand">管理者</a>
    <span class="navbar-text text-white">相談詳細</span>
  </div>
</nav>

<div class="container">
  <%
    Consultation c = (Consultation) request.getAttribute("consultation");
    if (c == null) {
  %>
    <div class="alert alert-danger">相談データが見つかりませんでした。</div>
    <a class="btn btn-outline-secondary" href="<%= request.getContextPath() %>/admin/consult/list">一覧へ戻る</a>
  <%
    } else {
      List<ChatMessage> msgs = c.getChatMessages();
  %>
    <div class="card shadow-sm mb-3">
      <div class="card-body">
        <h1 class="h5 mb-3">相談詳細（ID: <%= c.getId() %>）</h1>
        <div class="mb-3">
          <div class="small text-muted">現在の進捗</div>
          <form class="row g-2" method="post" action="<%= request.getContextPath() %>/admin/consult/status">
            <input type="hidden" name="id" value="<%= c.getId() %>">
            <div class="col-8">
              <select class="form-select" name="status">
                <option value="UNCONFIRMED" <%= ("UNCONFIRMED".equals(c.getStatus()) || "NEW".equals(c.getStatus()))?"selected":"" %>>未確認</option>
                <option value="CONFIRMED" <%= ("CONFIRMED".equals(c.getStatus()) || "CHECKING".equals(c.getStatus()))?"selected":"" %>>確認</option>
                <option value="REVIEWING" <%= "REVIEWING".equals(c.getStatus())?"selected":"" %>>対応検討中</option>
                <option value="IN_PROGRESS" <%= "IN_PROGRESS".equals(c.getStatus())?"selected":"" %>>対応中</option>
                <option value="DONE" <%= "DONE".equals(c.getStatus())?"selected":"" %>>対応済</option>
              </select>
            </div>
            <div class="col-4">
              <button class="btn btn-outline-primary w-100" type="submit">更新</button>
            </div>
          </form>
        </div>

        <dl class="row mb-0">
          <dt class="col-sm-3">相談日</dt><dd class="col-sm-9"><%= c.getSheetDate() != null ? c.getSheetDate() : "" %></dd>
          <dt class="col-sm-3">氏名</dt><dd class="col-sm-9"><%= c.getConsultantName() != null ? c.getConsultantName() : "" %></dd>
          <dt class="col-sm-3">概要</dt>
          <dd class="col-sm-9">
            <div class="mb-1"><%= c.getSummaryCategoryLabel() != null ? c.getSummaryCategoryLabel() : "" %></div>
            <pre class="mb-0"><%= c.getSummaryDetail() != null ? c.getSummaryDetail() : "" %></pre>
          </dd>

          <dt class="col-sm-3 mt-3">相談の有無</dt><dd class="col-sm-9 mt-3"><%= c.getReportedExistsLabel() %></dd>
          <dt class="col-sm-3">相談相手</dt><dd class="col-sm-9"><%= c.getReportedPerson() != null ? c.getReportedPerson() : "" %></dd>
          <dt class="col-sm-3">相談日時</dt><dd class="col-sm-9"><%= c.getReportedAt() != null ? c.getReportedAt() : "" %></dd>
          <dt class="col-sm-3">経過</dt><dd class="col-sm-9"><pre class="mb-0"><%= c.getFollowUp() != null ? c.getFollowUp() : "" %></pre></dd>

          <dt class="col-sm-3 mt-3">つらさ</dt><dd class="col-sm-9 mt-3"><%= c.getMentalScaleLabel() %></dd>
          <dt class="col-sm-3">詳細</dt><dd class="col-sm-9"><pre class="mb-0"><%= c.getMentalDetail() != null ? c.getMentalDetail() : "" %></pre></dd>

          <dt class="col-sm-3 mt-3">今後の希望</dt><dd class="col-sm-9 mt-3"><%= c.getFutureRequestLabelString() %></dd>
          <dt class="col-sm-3">その他</dt><dd class="col-sm-9"><pre class="mb-0"><%= c.getFutureRequestOtherDetail() != null ? c.getFutureRequestOtherDetail() : "" %></pre></dd>

          <dt class="col-sm-3 mt-3">共有許可</dt><dd class="col-sm-9 mt-3"><%= c.getSharePermissionLabel() %></dd>
          <dt class="col-sm-3">共有範囲</dt><dd class="col-sm-9"><%= c.getShareLimitedTargets() != null ? c.getShareLimitedTargets() : "" %></dd>
        </dl>
      </div>
    </div>

    <div class="row g-3 mb-3">
      <div class="col-lg-6">
        <div class="card shadow-sm h-100">
          <div class="card-body">
            <h2 class="h6 mb-3">
              相談者との連絡（チャット）
              <% if (c.getUnreadForAdmin() > 0) { %>
                <span class="badge bg-warning text-dark ms-2">未読 <%= c.getUnreadForAdmin() %></span>
              <% } %>
            </h2>
            <div class="border rounded p-2 mb-3 bg-white" style="max-height: 320px; overflow:auto;">
              <%
                if (msgs == null || msgs.isEmpty()) {
              %>
                <div class="p-3 text-center bg-light border rounded text-muted small">
                  まだメッセージはありません
                </div>
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
            <form method="post" action="<%= request.getContextPath() %>/admin/consult/chat/send">
              <input type="hidden" name="id" value="<%= c.getId() %>">
              <textarea class="form-control mb-2" name="message" rows="3" placeholder="相談者への確認事項、面談希望日時の提案など"></textarea>
              <button class="btn btn-primary" type="submit">送信</button>
            </form>
          </div>
        </div>
      </div>

      <div class="col-lg-6">
        <div class="card shadow-sm h-100">
          <div class="card-body">
            <h2 class="h6 mb-3">対応内容（管理者メモ）</h2>
            <div class="text-muted small mb-2">この画面で対応内容を入力します。</div>
            <form method="post" action="<%= request.getContextPath() %>/admin/consult/followup/save">
              <input type="hidden" name="id" value="<%= c.getId() %>">
              <textarea class="form-control mb-2" name="followUpText" rows="8"><%= c.getFollowUpDraft()!=null?c.getFollowUpDraft():(c.getFollowUpAction()!=null?c.getFollowUpAction():"") %></textarea>
              <div class="d-flex gap-2">
                <button class="btn btn-outline-secondary" type="submit" name="mode" value="draft">下書き保存</button>
                <button class="btn btn-success" type="submit" name="mode" value="final">確定保存</button>
              </div>
            </form>
            <hr>
            <div class="small text-muted">確定内容（全権管理者画面に反映）</div>
            <pre class="mb-0"><%= c.getFollowUpAction()!=null?c.getFollowUpAction():"" %></pre>
          </div>
        </div>
      </div>
    </div>

    <div class="d-flex justify-content-between">
      <a class="btn btn-outline-secondary" href="<%= request.getContextPath() %>/admin/consult/list">一覧へ戻る</a>
    </div>
  <%
    }
  %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
