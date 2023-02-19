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
          "title": "Batch Flag is not Found",
          "text": "<!here> \n '${1}' may not be running."
        }
      ],
    }' \
    ${WEBHOOK_URL}
}

function error2slack()
{
  /usr/bin/curl -X POST --data-urlencode \
    'payload={
      "channel": "'${CHANNEL_NAME}'", 
      "icon_emoji": ":rotating_light:", 
      "attachments": [
        {
          "color": "#FF0000",
          "title": "Batch Flag Check Script Error",
          "text": "<!here> \n '${1}'"
        }
      ],
    }' \
    ${WEBHOOK_URL}
}