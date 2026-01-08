harassment-app
ハラスメント相談システム（Web対応）
1. 概要
harassment-app は、
企業・事業所・病院などの職場における ハラスメント相談を、紙の相談シート運用に近い形で Web 化 したアプリケーションです。
現場で長年使われてきた
「記入 → 内容確認 → 提出 → 管理者確認」
という流れを崩さず、IT が得意でない職員でも直感的に使える構成を重視しています。
利用ロール
相談者
相談内容の入力
内容確認
送信
ステータス確認（照合キー方式）
管理者
相談一覧の確認
相談詳細の閲覧
確認チェック（未確認／確認済）
全権管理者（マスター）
全相談内容の閲覧
管理者対応履歴の閲覧
相談者の最終評価（5段階＋自由記述）の閲覧
PDF / CSV 出力（改ざん防止を前提とした監査用途）
2. 設計方針・特徴
Apache Tomcat 上での運用を前提
Servlet の URL 管理はすべて web.xml に統一
@WebServlet などのアノテーションは一切使用しません
URL 定義の一元管理により、運用・保守時の事故を防止
紙運用に近い画面遷移
入力 → 確認 → 送信
Confirm 画面では入力 UI を表示しない
二重送信・誤送信防止
相談者評価は管理者から不可視
役割分離を徹底
3. 動作環境（確認済み）
OS
Windows 10 / 11（PowerShell 使用）
Java
JDK 15.0.1
JAVA_HOME = C:\jdk-15.0.1
Web サーバー
Apache Tomcat 9.0.112
その他
ブラウザ：Google Chrome 推奨
文字コード：UTF-8
※ 本 README は JDK 15.0.1 + Tomcat 9.0.112 を基準に記載しています。
4. ディレクトリ構成（重要）
Tomcat の webapps 配下に展開される構成です。
コードをコピーする

apache-tomcat-9.0.112/
└─ webapps/
   └─ harassment-app/
      ├─ index.jsp
      ├─ consult/
      │  ├─ form.jsp
      │  ├─ confirm.jsp
      │  ├─ thanks.jsp
      │  └─ status.jsp
      ├─ admin/
      │  ├─ login.jsp
      │  └─ consult/
      │     ├─ list.jsp
      │     └─ detail.jsp
      ├─ master/
      │  └─ login.jsp
      └─ WEB-INF/
         ├─ web.xml
         ├─ classes/   ← ★ コンパイル後の .class
         └─ src/       ← ★ Java ソース
            └─ com/example/harassment/...
5. 環境構築手順
5.1 Tomcat パス設定（PowerShell）
コードをコピーする
Powershell
$TOMCAT_HOME = "C:\dev\apache-tomcat-9.0.112-windows-x64\apache-tomcat-9.0.112"
5.2 Java バージョン確認
コードをコピーする
Powershell
& "C:\jdk-15.0.1\bin\java.exe" -version
& "C:\jdk-15.0.1\bin\javac.exe" -version
6. コンパイル手順（必須）
6.1 なぜコンパイルが必要か
Tomcat は
WEB-INF/classes 内の .class ファイル を読み込んで動作します。
.java を編集しただけでは反映されません。
必ずコンパイルが必要です。
6.2 コンパイル用変数定義
コードをコピーする
Powershell
$APP      = Join-Path $TOMCAT_HOME "webapps\harassment-app"
$SRC_ROOT = Join-Path $APP "WEB-INF\src"
$CLASSES  = Join-Path $APP "WEB-INF\classes"
6.3 classes ディレクトリ作成
コードをコピーする
Powershell
New-Item -ItemType Directory -Force -Path $CLASSES | Out-Null
6.4 Java ソース取得
コードをコピーする
Powershell
$SRC_FILES = Get-ChildItem -Path $SRC_ROOT -Recurse -Filter *.java | `
             Select-Object -ExpandProperty FullName
6.5 コンパイル実行
コードをコピーする
Powershell
$CP = "$TOMCAT_HOME\lib\*;$CLASSES"

& "C:\jdk-15.0.1\bin\javac.exe" `
  -encoding UTF-8 `
  -cp $CP `
  -d $CLASSES `
  $SRC_FILES
7. Tomcat 起動・再起動
コードをコピーする
Powershell
pushd "$TOMCAT_HOME\bin"

.\shutdown.bat
Start-Sleep -Seconds 2
.\startup.bat

popd
起動確認
http://localhost:8080/
8. アプリケーション URL 一覧
トップ
http://localhost:8080/harassment-app/
相談者
/consult/form
相談フォーム入力
/consult/confirm
入力内容確認（表示専用）
/consult/submit
送信処理
/consult/status
/consult/status/{accessKey}
照合キーによるステータス確認
管理者
/admin/login
管理者ログイン
/admin/consult/list
相談一覧
/admin/consult/detail?id={ID}
相談詳細
/admin/consult/check（POST）
確認チェック
全権管理者（マスター）
/master/login
監査・評価閲覧・PDF/CSV 出力
9. 相談者の使い方（詳細）
① 相談フォーム入力
URL：/consult/form
必須項目：相談内容の概要
入力途中の内容は セッションに下書き保存
日付・時刻はカレンダー入力対応
② 内容確認
URL：/consult/confirm
表示専用画面（入力 UI なし）
「戻る」で修正可能（入力保持）
③ 送信完了
URL：/consult/submit
送信成功時：
下書きセッションを 必ず削除
送信完了画面表示
④ ステータス確認
照合キー方式
相談ごとに一意の accessKey を発行
第三者による閲覧不可
10. 管理者の使い方（詳細）
管理者ログイン
URL：/admin/login
管理者は 相談者評価を閲覧不可
相談一覧
登録順に表示
未確認／確認済の状態管理
相談詳細
相談内容全文表示
管理者対応の記録
確認チェック
POST により「確認済」フラグ付与
11. 全権管理者（マスター）
権限
全相談内容閲覧
管理者対応履歴閲覧
相談者評価（5段階＋自由記述）閲覧
PDF / CSV 出力（監査用途）
※ 管理者は評価を閲覧できません。
12. 想定導入先
病院
介護事業所
一般企業（B2B）
教育機関
自治体
13. 今後の展望
多事業所対応（テナント化）
月次／年次レポート
管理者対応品質評価
SaaS 展開・M&A 対応
厚生労働省様式との整合運用
14. ライセンス
This software is licensed under AGPL-3.0.
Commercial use requires attribution and compliance with license terms.
This project is developed and maintained by Kengo Suyama.
Designed for real-world harassment consultation operations.