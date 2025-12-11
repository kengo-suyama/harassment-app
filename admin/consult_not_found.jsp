<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>相談データが見つかりません</title>
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
    </div>
</nav>

<div class="container mb-5">

    <div class="alert alert-danger">
        該当する相談データが見つかりませんでした。<br>
        ・URLを直接入力した場合は、IDの指定が誤っている可能性があります。<br>
        ・一覧画面から再度「詳細」ボタンを押して開き直してください。
    </div>

    <div class="d-flex gap-2">
        <a href="<%= request.getContextPath() %>/admin/consult/list"
           class="btn btn-outline-secondary">
            一覧に戻る
        </a>
        <a href="<%= request.getContextPath() %>/"
           class="btn btn-link">
            トップへ戻る
        </a>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

