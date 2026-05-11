# Service Monitor
## Overview
Small script to log and notify via ntfy.sh whether docker containers are running on a home server.

## Setup
- Copy `.env.example` to `.env` and fill in your ntfy URL
- Symlink systemd units to `/etc/systemd/system/`
- Run `sudo systemctl daemon-reload && sudo systemctl enable --now service-monitor.timer`

## Requirements
- Docker
- curl
- systemd
