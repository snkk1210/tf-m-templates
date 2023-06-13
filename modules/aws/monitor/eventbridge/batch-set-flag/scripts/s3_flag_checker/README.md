# s3_flag_checker

## 概要

S3 バケットのフラグをチェックし、結果が「負」であれば Slack へ通知するスクリプトです。  

## Usage

・設定ファイルを生成

```
cp -p ./etc/env.sh.default ./etc/env.sh
```

・設定ファイル内の環境変数を設定

```
vi ./etc/env.sh
```

```AWS_ACCESS_KEY_ID=
AWS_ACCESS_KEY_ID= ← アクセスキー
AWS_SECRET_ACCESS_KEY= ← シークレットキー
CHANNEL_NAME= ← Slack 部屋名
WEBHOOK_URL=https:// ← Webhook URL
```

・実行

```
./bin/main.sh [S3バケット] [フラグ]
```

・ログの自動削除 ( cron )

```
00 08 * * * find /<path>/s3_flag_checker/log/ -type f -mtime +3 | grep -v ".keep" | xargs rm -f
```