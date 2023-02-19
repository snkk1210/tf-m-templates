import boto3
import json
import logging
import os

from base64 import b64decode
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError
from urllib.parse import quote

logger = logging.getLogger()
logger.setLevel(logging.INFO)

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
    resources = message['resources'][0]
    title = message['title']
    severity = message['severity']
    inspector_score = message['inspectorScore']
    source_url = message['sourceUrl']

    # MEMO: <!channel>, <@user_id>
    slack_message = {
        "channel": CHANNEL_NAME,
        "icon_emoji": ":rotating_light:",
        "attachments": [
            {
                "color": "#FF0000",
                "title": "ECR イメージスキャン結果に脆弱性が存在します",
                "title_link": "https://ap-northeast-1.console.aws.amazon.com/ecr/repositories?region=ap-northeast-1",
                "text": "<!here> \n *Resources* : %s \n" % (resources),
                "fields": [
                    {
                        "title": "Title",
                        "value": title,
                        "short": True
                    },
                    {
                        "title": "Severity",
                        "value": severity,
                        "short": True
                    },
                    {
                        "title": "Inspector_score",
                        "value": inspector_score,
                        "short": True
                    },
                    {
                        "title": "Source_url",
                        "value": source_url,
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