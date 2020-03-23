#!/bin/bash
set -e

# setup ros environment
source "/signalcup_ws/devel/setup.bash"
exec "$@"