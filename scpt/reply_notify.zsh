if [ -f $json_account ];then
	user_id=`cat $j/accounts.json | jq .id`
else
	. $s/account.zsh
	user_id=`cat $j/accounts.json | jq .id`
fi

url="$url/notifications/?limit=30"
curl -sSL $url -H "Authorization: Bearer $access_token"  | jq . >! $json_notification

#url="$protocol://$host/$api_url/timelines/public/?limit=40"
#curl -sSL $url -H "Authorization: Bearer $access_token" >! $json_timeline
api_option=statuses
url=$protocol://$host/$api_url/$api_option
reply_id="in_reply_to_id=`cat $json_notification|jq -c  '.[]|{id,content,url}'|peco|cut -d '"' -f 4`"
if [ "$api_option" = "statuses" ] && [ -n "$2" ];then
	message="status=${@:2}"
else
	echo "send message : vim[Enter]"
	read k
	echo "" >! $txt_message
	vim $txt_message
	echo "upload[Enter]"
	read k
	message=`cat $txt_message`
fi
message="status=$message"
curl -F $message -F $reply_id -sS $url -H "Authorization: Bearer $access_token"
. $s/timeline_latest.zsh
