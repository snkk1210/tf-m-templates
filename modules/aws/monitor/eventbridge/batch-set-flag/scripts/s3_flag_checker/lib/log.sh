#!/usr/bin/bash

function emitLog()
{
    PWD=`dirname ${0}`
    LOGTIME=`date '+%H:%M:%S'`
    LOGFILE=${PWD}/../log/flag_checker-`date '+%Y%m%d'`.log

    printf "%-10s: %s\n" \
    "${LOGTIME}" "${1}" >> ${LOGFILE}
}