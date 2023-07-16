import json
import logging
import os

def lambda_handler(event, context):
    return {
        "isBase64Encoded": False,
        "statusCode": 200,
        "headers": {},
        "body": json.dumps("Hello from AWS Lambda")
    }