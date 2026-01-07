
# 1. harassment-app  
## ハラスメント相談システム（Web 対応）

---

## 2. 概要

**harassment-app** は、  
職場（企業・事業所・病院など）における **ハラスメント相談を紙運用に近い形で Web 化** したアプリケーションです。

### 2.1 ロール別の利用者

- **相談者**：入力 → 確認 → 送信  
- **管理者**：相談一覧・詳細確認・対応管理  
- **全権管理者（マスター）**：監査・評価閲覧・改ざん不可出力  

Apache Tomcat 上で動作し、  
**サーブレット定義はすべて web.xml に統一**しています。  
（`@WebServlet` 等のアノテーションは使用しません）

---

## 3. 技術構成

- Java Servlet / JSP  
- Apache Tomcat 9.x  
- MySQL（永続化対応）  
- UI：Bootstrap 5  
- 文字コード：UTF-8  

※ **PWA は現時点では未対応（将来拡張予定）**

---

## 4. クイックスタート

### 4.1 Tomcat 起動

Tomcat の `bin` ディレクトリで実行します。

- 停止  
  `shutdown.bat`

- 起動  
  `startup.bat`

起動確認：  
http://localhost:8080/

---

### 4.2 アプリ起動

http://localhost:8080/harassment-app/

---

## 5. 相談者の使い方

### 5.1 相談フォーム  
/consult/form  

- 必須項目：相談内容の概要  
- 入力途中の内容はセッションに下書き保存  

### 5.2 内容確認  
/consult/confirm  

- 表示専用画面（入力UIなし）  
- 二重送信防止  

### 5.3 送信完了  
/consult/submit  

- 送信成功時に下書きを必ず削除  

### 5.4 ステータス確認（照合キー方式）  
/consult/status  
/consult/status/{accessKey}  

- 相談ごとに一意の accessKey を発行  
- 第三者による閲覧不可  

---

## 6. 管理者機能

### 6.1 管理者ログイン  
/admin/login  

- 相談内容の管理のみ可能  
- **相談者の最終評価は閲覧不可**

### 6.2 相談一覧  
/admin/consult/list  

- 登録順表示  
- 確認済 / 未確認 の状態管理  

### 6.3 相談詳細  
/admin/consult/detail?id={相談ID}  

- 相談内容全文表示  
- 管理者対応内容の記録（拡張可能）  

### 6.4 確認チェック  
POST /admin/consult/check  

- 管理者による確認済フラグ付与  

---

## 7. 全権管理者（マスター）機能

### 7.1 マスターログイン URL

/ master / login  

※ 実際の URL は以下の形式で実装してください：

/master/login  

（管理者ログインとは **完全に分離** されたロール）

### 7.2 権限概要

全権管理者（マスター）は **監査・統括専用ロール** です。

可能な操作：

- すべての相談内容閲覧  
- 管理者の対応履歴閲覧  
- **相談者の最終評価（5段階＋自由記述）閲覧**  
- PDF / CSV 出力（**改ざん不可**）  

※ 管理者は相談者評価を閲覧できません（役割分離）

### 7.3 出力機能（監査対応）

- 相談内容全文  
- 管理者対応履歴  
- 相談者評価  
- 日時・操作者情報  

内部監査・労基対応・第三者委員会提出を想定しています。

---

## 8. セキュリティ方針

- 本番環境では HTTPS 必須  
- 管理画面は IP 制限 / VPN 推奨  
- 初期パスワードは README に記載しない  
- 認証情報は .env 等で管理  
- 監査ログ・評価は改ざん不可前提  

---

## 9. 想定導入先

- 病院  
- 介護事業所  
- 一般企業（B2B）  
- 教育機関  
- 自治体  

---

## 10. 今後の展望

- 多事業所管理（テナント対応）  
- 月次 / 年次 統計レポート  
- 管理者対応品質評価  
- PWA 化 / モバイル対応  
- SaaS 展開 / M&A 対応  
- 厚生労働省様式との整合運用  

---

## 11. ライセンス

This software is licensed under **AGPL-3.0**.  
Commercial use requires attribution and compliance with license terms.

This project is developed and maintained by **Kengo Suyama**.  
Designed for real-world harassment consultation operations.