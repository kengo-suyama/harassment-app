<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>トップ - ハラスメント相談システム</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    :root {
      --ink: #1f2a37;
      --calm: #e9f2ef;
      --calm-2: #f7f6f1;
      --accent: #2c7a7b;
      --accent-2: #1f5f5f;
      --soft: #eef4ff;
    }
    body {
      font-family: "Hiragino Mincho ProN", "Yu Mincho", "Noto Serif JP", serif;
      color: var(--ink);
      background:
        radial-gradient(1200px 500px at 10% -10%, #eef6f3 0%, rgba(238,246,243,0) 60%),
        radial-gradient(900px 400px at 90% 0%, #f6f3ee 0%, rgba(246,243,238,0) 60%),
        linear-gradient(180deg, #f7faf9 0%, #f3f5f2 100%);
      min-height: 100vh;
    }
    .topbar {
      background: rgba(255,255,255,0.7);
      backdrop-filter: blur(4px);
      border-bottom: 1px solid #e5e7eb;
    }
    .hero-card {
      background: rgba(255,255,255,0.95);
      border: 1px solid #e5e7eb;
      box-shadow: 0 20px 50px rgba(17, 24, 39, 0.08);
      border-radius: 18px;
    }
    .cta-primary {
      background: var(--accent);
      border-color: var(--accent);
    }
    .cta-primary:hover { background: var(--accent-2); }
    .cta-outline {
      border-color: var(--accent);
      color: var(--accent);
    }
    .step-card {
      background: var(--calm);
      border-radius: 14px;
      border: 1px solid #d9e6e2;
    }
    .help-card {
      background: var(--soft);
      border-radius: 14px;
      border: 1px solid #dbe5ff;
    }
    .mini-link {
      font-size: 0.85rem;
      padding: 0.25rem 0.5rem;
    }
  </style>
</head>
<body>

<nav class="topbar py-2">
  <div class="container-fluid d-flex align-items-center justify-content-between">
    <div class="fw-bold">ハラスメント相談システム</div>
    <div class="d-flex gap-2">
      <a class="btn btn-outline-secondary mini-link" href="<%= request.getContextPath() %>/admin/login">管理者</a>
      <a class="btn btn-outline-secondary mini-link" href="<%= request.getContextPath() %>/master/login">全権管理者</a>
    </div>
  </div>
</nav>

<main class="container py-5">
  <div class="row justify-content-center">
    <div class="col-lg-9">

      <div class="hero-card p-4 p-md-5 mb-4">
        <h1 class="h3 mb-3">安心してご相談ください</h1>
        <p class="mb-4">
          相談内容は慎重に取り扱います。誰かに知られることが不安な場合でも、
          まずは今の状況を整理するために記入していただけます。
        </p>

        <div class="d-flex flex-wrap gap-3 mb-3">
          <a class="btn btn-primary cta-primary px-4" id="cta-start" href="<%= request.getContextPath() %>/consult/form">相談をはじめる</a>
          <a class="btn btn-outline-primary cta-outline px-4" id="cta-status" href="<%= request.getContextPath() %>/consult/status">対応状況の確認</a>
        </div>

        <div class="help-card p-3" id="cta-help">
          <div class="small text-muted mb-1">迷ったら</div>
          <div class="fw-semibold">「相談をはじめる」から状況を整理できます。</div>
        </div>
      </div>

      <div class="row g-3">
        <div class="col-md-4">
          <div class="step-card p-3 h-100">
            <div class="small text-muted">STEP 1</div>
            <div class="fw-semibold">相談内容の入力</div>
            <div class="small mt-2">カテゴリ選択＋詳細記入で状況を整理します。</div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="step-card p-3 h-100">
            <div class="small text-muted">STEP 2</div>
            <div class="fw-semibold">照合キーの控え</div>
            <div class="small mt-2">送信後に表示される照合キーは必ず控えてください。</div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="step-card p-3 h-100">
            <div class="small text-muted">STEP 3</div>
            <div class="fw-semibold">進捗の確認</div>
            <div class="small mt-2">照合キーで対応状況とチャットを確認できます。</div>
          </div>
        </div>
      </div>

    </div>
  </div>
</main>

<script>
  (function () {
    const help = document.getElementById("cta-help");
    const start = document.getElementById("cta-start");
    const status = document.getElementById("cta-status");
    if (!help || !start || !status) return;

    function setHelp(title, body) {
      help.innerHTML = '<div class="small text-muted mb-1">' + title + '</div><div class="fw-semibold">' + body + '</div>';
    }

    start.addEventListener("mouseenter", function () {
      setHelp("相談をはじめる", "入力を進めながら状況を整理できます。");
    });
    status.addEventListener("mouseenter", function () {
      setHelp("対応状況の確認", "照合キーをお持ちの方はこちらから確認できます。");
    });
    help.addEventListener("mouseleave", function () {
      setHelp("迷ったら", "「相談をはじめる」から状況を整理できます。");
    });
  })();
</script>
</body>
</html>
