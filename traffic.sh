#!/bin/bash
# Copyright 2020 Nokia
# Licensed under the BSD 3-Clause License.
# SPDX-License-Identifier: BSD-3-Clause

set -eu

startTraffic() {
    SRC=$1
    DST=$2
    echo "Starting traffic between client${SRC} and client${DST}"
    docker exec client${SRC} bash /config/iperf-${SRC}-${DST}.sh
}

stopTraffic() {
    DST=$1
    echo "Stopping traffic on client${DST}"
    docker exec client${SRC} pkill iperf3
}

startAll() {
    echo "Starting traffic on all clients"
    for SRC in {1..4}; do
        for DST in {1..4}; do
            if [ "$SRC" != "$DST" ]; then
                docker exec client${SRC} bash /config/iperf-${SRC}-${DST}.sh &
            fi
        done
    done
    wait
    echo "All traffic started"
}

stopAll() {
    echo "Stopping all traffic"
    for CLIENT in {1..4}; do
        docker exec client${CLIENT} pkill iperf3 || true
        docker exec client${CLIENT} bash /config/iperf-start-server.sh &
    done
    echo "All traffic stopped"
}

# Parse arguments
if [ "$1" == "start" ]; then
    if [ "$2" == "all" ]; then
        startAll
    else
        IFS='-' read -r SRC DST <<< "$2"
        startTraffic $SRC $DST
    fi
elif [ "$1" == "stop" ]; then
    if [ "$2" == "all" ]; then
        stopAll
    else
        IFS='-' read -r SRC DST <<< "$2"
        stopTraffic $DST
    fi
else
    echo "Usage: $0 <start|stop> <x-y|all>"
    exit 1
fi
