# What's this?
docker composeで動くPleasanterを自分の環境に合うようアレンジしたもの

## 試験環境
- Ubuntu 22.04
- Docker version 24.0.5, build ced0996
- Docker Compose version v2.20.2

## Pleasanterとは
無料で使えるOSSのノーコード・ローコード開発ツール

とても便利で活用しています

https://pleasanter.org/

## 参照元
https://qiita.com/imp-kawano/items/b4735325683426cfffa8

https://qiita.com/imp-kawano/items/a9407d474c1dd39731d2

## 参照元からの主な変更点
- setup.sqlにImplem.Pleasanter_Userに関する設定を追加
- .envのPOSTGRES_USERとPOSTGRES_DBをpostgresに固定
- docker-compose.ymlにデータ永続化のためのボリューム db-dataを追加
- docker-compose.ymlにSQLバックアップ用フォルダbackupを追加

## 注意
- .envとsetup.sqlにあるパスワードはそれぞれお好みの文字列に置き換えてください。
```
<Any Sa password>
<Any Owner password>
<Any User password>
```

- docker-compose.ymlにあるパスは自分の環境に合わせて書き換えてください。
```
<path to your work dir> ※ docker-compose.ymlや.envを置いているdockerホストのディレクトリパスを指す
```

## 基本
前提として`<path to your work dir>`に移動した状態です。

### 起動
```
sudo docker compose up -d
```

### アクセス
webブラウザで http:\//dockerホストIP:50001 にアクセス

初期ID/PWは`Administrator/pleasanter`

### 停止
```
sudo docker compose down
```

## DB関連
必ず自身の環境でバックアップ/リストアはテストしてください。

コマンドがあるからと言って必要な場面でリストアが成功するとは限りません。

### バックアップ
-c以降はコンテナ内で実行されるコマンドです。

dockerホストのbackupフォルダをバインドしているので、そこにバックアップファイルが設置されます。
```
sudo docker exec -it 起動中のpostgreコンテナID /bin/sh -c "pg_dump -U postgres -Fc Implem.Pleasanter > /backup/`date +%Y%m%d"_"%H%M%S`_pleasanter.dump"
```

### リストア
`<backup_file_name>`は各自書き換えてください。
```
sudo docker exec -it 起動中のpostgreコンテナID /bin/sh -c "pg_restore -c -U postgres -d Implem.Pleasanter /backup/<backup_file_name>"
```

### インデックス再構築

バックアップを取ってから実行すること
```
sudo docker exec -it 起動中のpostgreコンテナID bash

(postgreコンテナ内)
psql --username postgres -d "Implem.Pleasanter" -c 'REINDEX DATABASE "'Implem.Pleasanter'";'
```

### collation version mismatch

```
WARNING:  database "postgres" has a collation version mismatch
DETAIL:  The database was created using collation version 2.31, but the operating system provides version 2.36.
HINT:  Rebuild all objects in this database that use the default collation and run ALTER DATABASE postgres REFRESH COLLATION VERSION, or build PostgreSQL with the right library version.
```

上記のような警告が出た場合、下記コマンドでバージョンを合わせる

```
sudo docker exec -it 起動中のpostgreコンテナID bash

(postgreコンテナ内)
psql --username postgres -d "Implem.Pleasanter" -c 'ALTER DATABASE "Implem.Pleasanter" REFRESH COLLATION VERSION;'
```


## volume関連
### dockerをデフォルトでインストールした場合のdockerホスト上のパス
```
/var/lib/docker/volumes/pleasanter_db-data
```

### volume一覧
```
sudo docker volume ls
```

「pleasanter_db-data」という名前のボリュームが見つかるはず

### volume削除(DBデータ丸ごと削除)
バックアップ/リストアのテストなどで利用

コンテナが停止していないと削除できない
```
sudo docker volume rm pleasanter_db-data
```
