#!/bin/bash

set -e

SALT=s4lty_salt
SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

if [ $# -le 1 ]; then
  echo "Usage: $0 REPO IMAGES..."
  exit 2
fi

if [ "$(id -u)" -ne 0 ]; then
  echo "*** Must be root ***"
  exit 2
fi


test_container() {
  local img=$1
  shift
  if docker ps "$@" -f "name=$img" | grep -F "$img" > /dev/null; then
    return 0;
  else
    return 1;
  fi
}

port_id() {
  (echo -n 'obase=10; ibase=16; ' && \
    echo -n "$SALT$1" | md5sum | head -c 4 | tr 'a-z' 'A-Z' && \
    echo '') | bc
}

REPO="$1"
shift

for img in "$@"; do
  echo "[*] Downloading $img..."
  if ! docker pull "$REPO/$img"; then
    echo "[!] Failed to fetch $img!"
    continue
  fi

  echo "[*] Checking for previous instances of $img..."
  if test_container "$img"; then
    docker kill "$img" > /dev/null
    docker container rm "$img" > /dev/null
  elif test_container "$img" -a; then
    docker container rm "$img" > /dev/null
  fi

  PORT="$(docker inspect --format='{{.Config.ExposedPorts}}' "$REPO/$img" \
    | cut -c 5- | sed 's/\/tcp:{}//g' | tr -d ']' | awk '{ print $1; }')"

  echo "[*] Starting $img..."
  docker run --security-opt seccomp=$SCRIPT_DIR/seccomp-rules.json \
    -d --restart always \
    --name "$img" \
    -p "$(port_id "$img"):$PORT" \
    "$REPO/$img" || true
done

docker ps --format "table {{.Names}}\t{{.Ports}}"

