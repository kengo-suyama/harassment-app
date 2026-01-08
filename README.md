Markdown
# harassment-app  
## ハラスメント相談システム（Web）

---

## 概要

**harassment-app** は、  
職場（企業・事業所・病院など）における **ハラスメント相談を、紙運用に近い形で Web 化** したアプリケーションです。

相談者・管理者・全権管理者（マスター）という **明確な役割分離** を行い、  
実際の事業所運用・監査対応を想定した設計になっています。

本システムは **Apache Tomcat 上で動作** し、  
**サーブレット定義はすべて `web.xml` に統一**しています。  
（`@WebServlet` などのアノテーションは使用しません）

---

## 利用者ロール

### 相談者
- 相談シート入力
- 内容確認
- 送信
- ステータス確認（照合キー方式）

### 管理者
- 管理者ログイン
- 相談一覧の確認
- 相談詳細の確認
- 「確認済」チェック

※ 管理者は **相談者の最終評価は閲覧できません**

### 全権管理者（マスター）
- すべての相談内容の閲覧
- 管理者の対応履歴の閲覧
- 相談者の最終評価（5段階＋自由記述）の閲覧
- PDF / CSV 出力（改ざん不可・監査用途）

---

## 技術構成

- Java Servlet / JSP
- Apache Tomcat 9.x
- MySQL（永続化対応）
- UI：Bootstrap 5
- 文字コード：UTF-8
- ルーティング管理：web.xml（アノテーション不使用）

※ **PWA は現時点では未対応**（将来拡張予定）

---

## ディレクトリ構成

```text
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
         ├─ classes/   ← コンパイル後の .class ファイル
         └─ src/       ← Java ソースコード
動作確認済み環境
Java
コードをコピーする
Text
JDK 15.0.1
Webサーバー
コードをコピーする
Text
Apache Tomcat 9.0.112
環境構築方法（Windows / PowerShell）
1. Tomcat のパス設定
コードをコピーする
Powershell
$TOMCAT_HOME = "C:\dev\apache-tomcat-9.0.112-windows-x64\apache-tomcat-9.0.112"
2. Java バージョン確認
コードをコピーする
Powershell
"C:\jdk-15.0.1\bin\java.exe" -version
"C:\jdk-15.0.1\bin\javac.exe" -version
3. Java ソースのコンパイル
コードをコピーする
Powershell
$APP_PATH = "$TOMCAT_HOME\webapps\harassment-app"
$CLASSES = "$APP_PATH\WEB-INF\classes"

New-Item -ItemType Directory -Force -Path $CLASSES | Out-Null

$SRC = Get-ChildItem "$APP_PATH\WEB-INF\src" -Recurse -Filter *.java | Select-Object -ExpandProperty FullName
$CP  = "$TOMCAT_HOME\lib\*;$CLASSES"

"C:\jdk-15.0.1\bin\javac.exe" -encoding UTF-8 -cp $CP -d $CLASSES $SRC
4. Tomcat 起動
コードをコピーする
Powershell
& "$TOMCAT_HOME\bin\shutdown.bat"
Start-Sleep -Seconds 2
& "$TOMCAT_HOME\bin\startup.bat"
アプリ起動確認
コードをコピーする
Text
http://localhost:8080/
コードをコピーする
Text
http://localhost:8080/harassment-app/
相談者の使い方（詳細）
① 相談フォーム入力
コードをコピーする
Text
/consult/form
必須項目：相談内容の概要
入力途中の内容は セッションに下書き保存
日付・時刻はカレンダー入力対応
② 内容確認画面
コードをコピーする
Text
/consult/confirm
表示専用画面（入力UIなし）
二重送信防止
「戻る」操作でも入力内容は保持
③ 送信完了
コードをコピーする
Text
/consult/submit
送信成功時：
セッション下書きを 必ず削除
送信完了画面を表示
④ ステータス確認（照合キー方式）
コードをコピーする
Text
/consult/status
/consult/status/{accessKey}
相談ごとに 一意の accessKey を発行
第三者による閲覧は不可
管理者の使い方
① 管理者ログイン
コードをコピーする
Text
/admin/login
② 相談一覧
コードをコピーする
Text
/admin/consult/list
登録順に表示
確認済 / 未確認 の状態表示
③ 相談詳細
コードをコピーする
Text
/admin/consult/detail?id={相談ID}
相談内容の全文表示
管理者対応内容の記録（拡張可能）
④ 確認チェック
コードをコピーする
Text
POST /admin/consult/check
管理者による「確認済」フラグ付与
全権管理者（マスター）機能
権限概要
すべての相談内容閲覧
管理者の対応履歴閲覧
相談者の最終評価（5段階＋自由記述）閲覧
PDF / CSV 出力（改ざん不可）
※ 管理者は相談者評価を閲覧できません（役割分離）
想定導入先
病院
介護事業所
一般企業（B2B）
教育機関
自治体
今後の展望
PWA 対応
多事業所管理（テナント対応）
月次 / 年次 統計レポート
SaaS 展開 / M&A 対応
厚生労働省様式との整合運用
ライセンス
コードをコピーする
Text
This software is licensed under AGPL-3.0.
Commercial use requires attribution and compliance with license terms.

This project is developed and maintained by Kengo Suyama.
Designed for real-world harassment consultation operations.