<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>相談送信完了</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container-fluid">
        <a href="index.jsp" class="navbar-brand text-decoration-none">
            ハラスメント相談フォーム
        </a>
    </div>
</nav>

<div class="container">
    <div class="row justify-content-center mt-3">
        <div class="col-lg-8">
            <div class="alert alert-success shadow-sm">
                <h1 class="h4">ご相談ありがとうございました</h1>
                <p class="mb-1">
                    入力していただいた内容を受け付けました。
                </p>
                <p class="mb-0 small text-muted">
                    ※ 内容は相談窓口の担当者が確認し、必要に応じてマスター権限者・外部機関と連携します。<br>
                    ※ 緊急性が高いと感じられる場合は、上司・人事部門・専門機関などへの連絡も併せてご検討ください。
                </p>
            </div>

            <div class="d-flex gap-2">
                <a href="consult_form.jsp" class="btn btn-outline-primary">
                    もう一件相談を入力する
                </a>
                <a href="index.jsp" class="btn btn-outline-secondary">
                    メニューへ戻る
                </a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

