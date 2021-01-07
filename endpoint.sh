#!/bin/sh

# TODO: ability to pass region
API_ENDPOINT=https://insights-collector.eu01.nr-data.net/v1/accounts/${NEW_RELIC_ACCOUNT_ID}/events

timestamp=$(date +%s)

JSON_STRING=$( jq -n \
    --arg metric "$NEW_RELIC_METRIC_NAME" \
    --arg value "$NEW_RELIC_METRIC_VALUE" \
    --arg timestamp "${timestamp}" \
'{eventType: "Barecheck", metric: $metric, value: $value, timestamp: $timestamp}' )

echo "Sending Events..."
echo $JSON_STRING

result=$(echo $JSON_STRING  | gzip -c | \
    curl -vvv --data-binary @- -X POST \
    -H "Content-Type: application/json"\
    -H "X-Insert-Key: $NEW_RELIC_INSERT_API_KEY" \
    -H "Content-Encoding: gzip" \
    $API_ENDPOINT
)

exitStatus=$?

if [ $exitStatus -ne 0 ]; then
    echo "::error:: $result"
fi

exit $exitStatus