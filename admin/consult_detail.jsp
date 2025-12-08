<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.harassment.model.Consultation" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    Consultation c = (Consultation) request.getAttribute("consultation");

    HttpSession session = request.getSession(false);
    String role = null;
    if (session != null) {
        role = (String) session.getAttribute("loginRole");
    }
    boolean isAdmin  = "ADMIN".equals(role);
    boolean isMaster = "MASTER".equals(role);
%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>相談詳細（管理用）</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container-fluid">
        <a href="<%= request.getContextPath() %>/admin/consult/list"
           class="navbar-brand text-decoration-none">
            ハラスメント相談システム - 詳細画面
        </a>
        <% if (isAdmin) { %>
            <span class="badge bg-primary">管理者</span>
        <% } else if (isMaster) { %>
            <span class="badge bg-warning text-dark">マスター（外部機関連携担当）</span>
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
        <a href="<%= request.getContextPath() %>/" class="btn btn-outline-secondary">
            トップへ戻る
        </a>
    <% } else if (c == null) { %>
        <div class="alert alert-danger">
            該当する相談データが見つかりませんでした。
        </div>
        <a href="<%= request.getContextPath() %>/admin/consult/list"
           class="btn btn-outline-secondary">
            一覧に戻る
        </a>
    <% } else { %>

    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h1 class="h4 mb-0">
                相談詳細（ID：<%= c.getId() %>）
            </h1>
            <% if (isAdmin) { %>
                <div class="text-muted small">
                    社内での状況整理・対応検討のために利用してください。
                </div>
            <% } else if (isMaster) { %>
                <div class="text-muted small">
                    外部機関への相談が必要かどうかの判断材料として利用してください。
                </div>
            <% } %>
        </div>
        <div class="text-end">
            <a href="<%= request.getContextPath() %>/admin/consult/list"
               class="btn btn-sm btn-outline-secondary">
                一覧に戻る
            </a>
            <a href="<%= request.getContextPath() %>/password/change"
               class="btn btn-sm btn-outline-secondary">
                パスワード変更
            </a>
        </div>
    </div>

    <%-- 以下、既に作成済みの「基本情報」「発生後の状況」「心身の状態」などのカードはそのまま --%>
    <%-- ……ここに前回お渡しした card のブロックが続くイメージ…… --%>

    <% } %> <%-- /ログイン・データ存在チェック --%>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>


    <!-- 基本情報 -->
    <div class="card mb-3 shadow-sm">
        <div class="card-header fw-bold">
            基本情報
        </div>
        <div class="card-body">
            <p><strong>シート記入日：</strong> <%= c.getSheetDate() %></p>
            <p><strong>相談者氏名：</strong>
                <%= (c.getConsultantName() != null && !c.getConsultantName().isBlank())
                    ? c.getConsultantName()
                    : "（匿名）" %>
            </p>
            <p><strong>相談の概要：</strong></p>
            <pre class="bg-light p-2 border rounded"><%= c.getSummary() %></pre>
        </div>
    </div>

    <!-- 発生後の状況 -->
    <div class="card mb-3 shadow-sm">
        <div class="card-header fw-bold">
            発生後の状況
        </div>
        <div class="card-body">
            <p><strong>他者への相談・報告の有無：</strong>
                <%= c.getReportedExists() != null ? c.getReportedExists() : "" %>
            </p>
            <p><strong>相談相手：</strong> <%= c.getReportedPerson() %></p>
            <p><strong>相談日時：</strong> <%= c.getReportedAt() %></p>
            <p><strong>その後の対応：</strong></p>
            <pre class="bg-light p-2 border rounded"><%= c.getFollowUp() %></pre>
        </div>
    </div>

    <!-- 心身の状態 -->
    <div class="card mb-3 shadow-sm">
        <div class="card-header fw-bold">
            心身の状態
        </div>
        <div class="card-body">
            <p>
                <strong>ストレスの自己評価：</strong>
                <% if (c.getMentalScale() != null) { %>
                    <span class="badge bg-danger fs-6"><%= c.getMentalScale() %> / 10</span>
                <% } else { %>
                    （未入力）
                <% } %>
            </p>
            <p><strong>心身の状態・不安など：</strong></p>
            <pre class="bg-light p-2 border rounded"><%= c.getMentalDetail() %></pre>
        </div>
    </div>

    <!-- 今後の希望 -->
    <div class="card mb-3 shadow-sm">
        <div class="card-header fw-bold">
            今後の対応に関する希望
        </div>
        <div class="card-body">
            <p><strong>希望項目：</strong></p>
            <%
                String futureRequest = c.getFutureRequest();
                if (futureRequest != null && !futureRequest.isBlank()) {
                    String[] reqs = futureRequest.split(",");
            %>
                <ul>
                    <% for (String r : reqs) { %>
                        <li><%= r %></li>
                    <% } %>
                </ul>
            <%
                } else {
            %>
                <p class="text-muted">（特に選択なし）</p>
            <%
                }
            %>

            <p><strong>その他の希望：</strong></p>
            <pre class="bg-light p-2 border rounded"><%= c.getFutureRequestOtherDetail() %></pre>
        </div>
    </div>

    <!-- 相談内容の共有可否 -->
    <div class="card mb-4 shadow-sm">
        <div class="card-header fw-bold">
            相談内容の共有可否
        </div>
        <div class="card-body">
            <p><strong>共有可否：</strong>
                <%= c.getSharePermission() != null ? c.getSharePermission() : "" %>
            </p>
            <p><strong>共有対象（限定共有の場合）：</strong></p>
            <pre class="bg-light p-2 border rounded"><%= c.getShareLimitedTargets() %></pre>
        </div>
    </div>

    <% } %>

    <div class="d-flex justify-content-between mb-5">
        <a href="<%= request.getContextPath() %>/admin/consult/list"
           class="btn btn-outline-secondary">
            一覧に戻る
        </a>
        <a href="<%= request.getContextPath() %>/consult/consult_form.jsp"
           class="btn btn-primary">
            新規相談を入力する
        </a>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

