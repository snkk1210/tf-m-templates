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
    AlarmName = message['AlarmName']
    AlarmDescription = message['AlarmDescription']
    #AWSAccountId = message['AWSAccountId']
    #AlarmConfigurationUpdatedTimestamp = message['AlarmConfigurationUpdatedTimestamp']
    NewStateValue = message['NewStateValue']
    NewStateReason = message['NewStateReason']
    #StateChangeTime = message['StateChangeTime']
    Region = message['Region']
    AlarmArn = message['AlarmArn']
    #OldStateValue = message['OldStateValue']
    #OKActions = message['OKActions']
    #AlarmActions = message['AlarmActions']
    MetricName = message['Trigger']['MetricName']
    Namespace = message['Trigger']['Namespace']
    #Statistic = message['Trigger']['Statistic']
    #Period = message['Trigger']['Period']
    #EvaluationPeriods = message['Trigger']['EvaluationPeriods']
    #DatapointsToAlarm = message['Trigger']['DatapointsToAlarm']
    #ComparisonOperator = message['Trigger']['ComparisonOperator']
    Threshold = message['Trigger']['Threshold']
    #TreatMissingData = message['Trigger']['TreatMissingData']
    #EvaluateLowSampleCountPercentile = message['Trigger']['EvaluateLowSampleCountPercentile']

    # アラート通知時
    state_color = "#FF0000"
    state_icon = ":rotating_light:"
    state = "ALARM"
    arn = AlarmArn.split(':')

    # リカバリ通知時
    if NewStateValue == "OK":
        state_color = "#00FF00"
        state_icon = ":white_check_mark:"
        state = "OK"

    # MEMO: <!channel>, <@user_id>
    slack_message = {
        "channel": CHANNEL_NAME,
        "icon_emoji": state_icon,
        "attachments": [
            {
                "mrkdwn_in": ["text"],
                "color": state_color,
                "title": "%s: %s in %s" % (state, AlarmName, Region),
                "title_link": "https://%s.console.aws.amazon.com/cloudwatch/home?region=%s#alarm:name=%s" % (arn[3], arn[3], AlarmName),
                "text": "<!here> \n %s \n *StateReason* \n ```%s```" % (AlarmDescription, NewStateReason),
                "fields": [
                    {
                        "title": "MetricName",
                        "value": MetricName,
                        "short": True
                    },
                    {
                        "title": "StateValue",
                        "value": NewStateValue,
                        "short": True
                    },
                    {
                        "title": "Namespace",
                        "value": Namespace,
                        "short": True
                    },
                    {
                        "title": "Threshold",
                        "value": Threshold,
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