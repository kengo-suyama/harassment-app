<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>

<%!
    @SuppressWarnings("unchecked")
    Map<String, String[]> draft(HttpServletRequest request) {
        Object o = request.getAttribute("draft");
        if (o != null) return (Map<String, String[]>) o;

        javax.servlet.http.HttpSession s = request.getSession(false);
        if (s == null) return null;
        Object d = s.getAttribute("CONSULT_DRAFT");
        return (d != null) ? (Map<String, String[]>) d : null;
    }

    String old(HttpServletRequest request, String name) {
        String v = request.getParameter(name);
        if (v != null) return v;

        Map<String, String[]> d = draft(request);
        if (d == null) return "";
        String[] arr = d.get(name);
        if (arr == null || arr.length == 0) return "";
        return arr[0] == null ? "" : arr[0];
    }

    boolean oldChecked(HttpServletRequest request, String name, String value) {
        String[] values = request.getParameterValues(name);
        if (values == null) {
            Map<String, String[]> d = draft(request);
            if (d != null) values = d.get(name);
        }
        if (values == null) return false;
        for (String v : values) {
            if (value.equalsIgnoreCase(v)) return true;
        }
        return false;
    }

    boolean oldRadio(HttpServletRequest request, String name, String value, String defaultValue) {
        String v = request.getParameter(name);

        if (v == null || v.isEmpty()) {
            Map<String, String[]> d = draft(request);
            if (d != null) {
                String[] arr = d.get(name);
                if (arr != null && arr.length > 0 && arr[0] != null && !arr[0].isEmpty()) {
                    v = arr[0];
                }
            }
        }
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
                        相談内容を記録するためのシートです。可能な範囲でご記入ください（※は必須）。
                    </p>
                </div>
            </div>

            <%
                String infoMessage = (String) request.getAttribute("infoMessage");
                if (infoMessage != null && !infoMessage.isEmpty()) {
            %>
                <div class="alert alert-info"><%= infoMessage %></div>
            <%
                }
            %>

            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null && !errorMessage.isEmpty()) {
            %>
                <div class="alert alert-danger"><%= errorMessage %></div>
            <%
                }
            %>

            <!-- 下書き削除（別フォーム） -->
            <div class="d-flex justify-content-end mb-3">
                <form method="post"
                      action="<%= request.getContextPath() %>/consult/draft/clear"
                      onsubmit="return confirm('下書きを削除します。入力内容は消えますがよろしいですか？');">
                    <button type="submit" class="btn btn-outline-danger btn-sm">
                        下書きを削除
                    </button>
                </form>
            </div>

            <form method="post" action="<%= request.getContextPath() %>/consult/confirm">

                <!-- 1. 基本情報 -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-primary text-white">基本情報</div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label class="form-label">シート記録日</label>
                            <input type="date" name="sheetDate" class="form-control"
                                   value="<%= old(request, "sheetDate") %>">
                            <div class="form-text">未記入の場合は入力日を自動記録します。</div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">相談者氏名（任意）</label>
                            <input type="text" name="consultantName" class="form-control"
                                   placeholder="例）山田 太郎"
                                   value="<%= old(request, "consultantName") %>">
                            <div class="form-text">匿名での相談も可能です。</div>
                        </div>
                    </div>
                </div>

                <!-- 2. 相談内容の概要 -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-secondary text-white">相談内容の概要（※必須）</div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label class="form-label">
                                どのようなことでお困りですか（概要）
                                <span class="text-danger">※</span>
                            </label>
                            <div class="row g-2">
                                <div class="col-md-6">
                                    <select class="form-select" name="summaryMajor" id="summaryMajor" data-initial="<%= old(request, "summaryMajor") %>" required>
                                        <option value="">大分類を選択</option>
                                        <option value="ハラスメント" <%= "ハラスメント".equals(old(request, "summaryMajor")) ? "selected" : "" %>>ハラスメント</option>
                                        <option value="人間関係・いじめ" <%= "人間関係・いじめ".equals(old(request, "summaryMajor")) ? "selected" : "" %>>人間関係・いじめ</option>
                                        <option value="労務（勤務/残業/休暇）" <%= "労務（勤務/残業/休暇）".equals(old(request, "summaryMajor")) ? "selected" : "" %>>労務（勤務/残業/休暇）</option>
                                        <option value="評価・処遇" <%= "評価・処遇".equals(old(request, "summaryMajor")) ? "selected" : "" %>>評価・処遇</option>
                                        <option value="不正・コンプラ" <%= "不正・コンプラ".equals(old(request, "summaryMajor")) ? "selected" : "" %>>不正・コンプラ</option>
                                        <option value="情報・SNS" <%= "情報・SNS".equals(old(request, "summaryMajor")) ? "selected" : "" %>>情報・SNS</option>
                                        <option value="安全・環境" <%= "安全・環境".equals(old(request, "summaryMajor")) ? "selected" : "" %>>安全・環境</option>
                                        <option value="顧客/利用者対応（カスハラ等）" <%= "顧客/利用者対応（カスハラ等）".equals(old(request, "summaryMajor")) ? "selected" : "" %>>顧客/利用者対応（カスハラ等）</option>
                                        <option value="メンタル/健康" <%= "メンタル/健康".equals(old(request, "summaryMajor")) ? "selected" : "" %>>メンタル/健康</option>
                                        <option value="その他" <%= "その他".equals(old(request, "summaryMajor")) ? "selected" : "" %>>その他</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <select class="form-select" name="summarySub" id="summarySub" data-initial="<%= old(request, "summarySub") %>" required>
                                        <option value="">カテゴリを選択</option>
                                    </select>
                                </div>
                            </div>
                            <textarea name="summaryDetail" rows="5" class="form-control mt-2"
                                      placeholder="例）どこで、だれが、何を、どうしたのか。状況が分かるように記入してください。"><%= old(request, "summaryDetail") %></textarea>
                            <div class="form-text">選んだ大分類/カテゴリは管理者・全権管理者画面やレポートに反映されます。</div>
                        </div>
                    </div>
                </div>

                <!-- 3. 発生後の状況 -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-info text-white">発生後の状況</div>
                    <div class="card-body">

                        <div class="mb-3">
                            <label class="form-label">すでに誰かに相談しましたか</label>
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
                                   placeholder="例）職場の同僚、人事担当者など"
                                   value="<%= old(request, "reportedPerson") %>">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">相談した日時</label>
                            <input type="datetime-local" name="reportedAt" class="form-control"
                                   value="<%= old(request, "reportedAt") %>">
                            <div class="form-text">日時をカレンダーから選択できます。</div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">その後の対応や経過</label>
                            <textarea name="followUp" rows="4" class="form-control"
                                      placeholder="例）部署異動の提案があったがまだ決まっていない"><%= old(request, "followUp") %></textarea>
                        </div>
                    </div>
                </div>

                <!-- 4. 心身の状態 -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-warning">現在の心身の状態</div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label class="form-label">今のつらさ（1-10）</label>
                            <input type="number" name="mentalScale" min="1" max="10" class="form-control"
                                   value="<%= old(request, "mentalScale").isEmpty() ? "5" : old(request, "mentalScale") %>">
                            <div class="form-text">10に近いほど深刻な心身状態です。</div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">詳細</label>
                            <textarea name="mentalDetail" rows="4" class="form-control"
                                      placeholder="例）眠れない、食欲がない"><%= old(request, "mentalDetail") %></textarea>
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
                            <label class="form-check-label">助言・アドバイスがほしい</label>
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
                               placeholder="「その他」を選んだ場合は内容を記入"
                               value="<%= old(request, "futureRequestOtherDetail") %>">
                    </div>
                </div>

                <!-- 6. 情報共有 -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-dark text-white">今後の情報共有について</div>
                    <div class="card-body">
                        <p class="small text-muted">相談内容を、誰まで共有してよいかをお選びください。</p>

                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="sharePermission" value="ALL_OK"
                                   <%= oldRadio(request, "sharePermission", "ALL_OK", "ALL_OK") ? "checked" : "" %>>
                            <label class="form-check-label">必要に応じて関係者へ共有してよい</label>
                        </div>

                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="sharePermission" value="LIMITED"
                                   <%= oldRadio(request, "sharePermission", "LIMITED", "ALL_OK") ? "checked" : "" %>>
                            <label class="form-check-label">共有する相手を限定してほしい</label>
                        </div>

                        <div class="ms-4 mb-3">
                            <input type="text"
                                   name="shareLimitedTargets"
                                   class="form-control"
                                   placeholder="例）人事担当者のみ、事業所長まで など"
                                   value="<%= old(request,"shareLimitedTargets") %>">
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
                    <button type="submit" class="btn btn-primary">入力確認へ進む</button>
                </div>

            </form>

        </div>
    </div>
</div>

<script>
  (function () {
    const data = {
      "ハラスメント": [
        "セクシュアルハラスメント（セクハラ）",
        "パワーハラスメント（パワハラ）",
        "モラルハラスメント（モラハラ）",
        "マタニティハラスメント（マタハラ）",
        "パタニティハラスメント（パタハラ）",
        "ケアハラスメント（介護・看護・通院等への配慮不足）",
        "エイジハラスメント（年齢）",
        "ルッキズム（容姿）",
        "ジェンダーハラスメント（性別役割の押し付け等）",
        "SOGIハラスメント（性的指向・性自認）",
        "カスタマーハラスメント（カスハラ：顧客・利用者から）",
        "アルコールハラスメント（飲酒強要等）",
        "スモークハラスメント（受動喫煙・喫煙強要）",
        "テクノロジーハラスメント（IT/スキル差を嘲る、デジタル強要）",
        "リモートハラスメント（オンラインでの圧・監視・嫌がらせ）"
      ],
      "人間関係・いじめ": [
        "いじめ／嫌がらせ",
        "無視／仲間外れ",
        "陰口／悪評の流布",
        "侮辱・暴言・人格否定",
        "からかい／嘲笑",
        "嫌なあだ名・呼び方",
        "連絡を回さない／情報遮断",
        "業務から外す／干す",
        "過剰な監視・詮索",
        "私生活への過干渉",
        "チーム内の派閥・対立"
      ],
      "労務（勤務/残業/休暇）": [
        "業務量が過多（キャパ超え）",
        "不公平な業務配分",
        "無理な納期・残業強要",
        "休日出勤の強要",
        "休憩が取れない",
        "有給が取れない／取らせない",
        "早出・サービス残業の強要",
        "シフトが不公平（希望が通らない等）",
        "突然のシフト変更",
        "業務範囲外の仕事の強要",
        "危険作業の強要／安全配慮不足",
        "体調不良でも休ませない"
      ],
      "評価・処遇": [
        "不当な評価・査定",
        "昇給・昇格に不満／不透明",
        "降格・配置転換が納得できない",
        "賃金未払い／残業代未払い",
        "手当・交通費の不支給",
        "契約更新されない／雇止め不安",
        "退職強要（辞めろと言われる等）",
        "懲戒・処分が不当だと感じる",
        "正社員/非正規で扱いが不公平"
      ],
      "不正・コンプラ": [
        "横領・金銭不正",
        "会社備品の私物化",
        "経費不正",
        "改ざん・虚偽報告",
        "取引先との癒着",
        "利益相反",
        "法令違反（労基/安全/個人情報等）",
        "ハラスメントの隠蔽",
        "反社・不適切取引の疑い"
      ],
      "情報・SNS": [
        "個人情報の漏えい／誤送信",
        "機密情報の持ち出し",
        "社内チャットでの誹謗中傷",
        "SNSでの晒し・悪口",
        "勝手な写真撮影・共有",
        "監視・盗み見（画面/メール/スマホ）",
        "パスワードの共有強要"
      ],
      "安全・環境": [
        "職場の衛生が悪い",
        "温度/騒音/臭い等の環境問題",
        "休憩室が使えない",
        "設備不良・故障放置",
        "安全対策不足（転倒・感染・防災）",
        "防護具・備品が足りない",
        "事故・ヒヤリハットが多い"
      ],
      "顧客/利用者対応（カスハラ等）": [
        "利用者・患者からの暴言/暴力",
        "家族からのクレーム・過剰要求",
        "セクハラ行為（利用者/患者）",
        "不当な返金要求・土下座要求等",
        "ルール無視（面会/撮影/持込）",
        "脅迫・口コミで脅す"
      ],
      "メンタル/健康": [
        "ストレス・不眠・体調悪化",
        "メンタル不調（うつ不安等）",
        "パニック・出社困難",
        "職場復帰の不安",
        "産業医/面談希望",
        "休職/復職の相談"
      ],
      "その他": [
        "どれにも当てはまらない（その他）",
        "まず話を聞いてほしい（相談のみ）",
        "匿名で相談したい（匿名希望）",
        "緊急（今すぐ対応希望）"
      ]
    };

    const majorEl = document.getElementById("summaryMajor");
    const subEl = document.getElementById("summarySub");
    if (!majorEl || !subEl) return;

    function renderSubs(major, selected) {
      const options = data[major] || [];
      subEl.innerHTML = '<option value="">カテゴリを選択</option>';
      options.forEach(function (label) {
        const opt = document.createElement("option");
        opt.value = label;
        opt.textContent = label;
        if (selected && selected === label) opt.selected = true;
        subEl.appendChild(opt);
      });
    }

    const initialMajor = majorEl.getAttribute("data-initial") || "";
    const initialSub = subEl.getAttribute("data-initial") || "";
    if (initialMajor) {
      majorEl.value = initialMajor;
      renderSubs(initialMajor, initialSub);
    }

    majorEl.addEventListener("change", function () {
      renderSubs(majorEl.value, "");
    });
  })();
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
