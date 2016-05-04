#!/bin/bash

set -e

# 第一引数に deploy 対象 staging か production
# 第二引数に年度
# deploy-scripts/update.sh staging 2016

DEPLOY_TARGET=${1}
YEAR=${2}

CONFIG_FILE=/opt/workspace/deploy-scripts/${YEAR}/config.sh

if [ ${DEPLOY_TARGET} = "staging" ]; then
    TARGET_PATH="/opt/workspace/pyconjp-stg-${YEAR}"
    TARGET_BRANCH="develop"
elif [ ${DEPLOY_TARGET} = "production" ]; then
    TARGET_PATH="/opt/workspace/pyconjp-${YEAR}"
    TARGET_BRANCH="master"
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


cd ${TARGET_PATH}

# 不要なマージコミットが発生しないように一旦クリーンにする
git reset --hard HEAD
git checkout ${TARGET_BRANCH}
git pull origin ${TARGET_BRANCH}

if [ ${DEPLOY_TARGET} = "production" ]; then
    # 日常的に DB の sync と migrate 要らないと思うので省いときます。
    # ./venv/bin/python manage.py syncdb
    # ./venv/bin/python manage.py migrate
    
    ./venv/bin/python manage.py collectstatic --noinput
    ./venv/bin/python manage.py compress --force
    
    /opt/workspace/deploy-scripts/stop.sh ${YEAR}
    sleep 5
    /opt/workspace/deploy-scripts/start.sh ${YEAR}
fi

