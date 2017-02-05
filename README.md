# PyCon JP yyyy WEBサイトのデプロイに使用するスクリプト群

* 基本的にはCircleCIから利用されますが、自分で叩いてもOKです
* 手動実行はWEBサイトの実行ユーザーで利用してください
* update.sh
  * `update.sh [staging|production] [2016]`
  * staging の時は第2引数である年度は不要です。（あっても問題無いですが無視されます）
  * 同じ引数で stop.sh を起動後、下記の処理をして start.sh を呼びます
  * githubでmaster/developブランチにpushがあると動きます by CircleCI
  * developブランチだとステージング環境(pyconjp-staging)に `git pull` するだけです
  * masterブランチだと本番環境(ex. pyconjp-2016)に `git pull` した後、下記のスクリプトを叩きます

* stop.sh
  * `stop.sh [staging|production] [2016]`
  * production用の停止スクリプト

* start.sh
  * `start.sh [staging|production] [2016]`
  * production用の起動スクリプト

* yyyy
  * config-production.sh
    * 本番環境で必要な環境変数を適宜宣言してください
  * createuser.sh
    * 初期化に利用

* staging
  * config.sh
    * ステージング環境で必要な環境変数を適宜宣言してください

