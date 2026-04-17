#!/usr/bin/env bash
cd /home/$(whoami)/kiosk-setup/local-web
python3 -m http.server 8080