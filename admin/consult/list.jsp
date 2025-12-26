<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,com.example.harassment.model.Consultation" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>管理者画面 - 相談一覧</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container-fluid">
        <a href="<%= request.getContextPath() %>/" class="navbar-brand">
            ハラスメント相談システム
        </a>
        <span class="navbar-text text-white">管理者画面</span>
    </div>
</nav>

<div class="container">
    <h1 class="h4 mb-3">相談一覧</h1>

    <%
        String sort = request.getParameter("sort");
        String sortLabel = "新しい順";
        if ("oldest".equals(sort)) {
            sortLabel = "古い順";
        } else if ("mental_desc".equals(sort)) {
            sortLabel = "しんどさ順";
        } else if ("unconfirmed".equals(sort)) {
            sortLabel = "未確認順";
        }
    %>

    <div class="d-flex justify-content-between align-items-center mb-2">
        <form class="d-flex gap-2" method="get" action="<%= request.getContextPath() %>/admin/consult/list">
            <select class="form-select form-select-sm" name="sort">
                <option value="newest" <%= (sort == null || sort.isEmpty() || "newest".equals(sort)) ? "selected" : "" %>>新しい順</option>
                <option value="oldest" <%= "oldest".equals(sort) ? "selected" : "" %>>古い順</option>
                <option value="mental_desc" <%= "mental_desc".equals(sort) ? "selected" : "" %>>しんどさ順</option>
                <option value="unconfirmed" <%= "unconfirmed".equals(sort) ? "selected" : "" %>>未確認順</option>
            </select>
            <button class="btn btn-sm btn-outline-primary" type="submit">並び替え</button>
        </form>
        <div class="small text-muted">現在の並び順：<%= sortLabel %></div>
    </div>

    <%
        List<Consultation> consultations =
                (List<Consultation>) request.getAttribute("consultations");
    %>

    <div class="table-responsive">
    <table class="table table-sm table-striped align-middle">
        <thead>
        <tr>
            <th>ID</th>
            <th>相談日</th>
            <th>氏名</th>
            <th>概要</th>
            <th>進捗</th>
            <th>未読</th>
            <th>最新メッセージ</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <%
            if (consultations == null || consultations.isEmpty()) {
        %>
        <tr>
            <td colspan="8" class="text-center text-muted">
                まだ相談は登録されていません。
            </td>
        </tr>
        <%
            } else {
                for (Consultation c : consultations) {
        %>
        <tr>
            <td><%= c.getId() %></td>
            <td><%= c.getSheetDate() != null ? c.getSheetDate() : "" %></td>
            <td><%= c.getConsultantName() != null ? c.getConsultantName() : "" %></td>
            <td>
                <%= (c.getSummaryCategoryLabel() != null && !c.getSummaryCategoryLabel().isEmpty())
                        ? c.getSummaryCategoryLabel()
                        : (c.getSummary() != null ? c.getSummary() : "") %>
            </td>
            <td>
                <form method="post" action="<%= request.getContextPath() %>/admin/consult/status" class="d-flex gap-1">
                    <input type="hidden" name="id" value="<%= c.getId() %>">
                    <select class="form-select form-select-sm" name="status">
                        <option value="UNCONFIRMED" <%= ("UNCONFIRMED".equals(c.getStatus()) || "NEW".equals(c.getStatus()))?"selected":"" %>>未確認</option>
                        <option value="CONFIRMED" <%= ("CONFIRMED".equals(c.getStatus()) || "CHECKING".equals(c.getStatus()))?"selected":"" %>>確認</option>
                        <option value="REVIEWING" <%= "REVIEWING".equals(c.getStatus())?"selected":"" %>>対応検討中</option>
                        <option value="IN_PROGRESS" <%= "IN_PROGRESS".equals(c.getStatus())?"selected":"" %>>対応中</option>
                        <option value="DONE" <%= "DONE".equals(c.getStatus())?"selected":"" %>>対応済</option>
                    </select>
                    <button type="submit" class="btn btn-sm btn-outline-primary">更新</button>
                </form>
            </td>
            <td>
                <% if (c.getUnreadForAdmin() > 0) { %>
                    <span class="badge bg-warning text-dark"><%= c.getUnreadForAdmin() %></span>
                <% } else { %>
                    <span class="text-muted small">0</span>
                <% } %>
            </td>
            <td class="small">
                <%= c.getLatestChatMessage() != null ? c.getLatestChatMessage() : "" %>
            </td>
            <td>
                <a href="<%= request.getContextPath() %>/admin/consult/detail?id=<%= c.getId() %>"
                   class="btn btn-sm btn-outline-primary">
                    詳細
                </a>
            </td>
        </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>
    </div>

    <a href="<%= request.getContextPath() %>/" class="btn btn-outline-secondary btn-sm">
        トップへ戻る
    </a>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
