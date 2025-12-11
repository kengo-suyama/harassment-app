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

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-4">
            <div class="card shadow-sm">
                <div class="card-body">

                    <h1 class="h5 mb-3">マスターログイン</h1>

                    <% 
                        String error = (String) request.getAttribute("loginError"); 
                    %>
                    <% if (error != null) { %>
                        <div class="alert alert-danger"><%= error %></div>
                    <% } %>

                    <form action="<%= request.getContextPath() %>/master/login" method="post">
                        <div class="mb-3">
                            <label class="form-label">ユーザー名</label>
                            <input type="text" name="username" class="form-control" value="master">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">パスワード</label>
                            <input type="password" name="password" class="form-control" value="master1234">
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary">
                                ログイン
                            </button>
                        </div>
                    </form>

                    <div class="mt-3">
                        <a href="<%= request.getContextPath() %>/" class="small">トップに戻る</a>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
