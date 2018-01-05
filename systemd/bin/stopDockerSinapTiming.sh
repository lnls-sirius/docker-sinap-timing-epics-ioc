#!/usr/bin/env bash

set -u

if [ -z "$SINAP_TIMING_INSTANCE" ]; then
    echo "Device type is not set. Please use -d option" >&2
    exit 1
fi

/usr/bin/docker stop \
    sinap-timing-epics-ioc-${SINAP_TIMING_INSTANCE}
