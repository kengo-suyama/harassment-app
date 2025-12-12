<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>相談内容の確認 - ハラスメント相談システム</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container-fluid">
        <span class="navbar-brand">相談内容の確認</span>
    </div>
</nav>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-10">

            <div class="alert alert-info">
                以下の内容で送信してよろしければ「この内容で送信する」を押してください。<br>
                修正したい場合は「戻って修正する」を押してください。
            </div>

            <%
                request.setCharacterEncoding("UTF-8");

                String sheetDate = request.getParameter("sheetDate");
                String consultantName = request.getParameter("consultantName");
                String summary = request.getParameter("summary");

                String reportedExists = request.getParameter("reportedExists");
                String reportedPerson = request.getParameter("reportedPerson");
                String reportedAt = request.getParameter("reportedAt");
                String followUp = request.getParameter("followUp");

                String mentalScale = request.getParameter("mentalScale");
                String mentalDetail = request.getParameter("mentalDetail");

                String[] futureRequests = request.getParameterValues("futureRequest");
                String futureRequestOtherDetail = request.getParameter("futureRequestOtherDetail");

                String sharePermission = request.getParameter("sharePermission");
                String shareLimitedTargets = request.getParameter("shareLimitedTargets");

                // futureRequest の日本語ラベル化（簡易版）
                java.util.List<String> futureRequestLabels = new java.util.ArrayList<>();
                if (futureRequests != null) {
                    for (String fr : futureRequests) {
                        if ("WORK_CONTINUE".equals(fr)) {
                            futureRequestLabels.add("同じ職場で働き続けたい");
                        } else if ("WORK_CHANGE".equals(fr)) {
                            futureRequestLabels.add("部署異動や働き方の変更を検討したい");
                        } else if ("REST".equals(fr)) {
                            futureRequestLabels.add("休職や休みを取りたい");
                        } else if ("ONLY_LISTEN".equals(fr)) {
                            futureRequestLabels.add("まずは話だけ聞いてほしい");
                        } else if ("OTHER".equals(fr)) {
                            futureRequestLabels.add("その他");
                        } else {
                            futureRequestLabels.add(fr);
                        }
                    }
                }

                String futureRequestLabelJoined = "";
                if (!futureRequestLabels.isEmpty()) {
                    futureRequestLabelJoined = String.join("、", futureRequestLabels);
                }

                // 共有の可否ラベル
                String sharePermissionLabel = "";
                if ("ALL_OK".equals(sharePermission)) {
                    sharePermissionLabel = "必要に応じて広く共有してよい";
                } else if ("LIMITED".equals(sharePermission)) {
                    sharePermissionLabel = "限られた人にだけ共有してよい";
                } else if ("NO_SHARE".equals(sharePermission)) {
                    sharePermissionLabel = "できるだけ共有してほしくない";
                }
            %>

            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <h1 class="h5 mb-3">相談内容の確認</h1>

                    <dl class="row mb-0">
                        <dt class="col-sm-3">シート記入日</dt>
                        <dd class="col-sm-9"><%= sheetDate != null ? sheetDate : "" %></dd>

                        <dt class="col-sm-3">相談者氏名</dt>
                        <dd class="col-sm-9"><%= (consultantName != null && !consultantName.isEmpty()) ? consultantName : "（未記入）" %></dd>

                        <dt class="col-sm-3">相談の概要</dt>
                        <dd class="col-sm-9">
                            <pre class="mb-0"><%= summary != null ? summary : "" %></pre>
                        </dd>

                        <dt class="col-sm-3 mt-3">発生後の状況</dt>
                        <dd class="col-sm-9 mt-3">
                            <p class="mb-1">
                                相談の有無：
                                <%
                                    if ("YES".equals(reportedExists)) {
                                        out.print("すでに誰かに相談している");
                                    } else if ("NO".equals(reportedExists)) {
                                        out.print("まだ誰にも相談していない");
                                    } else {
                                        out.print("（未選択）");
                                    }
                                %>
                            </p>
                            <p class="mb-1">相談相手：<%= reportedPerson != null ? reportedPerson : "" %></p>
                            <p class="mb-1">相談日時：<%= reportedAt != null ? reportedAt : "" %></p>
                            <p class="mb-0">
                                その後の対応：
                                <br>
                                <pre class="mb-0"><%= followUp != null ? followUp : "" %></pre>
                            </p>
                        </dd>

                        <dt class="col-sm-3 mt-3">現在の心身の状態</dt>
                        <dd class="col-sm-9 mt-3">
                            <p class="mb-1">
                                しんどさ（1〜10）：
                                <%= (mentalScale != null && !mentalScale.isEmpty()) ? mentalScale : "（未記入）" %>
                            </p>
                            <p class="mb-0">
                                詳細：
                                <br>
                                <pre class="mb-0"><%= mentalDetail != null ? mentalDetail : "" %></pre>
                            </p>
                        </dd>

                        <dt class="col-sm-3 mt-3">今後の希望</dt>
                        <dd class="col-sm-9 mt-3">
                            <p class="mb-1">
                                選択内容：
                                <%= !futureRequestLabelJoined.isEmpty() ? futureRequestLabelJoined : "（未選択）" %>
                            </p>
                            <p class="mb-0">
                                その他の希望：
                                <br>
                                <pre class="mb-0"><%= futureRequestOtherDetail != null ? futureRequestOtherDetail : "" %></pre>
                            </p>
                        </dd>

                        <dt class="col-sm-3 mt-3">情報の共有について</dt>
                        <dd class="col-sm-9 mt-3">
                            <p class="mb-1">共有の希望：<%= !sharePermissionLabel.isEmpty() ? sharePermissionLabel : "（未選択）" %></p>
                            <p class="mb-0">共有してよい相手：<%= shareLimitedTargets != null ? shareLimitedTargets : "" %></p>
                        </dd>
                    </dl>
                </div>
            </div>

                        <!-- 戻る用フォーム -->
                        <form method="post" action="<%= request.getContextPath() %>/consult/form">
                            <!-- hidden で全項目を詰める -->
                            <input type="hidden" name="sheetDate" value="<%= sheetDate != null ? sheetDate : "" %>">
                            <input type="hidden" name="consultantName" value="<%= consultantName != null ? consultantName : "" %>">
                            <input type="hidden" name="summary" value="<%= summary != null ? summary : "" %>">
            
                            <input type="hidden" name="reportedExists" value="<%= reportedExists != null ? reportedExists : "" %>">
                            <input type="hidden" name="reportedPerson" value="<%= reportedPerson != null ? reportedPerson : "" %>">
                            <input type="hidden" name="reportedAt" value="<%= reportedAt != null ? reportedAt : "" %>">
                            <input type="hidden" name="followUp" value="<%= followUp != null ? followUp : "" %>">
            
                            <input type="hidden" name="mentalScale" value="<%= mentalScale != null ? mentalScale : "" %>">
                            <input type="hidden" name="mentalDetail" value="<%= mentalDetail != null ? mentalDetail : "" %>">
            
                            <%
                                if (futureRequests != null) {
                                    for (String fr : futureRequests) {
                            %>
                                        <input type="hidden" name="futureRequest" value="<%= fr %>">
                            <%
                                    }
                                }
                            %>
                            <input type="hidden" name="futureRequestOtherDetail"
                                   value="<%= futureRequestOtherDetail != null ? futureRequestOtherDetail : "" %>">
            
                            <input type="hidden" name="sharePermission" value="<%= sharePermission != null ? sharePermission : "" %>">
                            <input type="hidden" name="shareLimitedTargets"
                                   value="<%= shareLimitedTargets != null ? shareLimitedTargets : "" %>">
            
                                   <div class="d-flex justify-content-between mb-3">
                                    <button type="submit" class="btn btn-outline-secondary">
                                        戻って修正する
                                    </button>
                                </div>
                            </form>
            
                        <!-- 最終送信用フォーム -->
                        <form method="post" action="<%= request.getContextPath() %>/consult/submit">
                            <!-- 同じく hidden で全項目を詰める -->
                            <input type="hidden" name="sheetDate" value="<%= sheetDate != null ? sheetDate : "" %>">
                            <input type="hidden" name="consultantName" value="<%= consultantName != null ? consultantName : "" %>">
                            <input type="hidden" name="summary" value="<%= summary != null ? summary : "" %>">
            
                            <input type="hidden" name="reportedExists" value="<%= reportedExists != null ? reportedExists : "" %>">
                            <input type="hidden" name="reportedPerson" value="<%= reportedPerson != null ? reportedPerson : "" %>">
                            <input type="hidden" name="reportedAt" value="<%= reportedAt != null ? reportedAt : "" %>">
                            <input type="hidden" name="followUp" value="<%= followUp != null ? followUp : "" %>">
            
                            <input type="hidden" name="mentalScale" value="<%= mentalScale != null ? mentalScale : "" %>">
                            <input type="hidden" name="mentalDetail" value="<%= mentalDetail != null ? mentalDetail : "" %>">
            
                            <%
                                if (futureRequests != null) {
                                    for (String fr : futureRequests) {
                            %>
                                        <input type="hidden" name="futureRequest" value="<%= fr %>">
                            <%
                                    }
                                }
                            %>
                            <input type="hidden" name="futureRequestOtherDetail"
                                   value="<%= futureRequestOtherDetail != null ? futureRequestOtherDetail : "" %>">
            
                            <input type="hidden" name="sharePermission" value="<%= sharePermission != null ? sharePermission : "" %>">
                            <input type="hidden" name="shareLimitedTargets"
                                   value="<%= shareLimitedTargets != null ? shareLimitedTargets : "" %>">
            
                            <div class="d-flex justify-content-end mb-4">
                                <button type="submit" class="btn btn-primary">
                                    この内容で送信する
                                </button>
                            </div>
                        </form>
            

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
