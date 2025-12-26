harassment-app（ハラスメント相談システム）
概要
職場（各企業・事業所・病院等）でのハラスメント相談を、紙の相談シート運用に近い形でWeb化したアプリケーションです。
相談者はフォームから相談内容を入力 → 確認 → 送信でき、管理者および全権管理者（マスター）は、相談内容の管理・確認・対応・監査対応を行えます。
サーブレットのURL管理は アノテーション（@WebServlet）を使用せず、web.xml に統一しています。
Tomcat上での長期運用・引継ぎ・保守性を重視した設計です。
主な機能
相談者側
相談シート入力（Bootstrap UI）
入力内容の確認画面（Confirm）
送信（Submit）＋送信完了画面（Thanks）
入力下書き保存（Session）
Confirmへ進むタイミングで下書きを常に最新化
送信成功時は下書きを必ず削除
下書き削除ボタン
/consult/draft/clear
相談者ステータス確認（照合キー方式）
/consult/status
/consult/status/{accessKey}
管理者側（ADMIN）
管理者ログイン
/admin/login
相談一覧表示
/admin/consult/list
相談詳細表示
/admin/consult/detail?id=...
相談の確認チェック
/admin/consult/check
相談ステータス更新（NEW / IN_PROGRESS / DONE 等）
管理者対応内容の記録（下書き・確定）
※ 管理者は 相談者の最終評価（5段階評価・自由記述）を閲覧できません
全権管理者（マスター / MASTER）
全権管理者は、監査・統括・最終責任者向けの権限を持ちます。
閲覧・管理権限
すべての相談シートの閲覧
管理者の対応履歴・評価・操作内容の閲覧
相談者の最終評価
五段階評価
自由記述コメント
評価日時
出力・監査対応
各相談シートについて、以下を含む 完全レポートの出力
相談者入力内容
管理者対応履歴
ステータス遷移
管理者確認情報
相談者最終評価
PDF / CSV 形式での出力・印刷
出力物は改ざん防止・改ざん検出を前提とした設計
出力時にハッシュ値（SHA-256）を生成
出力履歴をログとして保存
PDFは編集不能形式で出力（電子署名拡張を想定）
運用上の位置付け
マスターは通常業務では介入せず
監査・トラブル対応・第三者提出時のみ利用
出力操作はすべて監査ログとして記録
画面 / エンドポイント（ローカル開発）
トップ
コードをコピーする

http://localhost:8080/harassment-app/
相談者
コードをコピーする

/consult/form
/consult/confirm
/consult/submit
/consult/status
/consult/status/{accessKey}
管理者
コードをコピーする

/admin/login
/admin/consult/list
/admin/consult/detail?id=...
/admin/consult/check
技術構成
Java Servlet / JSP（Tomcat 9系）
UI：Bootstrap 5
ルーティング：web.xml による一元管理（アノテーション不使用）
文字コード：UTF-8
データ保持：
初期：MemoryConsultationRepository（メモリ）
現在：MySQL 永続化対応
セキュリティ：
相談者照合キー（accessKey）
管理者・マスターの役割分離
操作ログ・出力ログを前提とした設計
データ設計（概要）
Consultation（相談）
基本情報
sheetDate / consultantName
相談概要
summary（必須）
発生後の状況
reportedExists / reportedPerson / reportedAt / followUp
心身状態
mentalScale / mentalDetail
今後の希望
futureRequest（複数選択） / futureRequestOtherDetail
共有設定
sharePermission / shareLimitedTargets
管理項目
adminChecked / status
相談者照合キー
accessKey
評価
reporterRating / reporterFeedback / reporterRatedAt
こだわり / 工夫した点
紙運用（記入 → 確認 → 提出）の流れを崩さずWeb化
Confirm画面は表示専用とし、入力UIを置かないことで誤操作防止
web.xml統一により、URL衝突や運用時の混乱を回避
現場職員・相談者のITリテラシー差を前提にしたUI設計
病院・大規模事業所での監査運用を想定した権限分離
今後の展望
PWA化 / Android（TWA）化による端末配布
通知機能（ステータス更新）
部署・期間・ステータスによる高度検索
ダッシュボード（年次・月次件数、傾向分析）
電子署名付きPDFの正式対応
多事業所対応（テナント化）
ライセンス / 注意事項
This software is licensed under AGPL-3.0.
Commercial use requires attribution and compliance with license terms.
This project is developed and maintained by 須山 健吾 (Kengo Suyama).
Designed for real-world harassment consultation operations.