#!/bin/bash

# 引数に環境情報(staging, production)、年度を渡して起動
# deploy-scripts/stop.sh 2016

DEPLOY_TARGET=${1}
YEAR=${2}

CONFIG_FILE=/opt/workspace/deploy-scripts/${YEAR}/config-${DEPLOY_TARGET}.sh

if [ ${DEPLOY_TARGET} = "staging" ]; then
    CONFIG_FILE=/opt/workspace/deploy-scripts/staging/config.sh
fi

if [ ! -f $CONFIG_FILE ]; then
    echo '引数が無効です'
    exit
fi

if [ ${DEPLOY_TARGET} = "production" ]; then
  kill `cat /var/run/pyconjp/gunicorn${YEAR}.pid`
elif [ ${DEPLOY_TARGET} = "staging" ]; then
  kill `cat /var/run/pyconjp-stg/gunicorn-staging.pid`
fi
