if [ -f $json_account ];then
	user_id=`cat $json_account| jq -r .id`
else
	. $s/account.zsh
	user_id=`cat $json_account | jq -r .id`
fi

api_option=accounts/$user_id/followers
url=$protocol://$host/$api_url/$api_option
if [ -f $json_follower ];then
	url=$protocol://$host/$api_url/$api_option
	tmp=`cat $json_follower | jq -r '.[].acct'`
	echo "$tmp"
	echo "remove $json_follower"
	echo "[y]"
	read key
	case $key in
		[yY])
			curl -sS $url -H "Authorization: Bearer $access_token" >! $json_follower
		;;
	esac
fi

api_option=follows
url=$protocol://$host/$api_url/$api_option
tmp=`cat $json_follower | jq -r '.[].acct'`
n=`cat $json_follower | jq length`
n=$((${n} - 1))

echo "
---
$tmp
---
all follow[y]"

read key

case $key in
	[yY]) : ;;
	*) exit ;;
esac

for ((i=0;i<=$n;i++))
do
	uri=`cat $json_follower|jq -r ".[$i].acct"`
	uri="uri=$uri"
	curl -sS -F $uri $url -H "Authorization: Bearer $access_token"
done
