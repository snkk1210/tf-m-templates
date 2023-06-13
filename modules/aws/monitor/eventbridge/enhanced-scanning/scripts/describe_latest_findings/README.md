# describe_latest_findings

## 概要

ECR リポジトリに格納された最新イメージの脆弱性検知結果を出力するスクリプト等々

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
※ ECR リポジトリの名称を 1 行ずつ記述 ( スクリプト実行時の引数で一部置換可能 )

・実行

```
./bin/enhanced_findings.sh {ENV}
./bin/finding_severity_counts.sh {ENV}
./bin/inspector_severity_counts.sh {ENV}
```