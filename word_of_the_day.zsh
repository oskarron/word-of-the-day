#!/bin/bash
source /etc/environment

url="https://www.merriam-webster.com/word-of-the-day"
webhook_url="$DISCORD_WEBHOOK_URL"
html=$(curl -s $url)

echo $webhook_url

word=$(echo "$html" \
  | grep "<title>Word of the Day:" \
  | sed -E 's/.*Word of the Day: ([^|]+) \| Merriam-Webster.*/\1/' \
  | head -n 1 \
  | tr -d '\n')

definition=$(echo "$html" \
  | sed -n '/<article/,/<\/article>/p' \
  | grep -m 1 '<p>' \
  | sed -E 's/<[^>]+>//g' \
  | sed -E 's/^[[:space:]]+//' \
  | tr -d '\n')


if [ -z "$word" ]; then
    echo "Failed to retrieve word of the day."
    exit 1
fi

message=$'📖 Word of the Day: **'"$word"'**\n> '"$definition"

curl -s -H "Content-Type: application/json" \
     -X POST \
     -d "{\"content\":\"$message\"}" \
     "$webhook_url"

echo "Posted to Discord."
