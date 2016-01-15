#!/bin/sh
date +%s > capture-stop-time

pid=`cat capture-pid`

kill -2 $pid

