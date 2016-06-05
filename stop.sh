#!/bin/bash

# 引数に年度を渡して起動
# deploy-scripts/start.sh 2016

DEPLOY_TARGET=${1}
YEAR=${2}

CONFIG_FILE=/opt/workspace/deploy-scripts/${YEAR}/config-${DEPLOY_TARGET}.sh

if [ ! -f $CONFIG_FILE ]; then
    echo '引数が無効です'
    exit
fi

if [ ${DEPLOY_TARGET} = "production" ]; then
  kill `cat /var/run/pyconjp/gunicorn${YEAR}.pid`
elif [ ${DEPLOY_TARGET} = "staging" ]; then
  kill `cat /var/run/pyconjp/gunicorn${YEAR}-${DEPLOY_TARGET}.pid`
fi
