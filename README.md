Herocker
========

Heroku + Locker

- herokuを一時的な画像uploaderにする
- 9000件以上は古いファイルから削除していく

## 画像アップロードの仕方
- `/images`から手動でアップロードする
    - 画像ページにリダイレクト
- スクリプトから`/images.json`にPOSTする
    - `{"image_url":"http://example.com/images/[md5].jpg"}`みたいなjsonが返ってくる

## 認証
環境変数で簡易的な認証ができる

- `HEROKER_USERNAME`, `HEROKER_PASSWORD`
    - 全体にBasic認証が掛かる
- `HEROKER_UPLOAD_TOKEN`
    - upload時に`upload_token`が必要になる

## 背景
- スクリプトからHipChatに貼り付ける用の画像をどこかにアップロードしたかった
    - hipchatには画像UploadAPIがない
    - しばらくしたら消えても構わない
- Herokuのpostgresは(今は)10,000レコードまで無料で使える
