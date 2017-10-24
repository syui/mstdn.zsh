
case $2 in
	public|-p|p)
		url="$protocol://$host/$api_url/timelines/public/?limit=40"
	;;
	*)
		url="$protocol://$host/$api_url/timelines/home/?limit=40"
	;;
esac

curl -sSL $url -H "Authorization: Bearer $access_token" >! $json_timeline
api_option=statuses
url=$protocol://$host/$api_url/$api_option
reply_id="in_reply_to_id=`cat $json_timeline|jq -c  '.[]|{id,content,url}'|peco|cut -d '"' -f 4`"
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
exit
