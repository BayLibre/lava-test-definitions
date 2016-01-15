#!/bin/sh
## FIXME: understand how to put a step in backgrounf on host
##
date +%s > capture-start-time

#replace with iio_readdev
sleep 100 & 

echo $! > capture-pid
