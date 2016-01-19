#!/bin/sh
## FIXME: understand how to put a step in background on host
##
date +%s > capture-start-time

dut=`echo $DEVICE | sed -e 's|dut\([0-9]*\)-.*|\1|g'`

iio-capture -n lab-baylibre-acme.local iio:device$dut > $1/attachments/$dut_power_report.json.part

echo $! > capture-pid
