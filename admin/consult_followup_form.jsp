<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.harassment.model.Consultation" %>
<%
    Consultation c = (Consultation) request.getAttribute("consultation");
%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>対応内容入力 - ハラスメント相談システム</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container-fluid">
        <span class="navbar-brand">管理者画面 - 対応内容入力</span>
    </div>
</nav>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-8">

            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <h1 class="h5 mb-3">相談情報</h1>
                    <dl class="row mb-0">
                        <dt class="col-sm-3">相談ID</dt>
                        <dd class="col-sm-9"><%= c.getId() %></dd>

                        <dt class="col-sm-3">記入日</dt>
                        <dd class="col-sm-9"><%= c.getSheetDate() != null ? c.getSheetDate() : "" %></dd>

                        <dt class="col-sm-3">相談者</dt>
                        <dd class="col-sm-9"><%= c.getConsultantName() != null ? c.getConsultantName() : "（未記入）" %></dd>

                        <dt class="col-sm-3">相談概要</dt>
                        <dd class="col-sm-9">
                            <pre class="mb-0"><%= c.getSummary() != null ? c.getSummary() : "" %></pre>
                        </dd>
                    </dl>
                </div>
            </div>

            <div class="card shadow-sm">
                <div class="card-body">
                    <h2 class="h5 mb-3">対応内容の記録</h2>
                    <p class="text-muted small">
                        面談の実施状況、日時、対応者、相談者への説明内容などを具体的に記録してください。<br>
                        「一時保存」は途中メモ、「提出」は全権管理者に共有される最終版です。
                    </p>

                    <form action="<%= request.getContextPath() %>/admin/consult/followup/save" method="post">
                        <input type="hidden" name="id" value="<%= c.getId() %>">

                        <div class="mb-3">
                            <label class="form-label">対応内容（編集可能）</label>
                            <textarea name="followUpText"
                                      rows="10"
                                      class="form-control"
                                      placeholder="例）面談日時、対応者、実施した説明内容、今後のフォロー方法などを記載"><%
    String text = c.getFollowUpDraft();
    if (text == null || text.isEmpty()) {
        text = c.getFollowUpAction();
    }
    if (text == null) text = "";
%><%= text %></textarea>
                        </div>

                        <div class="d-flex justify-content-between">
                            <a href="<%= request.getContextPath() %>/admin/consult/detail?id=<%= c.getId() %>"
                               class="btn btn-outline-secondary">
                                詳細画面へ戻る
                            </a>

                            <div class="d-flex gap-2">
                                <button type="submit"
                                        name="submitType"
                                        value="draft"
                                        class="btn btn-outline-primary">
                                    一時保存
                                </button>

                                <button type="submit"
                                        name="submitType"
                                        value="final"
                                        class="btn btn-primary">
                                    提出（確定）
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
