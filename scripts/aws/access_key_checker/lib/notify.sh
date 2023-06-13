#!/usr/bin/bash

function notify2slack()
{
  /usr/bin/curl -X POST --data-urlencode \
    'payload={
      "channel": "'${CHANNEL_NAME}'", 
      "icon_emoji": ":rotating_light:", 
      "attachments": [
        {
          "color": "#FF0000",
          "title": "['${2}'] The following IAM Access Key is out of date.",
          "text": "<!here> \n '${1}'"
        }
      ],
    }' \
    ${WEBHOOK_URL}
}