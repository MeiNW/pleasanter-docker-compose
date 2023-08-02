# pleasanter docker compose
dockerで動くpleasanterをdocker composeにまとめたもの

## 試験環境
Ubuntu 22.04

Docker version 24.0.5, build ced0996

Docker Compose version v2.20.2

### 参照元
https://qiita.com/imp-kawano/items/b4735325683426cfffa8

## 基本
### 起動
`sudo docker compose up -d`

### 停止
`sudo docker compose down`

## DB関連
### バックアップ
```
docker exec -t 起動中のpostgreコンテナID pg_dumpall -c -U postgres > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql
```

### リストア
`cat バックアップ.sql | docker exec -i 起動中のpostgreコンテナID psql -U postgres`

## volume関連
### dockerをデフォルトでインストールした場合のdockerホスト上のパス
`/var/lib/docker/volumes/pleasanter_db-data`

### volume一覧
`sudo docker volume ls`

「pleasanter_db-data」という名前のボリュームが見つかるはず

### volume削除
`docker volume rm pleasanter_db-data`
