<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.example.harassment.model.Consultation" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>相談一覧（管理用）</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>
<body class="bg-light">

<%
    // ===== 権限判定 =====
    HttpSession session = request.getSession(false);
    String role = null;
    if (session != null) {
        role = (String) session.getAttribute("loginRole");
    }
    boolean isAdmin  = "ADMIN".equals(role);
    boolean isMaster = "MASTER".equals(role);

    // ===== 相談リストの取得 =====
    Object obj = request.getAttribute("consultations");
    if (obj == null) {
        obj = request.getAttribute("consultationList");
    }
    List<Consultation> list =
            obj != null ? (List<Consultation>) obj : Collections.emptyList();
%>

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container-fluid">
        <span class="navbar-brand">
            ハラスメント相談システム - 管理画面
        </span>
        <% if (isAdmin) { %>
            <span class="badge bg-primary">管理者</span>
        <% } else if (isMaster) { %>
            <span class="badge bg-warning text-dark">マスター</span>
        <% } else { %>
            <span class="badge bg-secondary">未ログイン</span>
        <% } %>
    </div>
</nav>

<div class="container mb-5">

    <% if (!isAdmin && !isMaster) { %>

        <div class="alert alert-danger">
            この画面はログインした管理者・マスターのみが閲覧できます。
        </div>
        <div class="d-flex gap-2">
            <a href="<%= request.getContextPath() %>/admin_login.jsp"
               class="btn btn-outline-secondary">管理者ログインへ</a>
            <a href="<%= request.getContextPath() %>/master_login.jsp"
               class="btn btn-outline-dark">マスターログインへ</a>
            <a href="<%= request.getContextPath() %>/"
               class="btn btn-link">トップへ戻る</a>
        </div>

    <% } else { %>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <% if (isAdmin) { %>
                    <h1 class="h4 mb-0">相談一覧（管理者用）</h1>
                    <div class="text-muted small">入力内容の確認・社内対応のための画面です。</div>
                <% } else if (isMaster) { %>
                    <h1 class="h4 mb-0">相談一覧（マスター用）</h1>
                    <div class="text-muted small">
                        外部機関への相談・報告の判断材料として利用する画面です。
                    </div>
                <% } %>
            </div>

            <div class="text-end">
                <div class="btn-group">
                    <a href="<%= request.getContextPath() %>/password/change"
                       class="btn btn-sm btn-outline-secondary">
                        パスワード変更
                    </a>

                    <% if (isAdmin) { %>
                        <a href="<%= request.getContextPath() %>/consult/consult_form.jsp"
                           class="btn btn-sm btn-outline-primary">
                            相談フォームを開く
                        </a>
                    <% } %>

                    <% if (isMaster) { %>
                        <button type="button"
                                class="btn btn-sm btn-outline-warning"
                                disabled>
                            外部機関提出用CSV出力（準備中）
                        </button>
                    <% } %>
                </div>
                <div class="mt-1">
                    <a href="<%= request.getContextPath() %>/" class="small">
                        トップへ戻る
                    </a>
                </div>
            </div>
        </div>

        <div class="card shadow-sm">
            <div class="card-body p-0">
                <% if (list.isEmpty()) { %>
                    <p class="p-3 mb-0 text-muted">
                        まだ相談データは登録されていません。
                    </p>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-sm table-striped mb-0 align-middle">
                            <thead class="table-light">
                            <tr>
                                <th scope="col">ID</th>
                                <th scope="col">シート記入日</th>
                                <th scope="col">相談者</th>
                                <th scope="col">概要</th>
                                <% if (isMaster) { %>
                                    <th scope="col">共有可否</th>
                                <% } %>
                                <th scope="col" style="width: 120px;">操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% for (Consultation c : list) { %>
                                <tr>
                                    <td><%= c.getId() %></td>
                                    <td><%= c.getSheetDate() %></td>
                                    <td>
                                        <%
                                            String name = c.getConsultantName();
                                            if (name == null || name.isBlank()) {
                                        %>
                                            <span class="text-muted">（匿名）</span>
                                        <% } else { %>
                                            <%= name %>
                                        <% } %>
                                    </td>
                                    <td>
                                        <%
                                            String summary = c.getSummary();
                                            if (summary != null && summary.length() > 30) {
                                                summary = summary.substring(0, 30) + "…";
                                            }
                                        %>
                                        <span title="<%= c.getSummary() %>"><%= summary %></span>
                                    </td>

                                    <% if (isMaster) { %>
                                        <td>
                                            <%= c.getSharePermission() != null ? c.getSharePermission() : "" %>
                                        </td>
                                    <% } %>

                                    <td>
                                        <div class="btn-group btn-group-sm">
                                            <a href="<%= request.getContextPath() %>/admin/consult/detail?id=<%= c.getId() %>"
                                               class="btn btn-outline-primary">
                                                詳細
                                            </a>

                                            <% if (isMaster) { %>
                                                <button type="button"
                                                        class="btn btn-outline-warning"
                                                        disabled
                                                        title="外部機関への報告リストに追加（実装予定）">
                                                    外部機関連携
                                                </button>
                                            <% } %>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        </div>

    <% } %>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
