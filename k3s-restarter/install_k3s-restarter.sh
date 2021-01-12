#!/bin/bash
sudo cp ./k3s-restarter /opt
sudo cp ./k3s-restarter.service /etc/init.d
sudo rc-update add k3s-restarter.service
sudo rc-service k3s-restarter.service restart
