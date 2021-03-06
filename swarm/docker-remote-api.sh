#!/bin/bash

# Script to restart Docker and listen on 4243 remote API port.

# For Upstart ONLY (pre- Ubuntu 15.04)
if [ -d "/var/log/upstart" ]; then
    # Upstart
    echo DOCKER_OPTS=\"-H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock\" >> /etc/default/docker
    service docker restart
else
    # Systemd
    sed -i -e 's@ExecStart=/usr/bin/dockerd -H fd://@ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:4243@g' /lib/systemd/system/docker.service
    systemctl daemon-reload
    service docker restart
fi
