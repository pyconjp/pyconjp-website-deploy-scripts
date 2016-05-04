
#!/bin/bash

set -e
source 2016/config.sh
cd /opt/workspace/pyconjp-2016

source ./venv/bin/activate

./manage.py createsuperuser

