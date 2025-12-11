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
        <!-- ★ contextPath を使っておくと安全 -->
        <a href="<%= request.getContextPath() %>/" class="navbar-brand text-decoration-none">
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

                    <!-- ★★★ フォームはここからここまで！ ★★★ -->
                    <form action="<%= request.getContextPath() %>/consult/submit" method="post">

                        <!-- ==================================
                             基本情報
                        =================================== -->
                        <div class="mb-3">
                            <label class="form-label">シート記入日</label>
                            <input type="date" name="sheetDate" class="form-control">
                        </div>
                    
                        <div class="mb-3">
                            <label class="form-label">相談者氏名（任意）</label>
                            <input type="text" name="consultantName" class="form-control">
                        </div>
                    
                        <div class="mb-3">
                            <label class="form-label">相談の概要</label>
                            <textarea name="summary" rows="6" class="form-control"></textarea>
                        </div>


                        <!-- ==================================
                             発生後の状況
                        =================================== -->
                        <h4 class="mt-4">発生後の状況</h4>
                        <div class="card mb-3">
                            <div class="card-body">

                                <!-- 相談者が誰かに相談したか -->
                                <div class="mb-3">
                                    <label class="form-label d-block">本件を他に相談・報告した人の有無</label>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="reportedExists"
                                               id="reportedExistsYes" value="YES">
                                        <label class="form-check-label" for="reportedExistsYes">いる</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="reportedExists"
                                               id="reportedExistsNo" value="NO">
                                        <label class="form-check-label" for="reportedExistsNo">いない</label>
                                    </div>
                                </div>

                                <div class="row g-3 mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label" for="reportedPerson">相談相手</label>
                                        <input type="text" class="form-control" id="reportedPerson"
                                               name="reportedPerson" placeholder="例：上司、同僚、家族など">
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label" for="reportedAt">相談日時</label>
                                        <input type="datetime-local" class="form-control"
                                               id="reportedAt" name="reportedAt">
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label" for="followUp">その後の対応</label>
                                    <textarea class="form-control" id="followUp" name="followUp" rows="3"
                                              placeholder="相談後にどのような対応があったか、わかる範囲でご記入ください。"></textarea>
                                </div>

                            </div>
                        </div>


                        <!-- ==================================
                             心身の状態
                        =================================== -->
                        <h4 class="mt-4">あなたの心身の状態</h4>
                        <div class="card mb-3">
                            <div class="card-body">

                                <div class="mb-3">
                                    <label class="form-label d-block">
                                        あなたの今の気持ちについて最も近い段階に〇を付けてください。
                                    </label>
                                    <input type="range" class="form-range" id="mentalScale"
                                           name="mentalScale" min="1" max="10" value="5">

                                    <div class="d-flex justify-content-between small text-muted">
                                        <span>1 そこまでつらくない</span>
                                        <span>10 とてもつらい（仕事に行くのもつらい）</span>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label" for="mentalDetail">
                                        心身の状態・心配なこと・不安など
                                    </label>
                                    <textarea class="form-control" id="mentalDetail"
                                              name="mentalDetail" rows="4"
                                              placeholder="例：不眠、気分が落ち込む、職場が怖い など"></textarea>
                                </div>

                            </div>
                        </div>


                        <!-- ==================================
                             今後の希望
                        =================================== -->
                        <h4 class="mt-4">今後の対応に関する希望</h4>
                        <div class="card mb-3">
                            <div class="card-body">

                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" name="futureRequest"
                                           value="TALK_ONLY" id="reqTalkOnly">
                                    <label class="form-check-label" for="reqTalkOnly">
                                        相談したかっただけ
                                    </label>
                                </div>

                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" name="futureRequest"
                                           value="WATCH" id="reqWatch">
                                    <label class="form-check-label" for="reqWatch">
                                        様子を見たい
                                    </label>
                                </div>

                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" name="futureRequest"
                                           value="FACT_CHECK" id="reqFact">
                                    <label class="form-check-label" for="reqFact">
                                        事実確認してほしい
                                    </label>
                                </div>

                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" name="futureRequest"
                                           value="WARN_ACTOR" id="reqWarn">
                                    <label class="form-check-label" for="reqWarn">
                                        行為者に注意してほしい
                                    </label>
                                </div>

                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" name="futureRequest"
                                           value="WORK_CHANGE" id="reqWorkChange">
                                    <label class="form-check-label" for="reqWorkChange">
                                        担当変更など業務について相談したい
                                    </label>
                                </div>

                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" name="futureRequest"
                                           value="OTHER" id="reqOther">
                                    <label class="form-check-label" for="reqOther">その他</label>
                                </div>

                                <input type="text" class="form-control"
                                       id="futureRequestOtherDetail"
                                       name="futureRequestOtherDetail"
                                       placeholder="その他の希望があればご記入ください。">

                            </div>
                        </div>


                        <!-- ==================================
                             相談内容の共有の可否
                        =================================== -->
                        <h4 class="mt-4">相談内容の共有の可否</h4>
                        <div class="card mb-3">
                            <div class="card-body">

                                <p class="mb-2">
                                    今後の対応検討にあたり、相談内容を事業所内で共有してよいですか？
                                </p>

                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="radio"
                                           name="sharePermission" id="shareOk" value="ALL_OK">
                                    <label class="form-check-label" for="shareOk">
                                        共有しても問題ない
                                    </label>
                                </div>

                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="radio"
                                           name="sharePermission" id="shareLimited" value="LIMITED">
                                    <label class="form-check-label" for="shareLimited">
                                        共有してよいが、対象を限定してほしい
                                    </label>
                                </div>

                                <div class="mb-3 ms-4">
                                    <label class="form-label small" for="shareLimitedTargets">
                                        共有してよい対象（役職・部署など）
                                    </label>
                                    <input type="text" class="form-control"
                                           id="shareLimitedTargets" name="shareLimitedTargets"
                                           placeholder="例：施設長、人事担当">
                                </div>

                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="radio"
                                           name="sharePermission" id="shareNo" value="NO_SHARE">
                                    <label class="form-check-label" for="shareNo">
                                        共有しないでほしい
                                    </label>
                                </div>

                            </div>
                        </div>

                        <!-- ==================================
                             送信ボタン
                        =================================== -->
                        <div class="d-flex justify-content-between">
                            <a href="/harassment-app/" class="btn btn-outline-secondary">戻る</a>
                            <button type="submit" class="btn btn-primary">
                                相談内容を送信する
                            </button>
                        </div>
                    

                    </form>
                    <!-- ★★★ フォーム終わり ★★★ -->

                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
