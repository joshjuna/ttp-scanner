#!/bin/bash

if [ -z "$1" ]; then
    locationId=5020
else
    locationId="$1"
fi

echo "Executing at `date` for $locationId" | tee ttp.out
result=$(curl -s 'https://ttp.cbp.dhs.gov/schedulerapi/locations/'$locationId'/slots?startTimestamp=2024-09-07T00:00&endTimestamp=2024-10-10T00%3A00')
#echo $result | jq
activeResult=$(jq -n --argjson arr "$result" '$arr | flatten | map(select(.active? and .active != 0))')
echo $activeResult | jq | tee ttp.out
length=$(jq -n --argjson arr "$activeResult" '$arr | length')
#echo $length

if [ "$length" -gt 0 ]; then
  echo $activeResult | jq  >> ttp.json
  curl 'https://api-v2.voicemonkey.io/trigger?token=e950d995ecc273aede5ecbdecfbedeb9_0a0b4df950e95ad48f9fc15fd0d1b2fe&device=high-temp';
fi
