#!/bin/bash

set -e

# 引数に環境情報(staging, production)、年度を渡して起動
# deploy-scripts/start.sh 2016

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

# config 読み込み
. $CONFIG_FILE

if [ ${DEPLOY_TARGET} = "production" ]; then
  CONFIG_FILE=/opt/workspace/deploy-scripts/${YEAR}/config-${DEPLOY_TARGET}.sh
  cd /opt/workspace/pyconjp-${YEAR}
  # newrelic を外す
  # /opt/workspace/pyconjp-website-${YEAR}/venv/bin/newrelic-admin run-program /opt/workspace/pyconjp-${YEAR}/venv/bin/gunicorn --pid=/var/run/pyconjp/gunicorn${YEAR}.pid --log-file=/var/log/pyconjp/gunicorn${YEAR}.log --bind=0.0.0.0:8118 symposion.wsgi:application --daemon
  /opt/workspace/pyconjp-${YEAR}/venv/bin/gunicorn --pid=/var/run/pyconjp/gunicorn${YEAR}.pid --log-file=/var/log/pyconjp/gunicorn${YEAR}.log --bind=0.0.0.0:${DJANGO_PORT} symposion.wsgi:application --daemon
elif [ ${DEPLOY_TARGET} = "staging" ]; then
  CONFIG_FILE=/opt/workspace/deploy-scripts/staging/config.sh
  cd /opt/workspace/pyconjp-staging
  /opt/workspace/pyconjp-staging/venv/bin/gunicorn --pid=/var/run/pyconjp-stg/gunicorn-staging.pid --log-file=/var/log/pyconjp-stg/gunicorn-staging.log --bind=0.0.0.0:${DJANGO_PORT} symposion.wsgi:application --daemon
fi
