if [ -f $json_account ];then
	user_id=`cat $j/accounts.json | jq .id`
else
	. $s/account.zsh
	user_id=`cat $j/accounts.json | jq .id`
fi

url="$url/notifications/?limit=30"
curl -sSL $url -H "Authorization: Bearer $access_token"  | jq . >! $json_notification
url="$protocol://$host/$api_url/timelines/public/?limit=40"
curl -sSL $url -H "Authorization: Bearer $access_token" >! $json_timeline
api_option=statuses
url=$protocol://$host/$api_url/$api_option
reply_id=`cat $json_notification|jq -c  '.[].status|{id,content,url}'|peco|cut -d '"' -f 4`
reply_user=`cat $json_notification|jq -r ".[]|select(.id == \"$reply_id\")"`
reply_user=`echo $reply_user| jq -r .account.acct`
echo $reply_id
echo $reply_user

if [ "$api_option" = "statuses" ] && [ -n "$2" ];then
	message="status=${@:2}"
else
	echo "send message : vim[Enter]"
	read k
	echo " @${reply_user}" >! $txt_message
	vim $txt_message
	echo "upload[Enter]"
	read k
	message=`cat $txt_message`
fi
message="status=$message"
reply_id="in_reply_to_id=$reply_id"
curl -F $message -F $reply_id -sS $url -H "Authorization: Bearer $access_token"
exit
