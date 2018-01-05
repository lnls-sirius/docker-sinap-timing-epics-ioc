# Docker image for Sinap Timing EPICS IOC

This repository contains the Dockerfile used to create the Docker image with the
[EPICS IOC for the Sinap Timing](https://github.com/lnls-dig/sinap-timing-epics-ioc).
It also contains two other IOCs that use it for a higher level application, more
specifically the ICT and the DCCT IOCs.

## Running the IOCs

The simples way to run the IOC is to run:

    docker run --rm -it --net host lnlsdig/sinap-timing-epics-ioc -i IPADDR -d DEVICE

where `IPADDR` is the IP address of the device to connect to. The options you
can specify (after `lnlsdig/sinap-timing-epics-ioc`):

- `-i IPADDR`: device IP address to connect to (required)
- `-p IPPORT`: device IP port number to connect to (default: 5025)
- `-d DEVICE`: device identifier ([EVG<number>|EVE<number>|EVR<number>|FOUT<number>]) (required)
- `-P PREFIX1`: the value of the EPICS `$(P)` macro used to prefix the PV names
- `-R PREFIX2`: the value of the EPICS `$(R)` macro used to prefix the PV names

## Creating a Persistent Container

If you want to create a persistent container to run the IOC, you can run a
command similar to:

    docker run -it --net host --restart always --name CONTAINER_NAME lnlsdig/sinap-timing-epics-ioc -i IPADDR

where `IPADDR` is as in the previous section and `CONTAINER_NAME` is the name
given to the container. You can also use the same options as described in the
previous section.

## Building the Image Manually

To build the image locally without downloading it from Docker Hub, clone the
repository and run the `docker build` command:

    git clone https://github.com/lnls-dig/docker-sinap-timing-epics-ioc
    docker build -t lnlsdig/sinap-timing-epics-ioc docker-sinap-timing-epics-ioc
