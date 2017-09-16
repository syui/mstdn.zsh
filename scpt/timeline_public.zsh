
url=$protocol://$host/$api_url/timelines/public
curl -sSL $url -H "Authorization: Bearer $access_token" >! $j/timelines_public.json

if [ -n "$2" ];then
	cat $j/timelines_public.json | jq ".[$2].content"
else
	cat $j/timelines_public.json | jq ".[].content"
fi
