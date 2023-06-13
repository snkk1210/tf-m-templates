import boto3
import json
import logging
import os
import datetime

from base64 import b64decode
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError
from urllib.parse import quote

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def utc_to_jst(timestamp_utc):
    """
    @string
    UTC → JST に変換する
    """
    datetime_utc = datetime.datetime.strptime(timestamp_utc, "%Y-%m-%dT%H:%M:%SZ")
    datetime_jst = datetime_utc + datetime.timedelta(hours=9)
    timestamp_jst = datetime.datetime.strftime(datetime_jst, "%Y-%m-%d %H:%M:%S")
    return timestamp_jst

def lambda_handler(event, context):

    # CHANNEL_NAME 代入
    CHANNEL_NAME = os.environ['channelName']

    # HOOK_URL 代入
    if  "hooks.slack.com" in os.environ['kmsEncryptedHookUrl']:
        logger.info("kmsEncryptedHookUrl: " + str(os.environ['kmsEncryptedHookUrl']))
        logger.info("kmsEncryptedHookUrl is not Encrypted")
        UNENCRYPTED_HOOK_URL = os.environ['kmsEncryptedHookUrl']
        HOOK_URL = "https://" + quote(UNENCRYPTED_HOOK_URL)
    else:
        logger.info("kmsEncryptedHookUrl is Encrypted")
        logger.info("kmsEncryptedHookUrl: " + str(os.environ['kmsEncryptedHookUrl']))
        ENCRYPTED_HOOK_URL = os.environ['kmsEncryptedHookUrl']
        HOOK_URL = "https://" + boto3.client('kms').decrypt(
            CiphertextBlob=b64decode(ENCRYPTED_HOOK_URL),
            EncryptionContext={'LambdaFunctionName': os.environ['AWS_LAMBDA_FUNCTION_NAME']}
        )['Plaintext'].decode('utf-8')

    logger.info("Event: " + str(event))
    message = json.loads(event['Records'][0]['Sns']['Message'])
    logger.info("Message: " + str(message))

    # JSON をパース
    time = utc_to_jst(message['time'])
    jobArn = message['jobArn']
    jobId = message['jobId']
    jobName = message['jobName']
    jobQueue = message['jobQueue']
    status = message['status']
    statusReason = message['statusReason']
    awslogsGroup = message['awslogsGroup']
    awslogsStreamPrefix = message['awslogsStreamPrefix']

    # MEMO: <!channel>, <@user_id>
    slack_message = {
        'channel': CHANNEL_NAME,
        'icon_emoji': ':rotating_light:',
        "attachments": [
            {
                'color': '#FF0000',
                "title": "Batch の処理が失敗しました",
                "title_link": "https://ap-northeast-1.console.aws.amazon.com/batch/home?region=ap-northeast-1#dashboard",
                'text': "<!here> \n *Time* : %s \n *JobArn* : %s \n *JobId* : %s \n *JobName* : %s \n *JobQueue* : %s \n" % (time, jobArn, jobId, jobName, jobQueue),
                "fields": [
                    {
                        "title": "Status",
                        "value": status,
                        "short": True
                    },
                    {
                        "title": "StatusReason",
                        "value": statusReason,
                        "short": True
                    },
                    {
                        "title": "AwslogsGroup",
                        "value": awslogsGroup,
                        "short": True
                    },
                    {
                        "title": "AwslogsStreamPrefix",
                        "value": awslogsStreamPrefix,
                        "short": True
                    }
                ]
            }
        ]
    }

    logger.info("HOOK_URL: " + str(HOOK_URL))
    logger.info("CHANNEL_NAME: " + str(CHANNEL_NAME))

    # HTTP リクエスト発効
    req = Request(HOOK_URL, json.dumps(slack_message).encode('utf-8'))

    try:
        response = urlopen(req)
        response.read()
        logger.info("Message posted to %s", slack_message['channel'])
    except HTTPError as e:
        logger.error("Request failed: %d %s", e.code, e.reason)
    except URLError as e:
        logger.error("Server connection failed: %s", e.reason)