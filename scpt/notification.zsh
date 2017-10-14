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
	exit
fi

cat $json_notification| jq '.[]|[.type,.account.url,.status.uri,.status.content]'
if [ -n "$2" ];then
	echo $2
	echo "clear : \$2 = -clear, -c, c"
fi
case $2 in
	-clear|-c|c)
		url=$protocol://$host/$api_url
		url="$url/notifications/clear"
		curl -X POST -sSL $url -H "Authorization: Bearer $access_token"
	;;
esac
