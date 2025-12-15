<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>相談内容の確認 - ハラスメント相談システム</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
  <div class="container-fluid">
    <a class="navbar-brand" href="<%= request.getContextPath() %>/">ハラスメント相談システム</a>
    <span class="navbar-text text-white">相談内容の確認</span>
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

        // 日本語ラベル（表示用）
        java.util.List<String> futureLabels = new java.util.ArrayList<>();
        if (futureRequests != null) {
          for (String fr : futureRequests) {
            if ("LISTEN_ONLY".equals(fr)) futureLabels.add("相談したかっただけ（まず話を聞いてほしい）");
            else if ("WAIT".equals(fr)) futureLabels.add("様子を見たい");
            else if ("FACT_CHECK".equals(fr)) futureLabels.add("事実確認してほしい");
            else if ("WARN".equals(fr)) futureLabels.add("行為者に注意してほしい");
            else if ("WORK_CHANGE".equals(fr)) futureLabels.add("担当変更等、今後の業務について相談したい（配置転換など）");
            else if ("OTHER".equals(fr)) futureLabels.add("その他");
            else futureLabels.add(fr);
          }
        }
        String futureJoined = futureLabels.isEmpty() ? "" : String.join("、", futureLabels);

        String reportedExistsLabel = "";
        if ("YES".equals(reportedExists)) reportedExistsLabel = "すでに誰かに相談している";
        else if ("NO".equals(reportedExists)) reportedExistsLabel = "まだ誰にも相談していない";

        String sharePermissionLabel = "";
        if ("ALL_OK".equals(sharePermission)) sharePermissionLabel = "必要と判断される関係者には共有してよい";
        else if ("LIMITED".equals(sharePermission)) sharePermissionLabel = "共有する相手を限定してほしい";
        else if ("NO_SHARE".equals(sharePermission)) sharePermissionLabel = "相談窓口以外には共有しないでほしい";
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
            <dd class="col-sm-9"><pre class="mb-0"><%= summary != null ? summary : "" %></pre></dd>

            <dt class="col-sm-3 mt-3">発生後の状況</dt>
            <dd class="col-sm-9 mt-3">
              <p class="mb-1">相談の有無：<%= !reportedExistsLabel.isEmpty() ? reportedExistsLabel : "（未選択）" %></p>
              <p class="mb-1">相談相手：<%= reportedPerson != null ? reportedPerson : "" %></p>
              <p class="mb-1">相談日時：<%= reportedAt != null ? reportedAt : "" %></p>
              <p class="mb-0">その後の対応：<pre class="mb-0"><%= followUp != null ? followUp : "" %></pre></p>
            </dd>

            <dt class="col-sm-3 mt-3">現在の心身の状態</dt>
            <dd class="col-sm-9 mt-3">
              <p class="mb-1">しんどさ（1〜10）：<%= (mentalScale != null && !mentalScale.isEmpty()) ? mentalScale : "（未記入）" %></p>
              <p class="mb-0">詳細：<pre class="mb-0"><%= mentalDetail != null ? mentalDetail : "" %></pre></p>
            </dd>

            <dt class="col-sm-3 mt-3">今後の希望</dt>
            <dd class="col-sm-9 mt-3">
              <p class="mb-1">選択内容：<%= !futureJoined.isEmpty() ? futureJoined : "（未選択）" %></p>
              <p class="mb-0">その他の希望：<pre class="mb-0"><%= futureRequestOtherDetail != null ? futureRequestOtherDetail : "" %></pre></p>
            </dd>

            <dt class="col-sm-3 mt-3">情報の共有について</dt>
            <dd class="col-sm-9 mt-3">
              <p class="mb-1">共有の希望：<%= !sharePermissionLabel.isEmpty() ? sharePermissionLabel : "（未選択）" %></p>
              <p class="mb-0">共有してよい相手：<%= shareLimitedTargets != null ? shareLimitedTargets : "" %></p>
            </dd>
          </dl>
        </div>
      </div>

      <!-- 戻る（POSTで値を持って /consult/form へ） -->
      <form method="post" action="<%= request.getContextPath() %>/consult/form" class="mb-3">
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

        <input type="hidden" name="futureRequestOtherDetail" value="<%= futureRequestOtherDetail != null ? futureRequestOtherDetail : "" %>">
        <input type="hidden" name="sharePermission" value="<%= sharePermission != null ? sharePermission : "" %>">
        <input type="hidden" name="shareLimitedTargets" value="<%= shareLimitedTargets != null ? shareLimitedTargets : "" %>">

        <button type="submit" class="btn btn-outline-secondary">戻って修正する</button>
      </form>

      <!-- 最終送信（POSTで /consult/submit へ） -->
      <form method="post" action="<%= request.getContextPath() %>/consult/submit">
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

        <input type="hidden" name="futureRequestOtherDetail" value="<%= futureRequestOtherDetail != null ? futureRequestOtherDetail : "" %>">
        <input type="hidden" name="sharePermission" value="<%= sharePermission != null ? sharePermission : "" %>">
        <input type="hidden" name="shareLimitedTargets" value="<%= shareLimitedTargets != null ? shareLimitedTargets : "" %>">

        <button type="submit" class="btn btn-primary">この内容で送信する</button>
      </form>

    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
