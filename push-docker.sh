#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
source "$SCRIPTPATH/commons.sh"

if [ $# -eq 0 ]; then
  echo "Usage: $0 IMAGE_NAME [PATH]"
  exit 2
fi

if [ $# -ge 2 ]; then
  BUILDPATH=$2
else
  BUILDPATH=.
fi

if [ "$(id -u)" -ne 0 ]; then
  echo "*** Must be root ***"
  exit 2
fi

docker build -t "$REGISTRY/$1" "$BUILDPATH"
docker push "$REGISTRY/$1"
