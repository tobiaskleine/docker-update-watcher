#!/bin/sh

# code goes here.
echo "This is a script, run by cron!"

docker pull startcoding/docker-integration-test:staging

docker images -q --no-trunc startcoding/docker-integration-test:staging