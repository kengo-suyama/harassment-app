<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>

<%!
    String old(HttpServletRequest request, String name) {
        String v = request.getParameter(name);
        return v != null ? v : "";
    }
    boolean oldChecked(HttpServletRequest request, String name, String value) {
        String[] values = request.getParameterValues(name);
        if (values == null) return false;
        for (String v : values) {
            if (value.equalsIgnoreCase(v)) return true;
        }
        return false;
    }
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
        <span class="navbar-brand">ハラスメント相談システム</span>
    </div>
</nav>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-9">

            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <h1 class="h4 mb-3">ハラスメント相談シート</h1>
                    <p class="text-muted small mb-0">
                        可能な範囲でご記入ください。（※は必須項目）
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

            <!-- ★重要：form はここから最後まで包む -->
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

                <!-- 2. 概要 -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-secondary text-white">
                        相談内容の概要（※）
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label class="form-label">
                                どのようなことでお困りですか？（概要）<span class="text-danger">※</span>
                            </label>
                            <textarea name="summary" rows="5" class="form-control"
                                      placeholder="例）上司から繰り返し大声で叱責されている…"><%= old(request, "summary") %></textarea>
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
                                <input class="form-check-input" type="radio"
                                       name="reportedExists" value="YES"
                                       <%= oldRadio(request, "reportedExists", "YES", "") ? "checked" : "" %>>
                                <label class="form-check-label">はい</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio"
                                       name="reportedExists" value="NO"
                                       <%= oldRadio(request, "reportedExists", "NO", "") ? "checked" : "" %>>
                                <label class="form-check-label">いいえ</label>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">相談した相手</label>
                            <input type="text" name="reportedPerson" class="form-control"
                                   value="<%= old(request, "reportedPerson") %>">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">相談した日時</label>
                            <input type="text" name="reportedAt" class="form-control"
                                   value="<%= old(request, "reportedAt") %>">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">その後の対応や経過</label>
                            <textarea name="followUp" rows="4" class="form-control"><%= old(request, "followUp") %></textarea>
                        </div>

                    </div>
                </div>

                <!-- 4. 心身 -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-warning">現在の心身の状態</div>
                    <div class="card-body">

                        <div class="mb-3">
                            <label class="form-label">今のつらさ（1〜10）</label>
                            <input type="number" name="mentalScale" min="1" max="10"
                                   class="form-control"
                                   value="<%= old(request, "mentalScale").isEmpty() ? "5" : old(request, "mentalScale") %>">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">詳細</label>
                            <textarea name="mentalDetail" rows="4" class="form-control"><%= old(request, "mentalDetail") %></textarea>
                        </div>

                    </div>
                </div>

                <!-- 5. 今後の希望 -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-success text-white">今後の希望（複数選択可）</div>
                    <div class="card-body">

                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="futureRequest" value="LISTEN_ONLY"
                                   <%= oldChecked(request, "futureRequest", "LISTEN_ONLY") ? "checked" : "" %>>
                            <label class="form-check-label">とりあえず話を聞いてほしい</label>
                        </div>

                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="futureRequest" value="ADVISE"
                                   <%= oldChecked(request, "futureRequest", "ADVISE") ? "checked" : "" %>>
                            <label class="form-check-label">助言やアドバイスがほしい</label>
                        </div>

                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="futureRequest" value="ARRANGE_MEETING"
                                   <%= oldChecked(request, "futureRequest", "ARRANGE_MEETING") ? "checked" : "" %>>
                            <label class="form-check-label">面談の場を調整してほしい</label>
                        </div>

                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="futureRequest" value="KEEP_RECORD"
                                   <%= oldChecked(request, "futureRequest", "KEEP_RECORD") ? "checked" : "" %>>
                            <label class="form-check-label">記録として残しておいてほしい</label>
                        </div>

                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="futureRequest" value="WORK_CHANGE"
                                   <%= oldChecked(request, "futureRequest", "WORK_CHANGE") ? "checked" : "" %>>
                            <label class="form-check-label">配置転換・業務変更を検討してほしい</label>
                        </div>

                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="futureRequest" value="NOTHING"
                                   <%= oldChecked(request, "futureRequest", "NOTHING") ? "checked" : "" %>>
                            <label class="form-check-label">特に希望はない</label>
                        </div>

                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="futureRequest" value="OTHER"
                                   <%= oldChecked(request, "futureRequest", "OTHER") ? "checked" : "" %>>
                            <label class="form-check-label">その他</label>
                        </div>

                        <input type="text" name="futureRequestOtherDetail" class="form-control mt-2"
                               value="<%= old(request, "futureRequestOtherDetail") %>">

                    </div>
                </div>

                <!-- 6. 共有 -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-dark text-white">今後の情報共有について</div>
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
                                   value="<%= old(request, "shareLimitedTargets") %>">
                        </div>

                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="sharePermission" value="NO_SHARE"
                                   <%= oldRadio(request, "sharePermission", "NO_SHARE", "ALL_OK") ? "checked" : "" %>>
                            <label class="form-check-label">相談窓口以外には共有しないでほしい</label>
                        </div>

                    </div>
                </div>

                <!-- 送信 -->
                <div class="d-flex justify-content-between mb-5">
                    <a href="<%= request.getContextPath() %>/" class="btn btn-outline-secondary">トップへ戻る</a>
                    <button type="submit" class="btn btn-primary">内容確認へ進む</button>
                </div>

            </form>
            <!-- ★form終わり -->

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
