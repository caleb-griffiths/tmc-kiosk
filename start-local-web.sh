#!/usr/bin/env bash
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE_DIR/local-web"
python3 -m http.server 8080
