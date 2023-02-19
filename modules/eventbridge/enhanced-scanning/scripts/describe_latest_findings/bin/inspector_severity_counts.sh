#!/usr/bin/bash

PWD=`dirname ${0}`

source ${PWD}/../etc/env.sh
. ${PWD}/../lib/log.sh

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

## GET LATEST IMAGE TAG

container_array=($(/bin/bash ${PWD}/../etc/list.sh ${1}))

container_index=0
for i in ${container_array[@]}
do
     tag_array[${container_index}]=`aws ecr describe-images \
          --region ap-northeast-1 \
          --repository-name ${i} \
          --query 'sort_by(imageDetails,& imagePushedAt)[-1]' --output json \
          | jq -r '.imageTags[0]'`

     let container_index++
done

## SHOW SCAN FINDING

tag_index=0
for i in ${tag_array[@]}
do
     echo "---------------------------------------------------------"
     aws ecr describe-image-scan-findings \
          --region ap-northeast-1 \
          --repository-name ${container_array[$tag_index]} \
          --image-id imageTag=${i} \
          | jq '.repositoryName, .imageId.imageTag'

     aws inspector2 list-finding-aggregations --aggregation-type AWS_ECR_CONTAINER --aggregation-request \
     '{
         "awsEcrContainerAggregation": {
           "imageTags": [
             {
               "comparison": "EQUALS",
               "value": "'${i}'"
             }
           ],
           "repositories": [
             {
               "comparison": "EQUALS",
               "value": "'${container_array[$tag_index]}'"
             }
           ]
         }
     }' \
     | jq '.responses[0].awsEcrContainerAggregation.severityCounts'

     let tag_index++     
done