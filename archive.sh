#!/bin/bash

SERVICE=$1
DUMPS_DIR=$2

prev_hour=$(( `date +%H` - 1 ))
cd $DUMPS_DIR/$SERVICE
tar -czvf $SERVICE-$prev_hour.tar.gz $SERVICE-$prev_hour-*
rm $SERVICE-$prev_hour-*
