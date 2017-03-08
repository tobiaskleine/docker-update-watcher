#!/bin/sh

# start cron
sleep 10

docker login --username $DOCKER_USER --password $DOCKER_PASSWORD -e $DOCKER_EMAIL

/script.sh

/usr/sbin/crond -f -L 8