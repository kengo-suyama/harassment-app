harassment-app
ハラスメント相談システム（Web / PWA 対応想定）
概要
harassment-app（ハラスメント相談システム） は、
職場（企業・事業所・病院等）での ハラスメント相談を紙の相談シート運用に近い形で Web 化 したアプリケーションです。
相談者はフォームから相談内容を入力 → 確認 → 送信でき、
管理者・全権管理者（マスター）は相談内容の確認・管理・記録保存を行えます。
本システムは 現場運用を第一に設計 されており、
「紙運用の流れを壊さないこと」「誰でも使えるUI」「運用・監査対応」を重視しています。
主な特徴
紙の相談シート運用をそのまま Web 化
入力 → 確認 → 提出 の明確なフロー
セッションによる下書き保存（誤送信防止）
管理者／全権管理者（マスター）による段階的な権限管理
URL マッピングは web.xml に統一（アノテーション不使用）
Tomcat 単体で運用可能（軽量）
機能一覧
相談者側
ハラスメント相談シート入力（Bootstrap UI）
内容確認画面（Confirm）
送信（Submit）＋送信完了（Thanks）
下書き保存（Session）
Confirm 遷移時に下書き更新
送信成功時に下書き自動削除
下書き削除ボタン（/consult/draft/clear）
相談者ステータス確認（照合キー方式）
管理者（Admin）
管理者ログイン
相談一覧表示
相談詳細表示
確認チェック
管理者対応内容の記録
※ 管理者は 相談者の最終評価（5段階評価・自由記述）を閲覧できません
全権管理者（マスター / Master）
全権管理者は 監査・統括責任者 を想定しています。
マスターログイン機能
すべての相談シート閲覧
管理者の対応内容・履歴の閲覧
相談者の最終評価（5段階評価 + テキスト）の閲覧
全相談データの PDF / CSV 出力
改ざん防止を前提とした帳票出力
月別・年次件数の確認（運用想定）
監査・報告・保存用途を想定
画面 / エンドポイント（ローカル開発例）
種別
URL
トップ
http://localhost:8080/harassment-app/
相談フォーム
/consult/form
内容確認
/consult/confirm
送信
/consult/submit
相談者ステータス
/consult/status/{accessKey}
管理者ログイン
/admin/login
管理者一覧
/admin/consult/list
管理者詳細
/admin/consult/detail?id=...
マスターログイン
/master/login
※ マスターログインは 全権管理者専用 です
※ 実運用では IP 制限・VPN・二要素認証等の併用を強く推奨します
技術構成
Java Servlet / JSP
Apache Tomcat 9.x
Bootstrap 5
MySQL（永続化対応）
文字コード：UTF-8
URL 管理：web.xml に統一（@WebServlet 不使用）
データ設計（概要）
Consultation（相談）
基本情報：sheetDate / consultantName
相談概要：summary（必須）
発生後の状況：
reportedExists
reportedPerson
reportedAt
followUp
心身状態：
mentalScale
mentalDetail
今後の希望：
futureRequest（複数）
futureRequestOtherDetail
情報共有設定：
sharePermission
shareLimitedTargets
管理情報：
adminChecked
status
相談者照合キー：
accessKey
セキュリティ・運用方針
初期ID / パスワードは 環境変数または外部設定ファイルで管理
GitHub に 認証情報は含めない
HTTPS 前提での外部公開を推奨
センシティブ情報のためアクセス制御・ログ管理を必須とする
今後の拡張予定
検索・絞り込み（期間・ステータス・部署等）
相談者向けステータス通知
照合キーの再発行機能
PWA 化 / Android（TWA）化
運用レポート自動生成
法人・病院向け B2B 展開
ライセンス

This software is licensed under AGPL-3.0.
Commercial use requires attribution and compliance with license terms.
Kengo Suyama.

This project is developed and maintained by Kengo Suyama.
Designed for real-world harassment consultation operations.
注意事項
本システムは 相談業務の補助ツール であり、
法的判断・医療判断を代替するものではありません。
実運用時は、各事業所の規定・法令に従ってご利用ください。