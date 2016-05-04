#!/bin/bash

set -e

# 引数に年度を渡して起動
# deploy-scripts/start.sh 2016

YEAR=${1}
CONFIG_FILE=/opt/workspace/deploy-scripts/${YEAR}/config.sh

if [ ! -f $CONFIG_FILE ]; then
    echo '引数が無効です'
    exit
fi

# config 読み込み
. $CONFIG_FILE

cd /opt/workspace/pyconjp-${YEAR}

# newrelic を外す
# /opt/workspace/pyconjp-website-${YEAR}/venv/bin/newrelic-admin run-program /opt/workspace/pyconjp-${YEAR}/venv/bin/gunicorn --pid=/var/run/pyconjp/gunicorn${YEAR}.pid --log-file=/var/log/pyconjp/gunicorn${YEAR}.log --bind=0.0.0.0:8118 symposion.wsgi:application --daemon
/opt/workspace/pyconjp-${YEAR}/venv/bin/gunicorn --pid=/var/run/pyconjp/gunicorn${YEAR}.pid --log-file=/var/log/pyconjp/gunicorn${YEAR}.log --bind=0.0.0.0:${DJANGO_PORT} symposion.wsgi:application --daemon

