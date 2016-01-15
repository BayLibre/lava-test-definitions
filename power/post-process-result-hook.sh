#!/bin/sh
start_time=`cat start-time`
end_time=`cat end-time`
if [ $((end_time - start_time)) -gt 10 ]; then
    echo fail > $1/result
fi
echo $DEVICE_TYPE > $1/attachments/device-type.txt
