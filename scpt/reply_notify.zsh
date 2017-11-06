if [ -f $json_account ];then
	user_id=`cat $j/accounts.json | jq .id`
else
	. $s/account.zsh
	user_id=`cat $j/accounts.json | jq .id`
fi

url="$url/notifications/?limit=30"
curl -sSL $url -H "Authorization: Bearer $access_token"  | jq . >! $json_notification

if [ `cat $json_notification| jq length` -eq 1 ];then
	cat $json_notification| jq .
fi
cat $json_notification| jq '.[]|[.type,.account.url,.status.uri,.status.content]'
echo enter
read 
api_option=statuses
url=$protocol://$host/$api_url/$api_option
reply_id=`cat $json_notification|jq -c  '.[].status|{id,content,url}'|peco|cut -d '"' -f 4`
reply_tmp=`cat $json_notification|jq -r ".[].status|select(.id == \"$reply_id\")"`
reply_user=`echo $reply_tmp| jq -r .account.acct`
reply_content=`echo $reply_tmp| jq -r .content`
echo $reply_id
echo $reply_user
echo $reply_content
if [ "$api_option" = "statuses" ] && [ -n "$2" ];then
	message="status=${@:2}"
else
	echo "send message : vim[Enter]"
	read k
	echo "> ${reply_content}" >! $txt_message
	echo " @${reply_user}" >> $txt_message
	vim $txt_message
	echo "upload[y]"
	read k
	case $k in
		[yY])
			message=`cat $txt_message`
		;;
		*)
			exit
		;;
	esac
fi
message="status=$message"
reply_id="in_reply_to_id=$reply_id"
curl -F $message -F $reply_id -sS $url -H "Authorization: Bearer $access_token"
exit
