#!/usr/bin/bash

PWD=`dirname ${0}`

source ${PWD}/../etc/env.sh
. ${PWD}/../lib/notify.sh
. ${PWD}/../lib/log.sh

if [ $# != 2 ]; then
    echo "Error: invalid argument."
    emitLog "Error: invalid argument."
    error2slack "InvalidArgument."
    exit 1
fi

if !(type "aws" > /dev/null 2>&1); then
    echo "Error: aws command is not found."
    emitLog "Error: aws command is not found."
    error2slack "AWSCommandIsNotFound."
    exit 1
fi

CURRENT_TIME=`date '+%Y/%m/%d'`
OUTPUT=$(aws s3 ls ${1}/${CURRENT_TIME}/${2}) || RESULT=$?

if [ ! ${RESULT} = "0" ]; then
    echo "Error: ${2} Flag is not Found."
    emitLog "Error: ${2} Flag is not Found."
    notify2slack "${2}"
    exit 1
fi

emitLog "Success: ${OUTPUT}"
