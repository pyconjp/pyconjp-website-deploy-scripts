#!/bin/bash

set -e

# 第一引数に deploy 対象 staging か production
# 第二引数に年度
# deploy-scripts/update.sh staging 2016

DEPLOY_TARGET=${1}
YEAR=${2}
PRODUCTION_URL="https://pycon.jp/${YEAR}/"

if [ ${DEPLOY_TARGET} = "staging" ]; then
    CONFIG_FILE=/opt/workspace/deploy-scripts/staging/config.sh
    TARGET_PATH="/opt/workspace/pyconjp-staging"
    TARGET_BRANCH="develop"
    SLACK_MESSAGE="ステージング"
    PRODUCTION_URL="https://staging.pycon.jp/${YEAR}/"
elif [ ${DEPLOY_TARGET} = "production" ]; then
    CONFIG_FILE=/opt/workspace/deploy-scripts/${YEAR}/config-${DEPLOY_TARGET}.sh
    TARGET_PATH="/opt/workspace/pyconjp-${YEAR}"
    TARGET_BRANCH="master"
    SLACK_MESSAGE="本番サイト"
else
    echo '第一引数の deploy 対象が無効です'
    exit
fi

if [ ! -f $CONFIG_FILE ]; then
    echo '第二引数の年度が無効です'
    exit
fi

echo $TARGET_PATH
echo $CONFIG_FILE
source $CONFIG_FILE


cd ${TARGET_PATH}

# 不要なマージコミットが発生しないように一旦クリーンにする
git reset --hard HEAD
git checkout ${TARGET_BRANCH}
git pull origin ${TARGET_BRANCH}

if [ ${DEPLOY_TARGET} = "production" ] || [ ${DEPLOY_TARGET} = "staging" ]; then
  # 日常的に DB の sync と migrate 要らないと思うので省いときます。
  # ./venv/bin/python manage.py syncdb
  # ./venv/bin/python manage.py migrate

  ./venv/bin/python manage.py collectstatic --noinput
  ./venv/bin/python manage.py compress --force

  /opt/workspace/deploy-scripts/stop.sh ${DEPLOY_TARGET} ${YEAR}
  sleep 5
  /opt/workspace/deploy-scripts/start.sh ${DEPLOY_TARGET} ${YEAR}
  sleep 10
  STATUS_CODE=`curl -LI ${PRODUCTION_URL} -o /dev/null -w '%{http_code}\n' -s`
  if [ ${STATUS_CODE} = "200" ]; then
    curl -X POST --data-urlencode 'payload={"channel": "#web-system", "username": "webhookbot", "text": "'${SLACK_MESSAGE}'、正常に立ち上がりました。", "icon_emoji": ":funassyi:"}' ${SLACK_WEBHOOK_URL}
  else
    curl -X POST --data-urlencode 'payload={"channel": "#web-system", "username": "webhookbot", "text": "'${SLACK_MESSAGE}'！本番サイトの立ち上げに失敗したかもしれません。至急ご確認を。。。", "icon_emoji": ":fire:"}' ${SLACK_WEBHOOK_URL}
  fi
fi
