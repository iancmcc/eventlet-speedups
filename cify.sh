#!/usr/bin/env bash

EVENTLET=$1/eventlet
HERE=$(dirname $0)


for f in greenio semaphore queue timeout hubs/hub hubs/poll hubs/timer; do
    cython ${EVENTLET}/${f}.py -o ${HERE}/src/eventlet/speedups/${f}.c
done
HUBINIT=${EVENTLET}/hubs/__init__.py 
cp ${HUBINIT} ${EVENTLET}/hubs/trampoline.py
cython ${EVENTLET}/hubs/trampoline.py -o ${HERE}/src/eventlet/speedups/hubs/trampoline.c
rm -f ${EVENTLET}/hubs/trampoline.py
