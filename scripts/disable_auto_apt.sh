#!/usr/bin/env bash

sudo systemctl stop apt-daily.service
sudo systemctl kill --kill-who=all apt-daily.service

# wait until `apt-get updated` has been killed
while ! (sudo systemctl list-units --all apt-daily.service | fgrep -q dead)
do
  sleep 1;
done
