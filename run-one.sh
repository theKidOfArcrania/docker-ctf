#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
source "$SCRIPTPATH/commons.sh"

if [ "$#" -ne "1" ]; then
  echo "Usage: $0 SERVICE"
  exit 1
fi

"$SCRIPTPATH/run-dockers.sh" $REGISTRY $1
