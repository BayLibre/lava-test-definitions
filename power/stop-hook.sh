#!/bin/sh
date +%s > end-time

pid=`cat capture-pid`
kill -2 $pid

