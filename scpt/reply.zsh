
url="$protocol://$host/$api_url/timelines/public/?limit=40"
curl -sSL $url -H "Authorization: Bearer $access_token" >! $j/timelines_public.json
api_option=statuses
url=$protocol://$host/$api_url/$api_option

if [ "$api_option" = "statuses" ] && [ -n "$2" ];then
	message="status=${@:2}"
else
	echo "send message :"
	read message
fi

message="status=$message"
reply_id="in_reply_to_id=`cat $json_timeline|jq -c  '.[]|{id,content}'|peco|cut -d '"' -f 4`"
curl -F $message -F $reply_id -sS $url -H "Authorization: Bearer $access_token"
. $s/timeline_latest.zsh
exit
