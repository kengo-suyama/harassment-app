harassment-app（ハラスメント相談システム）
概要

職場（事業所・病院等）でのハラスメント相談を、紙の相談シート運用に近い形でWeb化したアプリです。
相談者はフォームから相談内容を入力→確認→送信でき、管理者は一覧・詳細・確認チェック等で相談を管理できます。
サーブレットのURL管理は アノテーション（@WebServlet）を使わず、web.xml に統一しています（Tomcat上での運用前提）。

主な機能
相談者側

相談シート入力（Bootstrap UI）

入力内容の確認画面（Confirm）

送信（Submit）＋送信完了（Thanks）

入力下書き保存（Session）

Confirmへ進むタイミングで下書き更新

送信成功時は下書きを必ず削除

下書き削除ボタン（/consult/draft/clear）

管理者側

管理者ログイン（/admin/login）

相談一覧（/admin/consult/list）

相談詳細（/admin/consult/detail?id=...）

確認チェック（/admin/consult/check）

画面 / エンドポイント（ローカル開発）

トップ

http://localhost:8080/harassment-app/

相談フォーム

http://localhost:8080/harassment-app/consult/form

内容確認

http://localhost:8080/harassment-app/consult/confirm

送信

http://localhost:8080/harassment-app/consult/submit

相談者ステータス（照合キー方式）

http://localhost:8080/harassment-app/consult/status

http://localhost:8080/harassment-app/consult/status/{accessKey}（相談者ごとに異なる）

管理者ログイン

http://localhost:8080/harassment-app/admin/login

技術構成

Java Servlet / JSP（Tomcat 9系）

UI：Bootstrap 5

ルーティング：web.xmlで一元管理（アノテーション不使用）

データ保持：当初は MemoryConsultationRepository（メモリ）で実装

相談データの登録・一覧・詳細取得

管理者確認チェック（adminChecked）

status更新やチャット・評価等の拡張を想定

文字コード：UTF-8（フォーム送信はServlet側で request.setCharacterEncoding("UTF-8")）

データ設計（概要）

Consultation（相談）

基本情報：sheetDate / consultantName

相談概要：summary（必須）

発生後の状況：reportedExists / reportedPerson / reportedAt / followUp

心身状態：mentalScale / mentalDetail

今後の希望：futureRequest（複数選択）/ futureRequestOtherDetail

共有設定：sharePermission / shareLimitedTargets

管理項目：adminChecked / status

相談者照合キー：accessKey（相談者向けステータス確認用）

こだわり / 工夫した点

**紙運用の流れ（記入→確認→提出）**を崩さずにWeb化し、現場での運用イメージを持ちやすいUIにしました。

相談フォームの入力補助（date/datetime-local、ラジオ・チェックボックス）で、入力負担を軽減しました。

Confirm画面は「表示専用」にして、二重投稿や入力UIの混在を避けました。

web.xml統一により、URLの衝突（アノテーションとweb.xmlの二重定義）を防ぎ、運用時の保守性を優先しています。

今後の実装予定（拡張案）

MySQL永続化（メモリ→DB）＋バックアップ

役割ベース権限（管理者/マスター/担当者）と操作ログ（監査ログ）

検索・絞り込み（期間、部署、ステータス等）

CSV/PDF出力（施設内の記録・監査対応）

相談者向け：ステータス更新通知、照合キーの安全な再発行

PWA化 / Android（TWA）化による現場端末配布の簡易化

運用想定

事業所・病院など、複数端末からの入力（スマホ/PC）を想定

相談内容はセンシティブ情報のため、外部公開時はHTTPS、アクセス制御、ログ管理を前提とする
