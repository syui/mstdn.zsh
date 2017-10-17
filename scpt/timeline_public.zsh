
url="$protocol://$host/$api_url/timelines/public/?limit=40"
curl -sSL $url -H "Authorization: Bearer $access_token" >! $j/timelines_public.json

if [ -n "$2" ];then
	cat $j/timelines_public.json | jq -r ".[$2]|{account,content}|{(.account.acct | tostring): .content}|@text"
else
	cat $j/timelines_public.json | jq -r ".[]|{account,content}|{(.account.acct | tostring): .content}|@text"
fi
