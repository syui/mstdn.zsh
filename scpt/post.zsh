
case $2 in
	-f)
		api_option=statuses
		url=$protocol://$host/$api_url/$api_option
		message="status=${@:3}"
		curl -F $message -sS $url -H "Authorization: Bearer $access_token"
		. $s/timeline_latest.zsh
		exit
	;;
esac

if [ "$select_command" = "peco" ];then
	api_option=`cat $json_docs|jq -r '.[]|select(.POST)|.[]'|cut -d / -f 4-|$select_command --query statuses`
else
	api_option=`cat $json_docs|jq -r '.[]|select(.POST)|.[]'|cut -d / -f 4-|$select_command`
fi

url=$protocol://$host/$api_url/timelines/public
curl -sSL $url -H "Authorization: Bearer $access_token" >! $j/timelines_public.json
cat $j/timelines_public.json | jq '.[].content'

#if echo $api_option| grep ':id' > /dev/null 2>&1;then
#	echo "id : "
#	read id
#	api_option=`echo $api_option | sed "s/:id/$id/"`
#fi

url=$protocol://$host/$api_url/$api_option

echo $url

if [ "$api_option" = "statuses" ] && [ -n "$2" ];then
	message="status=${@:2}"
	curl -F $message -sS $url -H "Authorization: Bearer $access_token"
	. $s/timeline_latest.zsh
	exit
fi

if [ "$api_option" = "statuses" ];then
	echo "send message :"
	read message
	message="status=$message"
	curl -F $message -sS $url -H "Authorization: Bearer $access_token"
	. $s/timeline_latest.zsh
else
	echo "test function ! -> statuses"
fi

