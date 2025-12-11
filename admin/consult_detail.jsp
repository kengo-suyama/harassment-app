<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.harassment.model.Consultation" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    // ===== 相談データと権限の取得 =====
    Consultation c = (Consultation) request.getAttribute("consultation");

    HttpSession httpSession = request.getSession(false);
    String role = null;
    if (httpSession != null) {
        role = (String) httpSession.getAttribute("loginRole");
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

    <%-- =========================
         1. 権限 & データ存在チェック
       ========================== --%>
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

        <%-- =========================
             2. ヘッダー（タイトル＋説明）
           ========================== --%>
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
        <!-- 管理者の対応内容 -->
<div class="card mt-4">
    <div class="card-body">
        <h2 class="h5 mb-3">管理者の対応</h2>
        <p class="text-muted small">
            面談や電話、文書での案内など、相談者に行った対応を記録します。
        </p>

        <% if (c.getFollowUpAction() != null && !c.getFollowUpAction().isEmpty()) { %>
            <pre class="bg-light p-3 border rounded"><%= c.getFollowUpAction() %></pre>
        <% } else { %>
            <p class="text-muted">まだ対応内容は登録されていません。</p>
        <% } %>

        <a href="<%= request.getContextPath() %>/admin/consult/followup/edit?id=<%= c.getId() %>"
           class="btn btn-success mt-3">
            対応内容を登録・更新する
        </a>
    </div>
</div>

        <%-- =========================
             3. 基本情報カード
           ========================== --%>
        <div class="card mb-3 shadow-sm">
            <div class="card-header bg-light">
                <strong>基本情報</strong>
            </div>
            <div class="card-body">
                <dl class="row mb-0">
                    <dt class="col-sm-3">シート記入日</dt>
                    <dd class="col-sm-9"><%= c.getSheetDate() != null ? c.getSheetDate() : "" %></dd>

                    <dt class="col-sm-3">相談者氏名</dt>
                    <dd class="col-sm-9">
                        <%
                            String name = c.getConsultantName();
                            if (name == null || name.isBlank()) {
                        %>
                            <span class="text-muted">（匿名）</span>
                        <% } else { %>
                            <%= name %>
                        <% } %>
                    </dd>

                    <dt class="col-sm-3">概要</dt>
                    <dd class="col-sm-9">
                        <pre class="mb-0"><%= c.getSummary() != null ? c.getSummary() : "" %></pre>
                    </dd>

                    <dt class="col-sm-3">共有可否</dt>
                    <dd class="col-sm-9">
                        <%= c.getSharePermission() != null ? c.getSharePermission() : "" %>
                    </dd>
                </dl>
            </div>
        </div>

        <%-- =========================
             4. 発生状況カード（PDF 2枚目項目イメージ）
           ========================== --%>
        <div class="card mb-3 shadow-sm">
            <div class="card-header bg-light">
                <strong>発生状況</strong>
            </div>
            <div class="card-body">
                <dl class="row mb-0">
                    <dt class="col-sm-3">発生日・期間</dt>
                    <dd class="col-sm-9">
                        <%= c.getIncidentDate() != null ? c.getIncidentDate() : "" %>
                    </dd>

                    <dt class="col-sm-3">発生場所</dt>
                    <dd class="col-sm-9">
                        <%= c.getIncidentPlace() != null ? c.getIncidentPlace() : "" %>
                    </dd>

                    <dt class="col-sm-3">加害者（立場など）</dt>
                    <dd class="col-sm-9">
                        <%= c.getHarasserInfo() != null ? c.getHarasserInfo() : "" %>
                    </dd>

                    <dt class="col-sm-3">被害者（立場など）</dt>
                    <dd class="col-sm-9">
                        <%= c.getVictimInfo() != null ? c.getVictimInfo() : "" %>
                    </dd>

                    <dt class="col-sm-3">具体的な行為の内容</dt>
                    <dd class="col-sm-9">
                        <pre class="mb-0"><%= c.getIncidentDetail() != null ? c.getIncidentDetail() : "" %></pre>
                    </dd>
                </dl>
            </div>
        </div>

        <%-- =========================
             5. その後の状況・心身の状態（例）
           ========================== --%>
        <div class="row">
            <div class="col-md-6">
                <div class="card mb-3 shadow-sm">
                    <div class="card-header bg-light">
                        <strong>その後の状況</strong>
                    </div>
                    <div class="card-body">
                        <pre class="mb-0">
<%= c.getAfterIncidentStatus() != null ? c.getAfterIncidentStatus() : "" %>
                        </pre>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="card mb-3 shadow-sm">
                    <div class="card-header bg-light">
                        <strong>心身の状態</strong>
                    </div>
                    <div class="card-body">
                        <pre class="mb-0">
<%= c.getMentalPhysicalState() != null ? c.getMentalPhysicalState() : "" %>
                        </pre>
                    </div>
                </div>
            </div>
        </div>

        <%-- =========================
             6. 希望・要望（例）
           ========================== --%>
        <div class="card mb-4 shadow-sm">
            <div class="card-header bg-light">
                <strong>相談者の希望・要望</strong>
            </div>
            <div class="card-body">
                <dl class="row mb-0">
                    <dt class="col-sm-3">職場環境の配慮</dt>
                    <dd class="col-sm-9">
                        <pre class="mb-0">
<%= c.getWorkplaceRequest() != null ? c.getWorkplaceRequest() : "" %>
                        </pre>
                    </dd>

                    <dt class="col-sm-3">相談窓口への要望</dt>
                    <dd class="col-sm-9">
                        <pre class="mb-0">
<%= c.getSupportRequest() != null ? c.getSupportRequest() : "" %>
                        </pre>
                    </dd>
                </dl>
            </div>
        </div>

        <%-- =========================
             7. フッターボタン
           ========================== --%>
        <div class="d-flex justify-content-between mb-5">
            <a href="<%= request.getContextPath() %>/admin/consult/list"
               class="btn btn-outline-secondary">
                一覧に戻る
            </a>

            <% if (isMaster) { %>
                <button type="button"
                        class="btn btn-warning"
                        disabled
                        title="外部機関への報告書出力（実装予定）">
                    外部機関提出用としてマーク（準備中）
                </button>
            <% } %>
        </div>

    <% } %> <%-- /権限＆データチェックの else --%>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
