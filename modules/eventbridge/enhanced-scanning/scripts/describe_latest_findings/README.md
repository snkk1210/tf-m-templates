# describe_latest_findings

## 概要

ECR の 脆弱性検知結果を出力するスクリプトとか

## Usage

・設定ファイルを生成

```
cp -p ./etc/env.sh.default ./etc/env.sh
cp -p ./etc/list.sh.default ./etc/list.sh
```

・設定ファイル内の環境変数を設定

```
vi ./etc/env.sh
```

```AWS_ACCESS_KEY_ID=
export AWS_ACCESS_KEY_ID= ← アクセスキー
export AWS_SECRET_ACCESS_KEY= ← シークレットキー
```

```
vi ./etc/list.sh
```
※ 追加あれば ECR の名称を 1 行ずつ記述

・実行

```
./bin/main.sh {ENV}
```