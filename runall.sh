#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
source "$SCRIPTPATH/commons.sh"

"$SCRIPTPATH/run-dockers.sh" $REGISTRY $SERVICES
