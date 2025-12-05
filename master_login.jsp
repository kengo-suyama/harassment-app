<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>マスターログイン</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container-fluid">
        <a href="index.jsp" class="navbar-brand text-decoration-none">
            マスターログイン（外部機関連携）
        </a>
    </div>
</nav>

<div class="container">
    <div class="row justify-content-center mt-4">
        <div class="col-md-4">

            <div class="card shadow-sm">
                <div class="card-body">
                    <h1 class="h5 mb-3">マスターログイン</h1>

                    <% String error = (String) request.getAttribute("error");
                       if (error != null) { %>
                        <div class="alert alert-danger"><%= error %></div>
                    <% } %>

                    <!-- 後で action="/master/login" に変更予定 -->
                    <form action="master_list.jsp" method="post">
                        <div class="mb-3">
                            <label class="form-label">パスワード</label>
                            <input type="password" name="password" class="form-control">
                        </div>
                        <button type="submit" class="btn btn-dark w-100">
                            ログイン
                        </button>
                    </form>

                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

