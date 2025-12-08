<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>ハラスメント相談システム</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap CSS (CDN) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container-fluid">
        <span class="navbar-brand">ハラスメント相談システム</span>
    </div>
</nav>

<div class="container">
    <div class="row justify-content-center mt-4">
        <div class="col-md-8 col-lg-6">

            <div class="card shadow-sm">
                <div class="card-body">
                    <h1 class="h4 mb-3">メニュー</h1>
                    <p class="text-muted small">
                        ハラスメントに関するご相談を受け付けるためのシステムです。<br>
                        相談内容は管理者・マスター権限者のみが閲覧できます。
                    </p>

                    <div class="d-grid gap-3 mt-4">
                        <a href="<%= request.getContextPath() %>/consult/consult_form.jsp" class="btn btn-primary">
                            相談を送信する（相談者用）
                        </a>
                        
                        

                        <a href="admin_login.jsp" class="btn btn-outline-secondary">
                            管理者ログイン
                        </a>

                        <a href="master_login.jsp" class="btn btn-outline-dark">
                            マスターログイン（外部機関連携担当）
                        </a>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
