#!/usr/bin/env bash

set -u

if [ -z "$SINAP_TIMING_INSTANCE" ]; then
    echo "Device type is not set. Please use -d option" >&2
    exit 1
fi

SINAP_TIMING_TYPE=$(echo ${SINAP_TIMING_INSTANCE} | grep -Eo "[^0-9]+");
SINAP_TIMING_NUMBER=$(echo ${SINAP_TIMING_INSTANCE} | grep -Eo "[0-9]+");

if [ -z "$SINAP_TIMING_TYPE" ]; then
    echo "SINAP_TIMING device type is not set. Please check the SINAP_TIMING_INSTANCE environment variable" >&2
    exit 2
fi

if [ -z "$SINAP_TIMING_NUMBER" ]; then
    echo "SINAP_TIMING number is not set. Please check the SINAP_TIMING_INSTANCE environment variable" >&2
    exit 3
fi

export SINAP_TIMING_CURRENT_PV_AREA_PREFIX=SINAP_TIMING_${SINAP_TIMING_INSTANCE}_PV_AREA_PREFIX
export SINAP_TIMING_CURRENT_PV_DEVICE_PREFIX=SINAP_TIMING_${SINAP_TIMING_INSTANCE}_PV_DEVICE_PREFIX
export SINAP_TIMING_CURRENT_DEVICE_IP=SINAP_TIMING_${SINAP_TIMING_INSTANCE}_DEVICE_IP
export SINAP_TIMING_CURRENT_DEVICE_PORT=SINAP_TIMING_${SINAP_TIMING_INSTANCE}_DEVICE_PORT
# Only works with bash
export EPICS_PV_AREA_PREFIX=${!SINAP_TIMING_CURRENT_PV_AREA_PREFIX}
export EPICS_PV_DEVICE_PREFIX=${!SINAP_TIMING_CURRENT_PV_DEVICE_PREFIX}
export EPICS_DEVICE_IP=${!SINAP_TIMING_CURRENT_DEVICE_IP}
export EPICS_DEVICE_PORT=${!SINAP_TIMING_CURRENT_DEVICE_PORT}

# Create volume for autosave and ignore errors
/usr/bin/docker create \
    -v /opt/epics/startup/ioc/sinap-timing-epics-ioc/iocBoot/ioctiming/autosave \
    --name sinap-timing-epics-ioc-${SINAP_TIMING_INSTANCE}-volume \
    lnlsdig/sinap-timing-epics-ioc:${IMAGE_VERSION} \
    2>/dev/null || true

# Remove a possible old and stopped container with
# the same name
/usr/bin/docker rm \
    sinap-timing-epics-ioc-${SINAP_TIMING_INSTANCE} || true

/usr/bin/docker run \
    --net host \
    -t \
    --rm \
    --volumes-from sinap-timing-epics-ioc-${SINAP_TIMING_INSTANCE}-volume \
    --name sinap-timing-epics-ioc-${SINAP_TIMING_INSTANCE} \
    lnlsdig/sinap-timing-epics-ioc:${IMAGE_VERSION} \
    -i ${EPICS_DEVICE_IP} \
    -p ${EPICS_DEVICE_PORT} \
    -d ${SINAP_TIMING_INSTANCE} \
    -P ${EPICS_PV_AREA_PREFIX} \
    -R ${EPICS_PV_DEVICE_PREFIX}
## If there is a container with the same name
## use it
#if [ "$?" -ne "0" ]; then
#    /usr/bin/docker start \
#	-a \
#       sinap-timing-epics-ioc-${SINAP_TIMING_INSTANCE}
#    exit 0
#fi
