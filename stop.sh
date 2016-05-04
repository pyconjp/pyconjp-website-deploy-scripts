#!/bin/bash

# 引数に年度を渡して起動
# deploy-scripts/start.sh 2016

YEAR=${1}

CONFIG_FILE=/opt/workspace/deploy-scripts/${YEAR}/config.sh

if [ ! -f $CONFIG_FILE ]; then
    echo '引数が無効です'
    exit
fi

kill `cat /var/run/pyconjp/gunicorn${YEAR}.pid`
