#!/bin/sh
set -e

BIN_DIR=${INSTALL_K3S_RESTARTER_BIN_DIR:-"/sbin"}

sudo tee ${BIN_DIR}/k3s-restarter >/dev/null <<EOF
#!/usr/bin/env bash

echo "\$\$" >/var/run/k3s-restarter-trap.pid
handler(){
    sleep 5
    /etc/init.d/k3s-service restart
}
trap handler SIGHUP
tail -f /dev/null & wait \$!
EOF
sudo chmod +x ${BIN_DIR}/k3s-restarter

sudo tee /etc/init.d/k3s-restarter-service >/dev/null <<EOF
#!/sbin/openrc-run

supervisor=supervise-daemon
name="k3s-restarter-service"
command="${BIN_DIR}/k3s-restarter"
command_args=">/var/log/k3s-restarter.log 2>&1"

output_log=/var/log/k3s-restarter.log
error_log=/var/log/k3s-restarter.log

pidfile="/var/run/k3s-restarter.pid"
respawn_delay=5
respawn_max=0
EOF
sudo chmod +x /etc/init.d/k3s-restarter-service

if [ "${INSTALL_K3S_RESTARTER_SKIP_ENABLE}" != true ]; then
  sudo rc-update add k3s-restarter-service
fi

if [ "${INSTALL_K3S_RESTARTER_SKIP_START}" != true ]; then
  sudo rc-service k3s-restarter-service restart
fi
