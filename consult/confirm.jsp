<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>相談内容の確認</title>
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

  // futureRequest ラベル
  java.util.List<String> frLabels = new java.util.ArrayList<>();
  if (futureRequests != null) {
    for (String fr : futureRequests) {
      if ("LISTEN".equals(fr)) frLabels.add("まず話を聞いてほしい");
      else if ("WORK_CHANGE".equals(fr)) frLabels.add("配置転換・業務内容を調整してほしい");
      else if ("ENV_IMPROVE".equals(fr)) frLabels.add("職場環境や人間関係を改善してほしい");
      else if ("FORMAL_PROCEDURE".equals(fr)) frLabels.add("正式な申し立てや調査を進めてほしい");
      else if ("MENTAL_SUPPORT".equals(fr)) frLabels.add("産業医・カウンセラー等につなげてほしい");
      else if ("OTHER".equals(fr)) frLabels.add("その他の希望");
      else frLabels.add(fr);
    }
  }
  String frJoined = frLabels.isEmpty() ? "" : String.join("、", frLabels);

  String shareLabel = "";
  if ("ALL_OK".equals(sharePermission)) shareLabel = "必要に応じて関係者に共有してよい";
  else if ("LIMITED".equals(sharePermission)) shareLabel = "共有範囲を限定してほしい";
  else if ("NO_SHARE".equals(sharePermission)) shareLabel = "相談内容は共有してほしくない";

  String reportedLabel = "";
  if ("SOMEONE".equals(reportedExists)) reportedLabel = "すでに誰かに相談している";
  else if ("NONE".equals(reportedExists)) reportedLabel = "まだ誰にも相談していない";
%>

<div class="container">
  <div class="alert alert-info">
    内容を確認し、問題なければ「この内容で送信する」を押してください。<br>
    修正する場合は「戻って修正する」を押してください。
  </div>

  <div class="card shadow-sm mb-4">
    <div class="card-body">
      <h1 class="h6 mb-3">入力内容</h1>

      <dl class="row mb-0">
        <dt class="col-sm-3">シート記入日</dt>
        <dd class="col-sm-9"><%= sheetDate != null ? sheetDate : "" %></dd>

        <dt class="col-sm-3">相談者氏名</dt>
        <dd class="col-sm-9"><%= (consultantName != null && !consultantName.isEmpty()) ? consultantName : "（未記入）" %></dd>

        <dt class="col-sm-3">相談の概要</dt>
        <dd class="col-sm-9"><pre class="mb-0"><%= summary != null ? summary : "" %></pre></dd>

        <dt class="col-sm-3 mt-3">発生後の状況</dt>
        <dd class="col-sm-9 mt-3">
          <div class="mb-1">相談の有無：<%= !reportedLabel.isEmpty() ? reportedLabel : "（未選択）" %></div>
          <div class="mb-1">相談相手：<%= reportedPerson != null ? reportedPerson : "" %></div>
          <div class="mb-1">相談日時：<%= reportedAt != null ? reportedAt : "" %></div>
          <div>その後の対応：<pre class="mb-0"><%= followUp != null ? followUp : "" %></pre></div>
        </dd>

        <dt class="col-sm-3 mt-3">心身の状態</dt>
        <dd class="col-sm-9 mt-3">
          <div class="mb-1">しんどさ：<%= (mentalScale != null && !mentalScale.isEmpty()) ? mentalScale : "（未記入）" %></div>
          <div>詳細：<pre class="mb-0"><%= mentalDetail != null ? mentalDetail : "" %></pre></div>
        </dd>

        <dt class="col-sm-3 mt-3">今後の希望</dt>
        <dd class="col-sm-9 mt-3">
          <div class="mb-1">選択内容：<%= !frJoined.isEmpty() ? frJoined : "（未選択）" %></div>
          <div>その他：<pre class="mb-0"><%= futureRequestOtherDetail != null ? futureRequestOtherDetail : "" %></pre></div>
        </dd>

        <dt class="col-sm-3 mt-3">情報共有</dt>
        <dd class="col-sm-9 mt-3">
          <div class="mb-1">共有：<%= !shareLabel.isEmpty() ? shareLabel : "（未選択）" %></div>
          <div class="mb-0">限定相手：<%= shareLimitedTargets != null ? shareLimitedTargets : "" %></div>
        </dd>
      </dl>
    </div>
  </div>

  <!-- 戻る（フォームへ値を持って戻る） -->
  <form method="post" action="<%= request.getContextPath() %>/consult/form" class="mb-2">
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

  <!-- 送信 -->
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
</body>
</html>
