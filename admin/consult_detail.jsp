<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.harassment.model.Consultation" %>
<%
    Consultation c = (Consultation) request.getAttribute("consultation");
%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>相談詳細（管理者）</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container-fluid">
        <span class="navbar-brand">管理者画面 - 相談詳細</span>
    </div>
</nav>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-10">

            <!-- 相談者が記入したシート内容 -->
            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <h1 class="h5 mb-3">相談シート内容</h1>

                    <dl class="row mb-0">

                        <dt class="col-sm-3">相談ID</dt>
                        <dd class="col-sm-9"><%= c.getId() %></dd>

                        <dt class="col-sm-3">記入日</dt>
                        <dd class="col-sm-9"><%= c.getSheetDate() %></dd>

                        <dt class="col-sm-3">相談者</dt>
                        <dd class="col-sm-9"><%= c.getConsultantName() %></dd>

                        <dt class="col-sm-3">相談概要</dt>
                        <dd class="col-sm-9"><pre><%= c.getSummary() %></pre></dd>

                        <dt class="col-sm-3">すでに相談したか</dt>
                        <dd class="col-sm-9"><%= c.getReportedExistsLabel() %></dd>

                        <dt class="col-sm-3">相談した相手</dt>
                        <dd class="col-sm-9"><%= c.getReportedPerson() %></dd>

                        <dt class="col-sm-3">相談日時</dt>
                        <dd class="col-sm-9"><%= c.getReportedAt() %></dd>

                        <dt class="col-sm-3">相談後の状況</dt>
                        <dd class="col-sm-9"><pre><%= c.getFollowUp() %></pre></dd>

                        <dt class="col-sm-3">心身の状態（数値）</dt>
                        <dd class="col-sm-9"><%= c.getMentalScale() %></dd>

                        <dt class="col-sm-3">心身の状態（詳細）</dt>
                        <dd class="col-sm-9"><pre><%= c.getMentalDetail() %></pre></dd>

                        <dt class="col-sm-3">今後の希望</dt>
                        <dd class="col-sm-9"><%= c.getFutureRequestLabelString() %></dd>


                        <dt class="col-sm-3">希望 詳細</dt>
                        <dd class="col-sm-9"><%= c.getFutureRequestOtherDetail() %></dd>

                        <dt class="col-sm-3">共有の可否</dt>
                        <dd class="col-sm-9"><%= c.getSharePermissionLabel() %></dd>

                        <dt class="col-sm-3">共有してよい相手</dt>
                        <dd class="col-sm-9"><%= c.getShareLimitedTargets() %></dd>
                    </dl>
                </div>
            </div>

            <!-- 管理者対応欄（下書き・確定） -->
            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <h2 class="h5 mb-3">管理者対応欄</h2>

                    <p class="mb-1 fw-bold">一時保存中の対応案（下書き）</p>
                    <% if (c.getFollowUpDraft() != null && !c.getFollowUpDraft().isEmpty()) { %>
                        <pre><%= c.getFollowUpDraft() %></pre>
                    <% } else { %>
                        <p class="text-muted">（下書きは登録されていません）</p>
                    <% } %>

                    <hr>

                    <p class="mb-1 fw-bold">確定した対応内容（マスターに共有される内容）</p>
                    <% if (c.getFollowUpAction() != null && !c.getFollowUpAction().isEmpty()) { %>
                        <pre><%= c.getFollowUpAction() %></pre>
                    <% } else { %>
                        <p class="text-muted">（まだ確定した対応内容はありません）</p>
                    <% } %>
                </div>
            </div>

            <div class="d-flex justify-content-between mb-4">
                <a href="<%= request.getContextPath() %>/admin/consult/list"
                   class="btn btn-outline-secondary">
                    一覧へ戻る
                </a>

                <a href="<%= request.getContextPath() %>/admin/consult/followup/edit?id=<%= c.getId() %>"
                   class="btn btn-primary">
                    対応内容を編集する
                </a>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
