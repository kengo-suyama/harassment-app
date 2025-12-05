<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>ハラスメント相談フォーム</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container-fluid">
        <a href="/harassment-app/" class="navbar-brand text-decoration-none">
            ハラスメント相談フォーム
        </a>
    </div>
</nav>

<div class="container">
    <div class="row justify-content-center mb-4">
        <div class="col-lg-8">

            <div class="card shadow-sm">
                <div class="card-body">
                    <h1 class="h4 mb-3">相談内容の入力</h1>
                    <p class="text-muted small">
                        ※ 氏名など、個人が特定されない範囲での記入も可能です。<br>
                        ※ 入力された内容は、相談窓口の管理者・マスター権限者のみが閲覧します。
                    </p>

                    <!-- 後で action を /consult/submit に切り替える予定 -->
                    <form action="<%= request.getContextPath() %>/consult/submit" method="post">

                        <div class="mb-3">
                            <label class="form-label">シート記入日</label>
                            <input type="date" name="sheetDate" class="form-control">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">相談者氏名（任意）</label>
                            <input type="text" name="consultantName" class="form-control"
                                   placeholder="例）山田太郎">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">相談の概要</label>
                            <textarea name="summary" rows="6" class="form-control"
                                      placeholder="いつ・どこで・誰が・誰に・どのような行為があったかを、わかる範囲でご記入ください。"></textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">相談内容の共有について</label>
                            <select name="sharePermission" class="form-select">
                                <option value="ALL_OK">施設内で共有しても問題ない</option>
                                <option value="LIMITED">共有してよいが、対象を限定してほしい</option>
                                <option value="NO_SHARE">施設内では共有してほしくない</option>
                            </select>
                            <div class="form-text">
                                ※ マスター権限者は「共有可」「限定共有」の内容のみ外部機関に提供できます。
                            </div>
                        </div>

                        <div class="d-flex justify-content-between">
                            <a href="/harassment-app/" class="btn btn-outline-secondary">戻る</a>
                            <button type="submit" class="btn btn-primary">
                                相談内容を送信する
                            </button>
                        </div>
                    </form>

                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

