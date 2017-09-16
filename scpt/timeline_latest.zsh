
url=$protocol://$host/$api_url/timelines/public
curl -sSL $url -H "Authorization: Bearer $access_token" >! $j/timelines_public.json
cat $j/timelines_public.json | jq '.[0].content'
