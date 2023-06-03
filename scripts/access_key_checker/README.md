# access_key_checker

## Installation

```
cp -p ./etc/env.sh.default ./etc/env.sh
vi ./etc/env.sh
============================================
# AWS キー ( if necessary )
export AWS_ACCESS_KEY_ID=xxxxx
export AWS_SECRET_ACCESS_KEY=xxxxx
# Slack 通知用環境変数
CHANNEL_NAME="#xxxxx"
WEBHOOK_URL=https://hooks.slack.com/services/xxxxx/xxxxx
============================================
```

## Run

```
./bin/main.sh 90
```

※ The first argument takes a grace period.