import boto3
import json
import logging
import os
import datetime

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):

    logger.info("Event: " + str(event))
    message = json.loads(event['Records'][0]['Sns']['Message'])
    logger.info("Message: " + str(message))

    # S3 バケット
    S3_BUCKET_NAME = os.environ['s3BucketName']

    # S3 リージョン
    S3_BUCKET_REGION = os.environ['s3BucketRegion']

    # JSON パース
    jobName = message['jobName']

    # Flag
    dt = datetime.datetime.now()
    ymd_string = dt.strftime("%Y/%m/%d/")
    batch_flag = ymd_string + jobName

    logger.info("Flag is %s", batch_flag)
    logger.info("TimeStamp is %s", dt.strftime("%Y/%m/%d/%H/%M/%S/"))

    # S3 オブジェクト
    s3 = boto3.client("s3", region_name=S3_BUCKET_REGION)

    try:
        res = s3.put_object(
            Bucket=S3_BUCKET_NAME,
            Key=batch_flag,
        )
        logger.info("Success: %s Flag has been written.", jobName)
        logger.info("Success: %s", res)
    except Exception as e:
        logger.error("Error: %s", e)