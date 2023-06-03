#!/usr/bin/bash

PWD=`dirname ${0}`

source ${PWD}/../etc/env.sh
. ${PWD}/../lib/log.sh
. ${PWD}/../lib/notify.sh

if [ $# != 1 ]; then
    echo "Error: invalid argument."
    emitLog "Error: invalid argument."
    exit 1
fi

if !(type "aws" > /dev/null 2>&1); then
    echo "Error: aws command is not found."
    emitLog "Error: aws command is not found."
    exit 1
fi

limit_sec=$(( 86400 * ${1} ))
today_sec=`date +%s`

## GET Users List

user_array=($(aws iam list-users | jq -r ".Users[] |.UserName"))

## GET Account ID

account_id=`aws sts get-caller-identity | jq -r '.Account'`

## GET AccessKey List

user_index=0
for i in ${user_array[@]}
do
     key_array[${user_index}]=`aws iam list-access-keys \
          --user-name ${i} \
          | jq -r '.AccessKeyMetadata[] | [.UserName, .CreateDate, .Status, .AccessKeyId] | @csv'`

     let user_index++
done

## Detect and Notify

key_index=0
for j in ${key_array[@]}
do
    # IAM Access Key Status ( Active or Inactive )
    status=`echo ${j} | awk -F "," '{print $3}'`
    # IAM Access Key Creation Date
    csv_second_field=`echo ${j} | awk -F "," '{print $2}' | awk -F "T" '{print $1}' | sed "s/\"//g"`
    create_time=`date -d "${csv_second_field}" +%s`
    # Grace Period
    grace_period=$(( create_time + limit_sec ))

    # Notify if grace period has passed and status is Active
    if [ ${today_sec} -gt ${grace_period} ] && [ ${status} = "\"Active\"" ]; then
        echo ${j}
        # Call emitLog function to logging.
        emitLog ${j}
        # Call notify2slack function to notify Slack.
        notify2slack `echo ${j} | sed "s/\"//g"` ${account_id}
        # Store detected access keys in an array.
        detect_array[${key_index}]=${j}
    fi

    let key_index++
done