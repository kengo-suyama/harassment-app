<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>

<%!
    // 単一値用 old() 相当
    String old(HttpServletRequest request, String name) {
        String v = request.getParameter(name);
        return v != null ? v : "";
    }

    // チェックボックス複数選択用
    boolean oldChecked(HttpServletRequest request, String name, String value) {
        String[] values = request.getParameterValues(name);
        if (values == null) return false;
        for (String v : values) {
            if (value.equalsIgnoreCase(v)) return true;
        }
        return false;
    }

    // ラジオボタン用（指定がなければ defaultValue を採用）
    boolean oldRadio(HttpServletRequest request, String name, String value, String defaultValue) {
        String v = request.getParameter(name);
        if (v == null || v.isEmpty()) v = defaultValue;
        return value.equalsIgnoreCase(v);
    }
%>

<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>ハラスメント相談シート</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
  <div class="container-fluid">
    <a class="navbar-brand" href="<%= request.getContextPath() %>/">ハラスメント相談システム</a>
  </div>
</nav>

<div class="container">
  <div class="row justify-content-center">
    <div class="col-lg-9">

      <div class="card shadow-sm mb-4">
        <div class="card-body">
          <h1 class="h4 mb-3">ハラスメント相談シート</h1>
          <p class="text-muted small mb-0">
            気になること・不安なことがあれば、可能な範囲でご記入ください。（※は必須）
          </p>
        </div>
      </div>

      <%
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (errorMessage != null && !errorMessage.isEmpty()) {
      %>
      <div class="alert alert-danger"><%= errorMessage %></div>
      <%
        }
      %>

      <!-- ★ フォーム開始 -->
      <form method="post" action="<%= request.getContextPath() %>/consult/confirm">

        <!-- 1. 基本情報 -->
        <div class="card shadow-sm mb-4">
          <div class="card-header bg-primary text-white">基本情報</div>
          <div class="card-body">

            <div class="mb-3">
              <label class="form-label">シート記入日</label>
              <input type="date" name="sheetDate" class="form-control"
                     value="<%= old(request, "sheetDate") %>">
            </div>

            <div class="mb-3">
              <label class="form-label">相談者氏名（任意）</label>
              <input type="text" name="consultantName" class="form-control"
                     placeholder="例）山田 太郎"
                     value="<%= old(request, "consultantName") %>">
            </div>
          </div>
        </div>

        <!-- 2. 相談内容の概要（必須） -->
        <div class="card shadow-sm mb-4">
          <div class="card-header bg-secondary text-white">相談内容の概要（※）</div>
          <div class="card-body">
            <div class="mb-3">
              <label class="form-label">
                どのようなことでお困りですか？（概要）<span class="text-danger">※</span>
              </label>
              <textarea name="summary" rows="6" class="form-control" required
                        placeholder="例）いつ、どこで、誰が、誰から、どんな言動を受けたか等"><%= old(request, "summary") %></textarea>
            </div>
          </div>
        </div>

        <!-- 3. 発生後の状況 -->
        <div class="card shadow-sm mb-4">
          <div class="card-header bg-info text-white">発生後の状況</div>
          <div class="card-body">

            <div class="mb-3">
              <label class="form-label">すでに誰かに相談しましたか？</label>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="reportedExists" value="YES"
                       <%= oldRadio(request, "reportedExists", "YES", "") ? "checked" : "" %>>
                <label class="form-check-label">はい</label>
              </div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="reportedExists" value="NO"
                       <%= oldRadio(request, "reportedExists", "NO", "") ? "checked" : "" %>>
                <label class="form-check-label">いいえ</label>
              </div>
            </div>

            <div class="mb-3">
              <label class="form-label">相談した相手</label>
              <input type="text" name="reportedPerson" class="form-control"
                     placeholder="例）職場の同僚、人事担当者 等"
                     value="<%= old(request, "reportedPerson") %>">
            </div>

            <div class="mb-3">
              <label class="form-label">相談した日時（カレンダー/時刻で選べます）</label>
              <input type="datetime-local" name="reportedAt" class="form-control"
                     value="<%= old(request, "reportedAt") %>">
            </div>

            <div class="mb-3">
              <label class="form-label">その後の対応や経過</label>
              <textarea name="followUp" rows="4" class="form-control"
                        placeholder="例）部署異動の提案があったが未決定 等"><%= old(request, "followUp") %></textarea>
            </div>
          </div>
        </div>

        <!-- 4. 現在の心身の状態 -->
        <div class="card shadow-sm mb-4">
          <div class="card-header bg-warning">現在の心身の状態</div>
          <div class="card-body">
            <div class="mb-3">
              <label class="form-label">今のつらさ（1〜10：数字が大きいほどつらい）</label>
              <input type="number" name="mentalScale" min="1" max="10" class="form-control"
                     value="<%= old(request, "mentalScale").isEmpty() ? "5" : old(request, "mentalScale") %>">
            </div>
            <div class="mb-3">
              <label class="form-label">心身の状態の詳細（任意）</label>
              <textarea name="mentalDetail" rows="4" class="form-control"
                        placeholder="例）眠れない・食欲がない 等"><%= old(request, "mentalDetail") %></textarea>
            </div>
          </div>
        </div>

        <!-- 5. 今後の希望（複数） -->
        <div class="card shadow-sm mb-4">
          <div class="card-header bg-success text-white">今後の希望（複数選択可）</div>
          <div class="card-body">

            <div class="form-check">
              <input class="form-check-input" type="checkbox" name="futureRequest" value="LISTEN_ONLY"
                     <%= oldChecked(request, "futureRequest", "LISTEN_ONLY") ? "checked" : "" %>>
              <label class="form-check-label">相談したかっただけ（まず話を聞いてほしい）</label>
            </div>

            <div class="form-check">
              <input class="form-check-input" type="checkbox" name="futureRequest" value="WAIT"
                     <%= oldChecked(request, "futureRequest", "WAIT") ? "checked" : "" %>>
              <label class="form-check-label">様子を見たい</label>
            </div>

            <div class="form-check">
              <input class="form-check-input" type="checkbox" name="futureRequest" value="FACT_CHECK"
                     <%= oldChecked(request, "futureRequest", "FACT_CHECK") ? "checked" : "" %>>
              <label class="form-check-label">事実確認してほしい</label>
            </div>

            <div class="form-check">
              <input class="form-check-input" type="checkbox" name="futureRequest" value="WARN"
                     <%= oldChecked(request, "futureRequest", "WARN") ? "checked" : "" %>>
              <label class="form-check-label">行為者に注意してほしい</label>
            </div>

            <div class="form-check">
              <input class="form-check-input" type="checkbox" name="futureRequest" value="WORK_CHANGE"
                     <%= oldChecked(request, "futureRequest", "WORK_CHANGE") ? "checked" : "" %>>
              <label class="form-check-label">担当変更等、今後の業務について相談したい（配置転換など）</label>
            </div>

            <div class="form-check">
              <input class="form-check-input" type="checkbox" name="futureRequest" value="OTHER"
                     <%= oldChecked(request, "futureRequest", "OTHER") ? "checked" : "" %>>
              <label class="form-check-label">その他</label>
            </div>

            <input type="text" name="futureRequestOtherDetail" class="form-control mt-2"
                   placeholder="「その他」を選んだ場合、希望内容を記入"
                   value="<%= old(request, "futureRequestOtherDetail") %>">
          </div>
        </div>

        <!-- 6. 情報共有 -->
        <div class="card shadow-sm mb-4">
          <div class="card-header bg-dark text-white">情報の共有について</div>
          <div class="card-body">

            <div class="form-check">
              <input class="form-check-input" type="radio" name="sharePermission" value="ALL_OK"
                     <%= oldRadio(request, "sharePermission", "ALL_OK", "ALL_OK") ? "checked" : "" %>>
              <label class="form-check-label">必要と判断される関係者には共有してよい</label>
            </div>

            <div class="form-check">
              <input class="form-check-input" type="radio" name="sharePermission" value="LIMITED"
                     <%= oldRadio(request, "sharePermission", "LIMITED", "ALL_OK") ? "checked" : "" %>>
              <label class="form-check-label">共有する相手を限定してほしい</label>
            </div>

            <div class="ms-4 mb-3">
              <input type="text" name="shareLimitedTargets" class="form-control"
                     placeholder="例）人事担当者のみ／事業所長まで 等"
                     value="<%= old(request, "shareLimitedTargets") %>">
            </div>

            <div class="form-check">
              <input class="form-check-input" type="radio" name="sharePermission" value="NO_SHARE"
                     <%= oldRadio(request, "sharePermission", "NO_SHARE", "ALL_OK") ? "checked" : "" %>>
              <label class="form-check-label">相談窓口以外には共有しないでほしい</label>
            </div>
          </div>
        </div>

        <div class="d-flex justify-content-between mb-5">
          <a href="<%= request.getContextPath() %>/" class="btn btn-outline-secondary">トップへ戻る</a>
          <button type="submit" class="btn btn-primary">内容を確認する</button>
        </div>

      </form>
      <!-- ★ フォーム終了 -->

    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
