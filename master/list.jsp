<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.harassment.model.Consultation" %>
<%
  List<Consultation> list = (List<Consultation>) request.getAttribute("list");
%>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>全権管理者 - 相談一覧</title>
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
  <%
    String sort = request.getParameter("sort");
    String sortLabel = "新しい順";
    if ("oldest".equals(sort)) {
      sortLabel = "古い順";
    } else if ("mental_desc".equals(sort)) {
      sortLabel = "しんどさ高い順";
    } else if ("unconfirmed".equals(sort)) {
      sortLabel = "未確認順";
    }
  %>

  <div class="card shadow-sm mb-3">
    <div class="card-body">
      <h1 class="h6">相談一覧（全権管理者）</h1>

      <form class="row g-2" method="get" action="<%= request.getContextPath() %>/master/consult/list">
        <div class="col-md-3">
          <input class="form-control" name="name" placeholder="相談者名（部分一致）" value="<%= request.getParameter("name")!=null?request.getParameter("name"):"" %>">
        </div>
        <div class="col-md-2">
          <input class="form-control" type="date" name="from" value="<%= request.getParameter("from")!=null?request.getParameter("from"):"" %>">
        </div>
        <div class="col-md-2">
          <input class="form-control" type="date" name="to" value="<%= request.getParameter("to")!=null?request.getParameter("to"):"" %>">
        </div>
        <div class="col-md-3">
          <select class="form-select" name="sort">
            <option value="newest" <%= (sort == null || sort.isEmpty() || "newest".equals(sort)) ? "selected" : "" %>>新しい順</option>
            <option value="oldest" <%= "oldest".equals(sort) ? "selected" : "" %>>古い順</option>
            <option value="mental_desc" <%= "mental_desc".equals(sort) ? "selected" : "" %>>しんどさ高い順</option>
            <option value="unconfirmed" <%= "unconfirmed".equals(sort) ? "selected" : "" %>>未確認順</option>
          </select>
        </div>
        <div class="col-md-2">
          <button class="btn btn-primary w-100" type="submit">検索</button>
        </div>
      </form>
      <div class="small text-muted mt-2">現在の並び順：<%= sortLabel %></div>
    </div>
  </div>

  <div class="d-flex gap-2 mb-3">
    <a class="btn btn-outline-primary" href="<%= request.getContextPath() %>/master/report">年間レポート</a>
  </div>

  <div class="card shadow-sm">
    <div class="card-body">
      <div class="table-responsive">
        <table class="table table-sm align-middle">
          <thead>
            <tr>
              <th>ID</th><th>記入日</th><th>氏名</th><th>状況</th><th>しんどさ</th><th></th>
            </tr>
          </thead>
          <tbody>
          <%
            if (list == null || list.isEmpty()) {
          %>
            <tr><td colspan="6" class="text-muted">データがありません。</td></tr>
          <%
            } else {
              for (Consultation c : list) {
          %>
            <tr>
              <td><%= c.getId() %></td>
              <td><%= c.getSheetDate() %></td>
              <td><%= (c.getConsultantName()==null||c.getConsultantName().isEmpty())?"（未記入）":c.getConsultantName() %></td>
              <td><%= c.getStatusLabel() %></td>
              <td><%= c.getMentalScaleLabel() %></td>
              <td>
                <a class="btn btn-sm btn-outline-secondary"
                   href="<%= request.getContextPath() %>/master/consult/detail?id=<%= c.getId() %>">詳細</a>
              </td>
            </tr>
          <%
              }
            }
          %>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <div class="mt-3">
    <a class="btn btn-outline-secondary" href="<%= request.getContextPath() %>/">トップへ戻る</a>
  </div>
</div>
</body>
</html>
