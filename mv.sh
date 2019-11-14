#!/bin/bash
file=$1
IFS='-'
read -ra name <<< "$file"
IFS=''
mv $file $PWD/"${name[0]}"