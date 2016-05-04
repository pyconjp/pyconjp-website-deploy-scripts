# PyCon JP yyyy WEBサイトのデプロイに使用するスクリプト群

* 基本的にはCircleCIから利用されますが、自分で叩いてもOKです
* 手動実行はWEBサイトの実行ユーザーで利用してください
* update.sh
  * `update.sh [staging|production] [2016]`
  * githubでmaster/developブランチにpushがあると動きます by CircleCI
  * developブランチだとステージング環境(ex. pyconjp-stg-2016)に `git pull` するだけです
  * masterブランチだと本番環境(ex. pyconjp-2016)に `git pull` した後、下記のスクリプトを叩きます

* stop.sh
  * `stop.sh [2016]`
  * production用の停止スクリプト

* start.sh
  * `start.sh [2016]`
  * production用の起動スクリプト

* yyyy
  * config.sh
    * 必要な環境変数を適宜宣言してください
  * createuser.sh
    * 初期化に利用

