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

    logger.info("Event: " + str(event))

    channel_name = os.environ['channelName']
    hook_url     = generate_hook_url()
    notification_to = os.environ['notificationTo']
    message = json.loads(event['Records'][0]['Sns']['Message'])

    post_to_slack(hook_url, channel_name, notification_to, message)

def generate_hook_url():
    """
    Generate WebHookUrl from Environment Variables.

    Parameters
    ----------
    None

    Returns
    ----------
    hook_url : string
    """

    if  "hooks.slack.com" in os.environ['hookUrl']:
        logger.info("hookUrl is not Encrypted")
        logger.info("hookUrl: " + str(os.environ['hookUrl']))
        unencrypted_hook_url = os.environ['hookUrl']
        hook_url = "https://" + quote(unencrypted_hook_url)
        return hook_url
    elif "arn:aws:ssm" in os.environ['hookUrl']:
        logger.info("hookUrl is SSM Parameter Store ARN")
        logger.info("hookUrl: " + str(os.environ['hookUrl']))
        ssm_hook_url = os.environ['hookUrl'].split(':parameter')[-1]
        hook_url = "https://" + boto3.client('ssm').get_parameter(
            Name=ssm_hook_url,
            WithDecryption=True
        )['Parameter']['Value']
        return hook_url
    else:
        logger.info("hookUrl is Encrypted")
        logger.info("hookUrl: " + str(os.environ['hookUrl']))
        encrypted_hook_url = os.environ['hookUrl']
        hook_url = "https://" + boto3.client('kms').decrypt(
            CiphertextBlob=b64decode(encrypted_hook_url),
            EncryptionContext={'LambdaFunctionName': os.environ['AWS_LAMBDA_FUNCTION_NAME']}
        )['Plaintext'].decode('utf-8')
        return hook_url

def post_to_slack(hook_url, channel_name, notification_to, message):
    """
    Notify messages to Slack.

    Parameters
    ----------
    hook_url : string
        WEB Hook URL for Slack.
    channel_name : string
        Channel Name in Slack.
    message : dictionary
        Event messages to be notified to Slack.

    Returns
    ----------
    None
    """

    account = message['account']
    region = message['region']
    event_arn = message['detail']["eventArn"]
    event_type_code = message['detail']["eventTypeCode"]
    latest_description = message['detail']["eventDescription"][0]["latestDescription"]

    slack_message = {
        "channel": channel_name,
        "icon_emoji": ":x:",
        "attachments": [
            {
                "mrkdwn_in": ["text"],
                "color": "#F5A62C",
                "title": "%s: %s in %s" % (account, event_type_code, region),
                "title_link": "https://health.aws.amazon.com/health/home#/account/dashboard/scheduled-changes?eventID=%s" % (event_arn),
                "text": "<%s> \n %s \n *Description* \n ```%s```" % (notification_to, event_type_code, latest_description),
            }
        ]
    }

    req = Request(hook_url, json.dumps(slack_message).encode('utf-8'))

    try:
        response = urlopen(req)
        response.read()
        logger.info("Message posted to %s", slack_message['channel'])
    except HTTPError as e:
        logger.error("Request failed: %d %s", e.code, e.reason)
    except URLError as e:
        logger.error("Server connection failed: %s", e.reason)