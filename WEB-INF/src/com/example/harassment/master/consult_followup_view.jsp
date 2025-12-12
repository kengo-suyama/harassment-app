<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.harassment.model.Consultation" %>
<%
    Consultation c = (Consultation) request.getAttribute("consultation");
%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>相談内容確認（マスター）</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>
        @media print {
            .no-print {
                display: none !important;
            }
            body {
                background: white;
            }
            .card {
                box-shadow: none !important;
            }
        }
    </style>
</head>

<body class="bg-light">

<nav class="navbar navbar-dark bg-success mb-4 no-print">
    <div class="container-fluid">
        <span class="navbar-brand">マスター画面 - 相談内容確認</span>
    </div>
</nav>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-10">

            <!-- 相談者記入の相談シート（管理者画面と同じ内容） -->
            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <h2 class="h5 mb-3">相談シート内容（相談者の入力）</h2>

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
                        <dd class="col-sm-9"><%= c.getFutureRequestLabel() %></dd>

                        <dt class="col-sm-3">希望 詳細</dt>
                        <dd class="col-sm-9"><%= c.getFutureRequestOtherDetail() %></dd>

                        <dt class="col-sm-3">共有の可否</dt>
                        <dd class="col-sm-9"><%= c.getSharePermissionLabel() %></dd>

                        <dt class="col-sm-3">共有してよい相手</dt>
                        <dd class="col-sm-9"><%= c.getShareLimitedTargets() %></dd>
                    </dl>
                </div>
            </div>

            <!-- 管理者が確定した対応内容だけを表示（編集不可） -->
            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <h2 class="h5 mb-3 text-primary">確定した対応内容（管理者記入）</h2>

                    <% if (c.getFollowUpAction() != null && !c.getFollowUpAction().isEmpty()) { %>
                        <pre><%= c.getFollowUpAction() %></pre>
                    <% } else { %>
                        <p class="text-muted">（まだ確定した対応内容はありません）</p>
                    <% } %>
                </div>
            </div>

            <!-- 戻る／印刷ボタン -->
            <div class="d-flex justify-content-between no-print mb-4">
                <a href="<%= request.getContextPath() %>/master/consult/list"
                   class="btn btn-outline-secondary">
                    一覧へ戻る
                </a>

                <button type="button" class="btn btn-success" onclick="window.print()">
                    印刷する
                </button>
            </div>

        </div>
    </div>
</div>

</body>
</html>
