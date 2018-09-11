if [ -f $json_account ];then
	user_id=`cat $json_account| jq -r .id`
else
	. $s/account.zsh
	user_id=`cat $json_account | jq -r .id`
fi

#api_option=accounts/$user_id/lists
#url=$protocol://$host/$api_url/$api_option
#curl -sS $url -H "Authorization: Bearer $access_token"

api_option=lists
url=$protocol://$host/$api_url/$api_option
body=`curl -sS $url -H "Authorization: Bearer $access_token"`
list_id=`echo $body|jq -r ".[]|.id,.title"|tr '\n' ','|sed -e 's/,$//g'`
list_id=`echo $list_id| peco|cut -d , -f 1`

api_option=accounts/$user_id/following
url=$protocol://$host/$api_url/$api_option
if [ -f $json_follow ];then
	tmp=`cat $json_follow | jq -r '.[].acct'`
	echo "$tmp"
	echo "remove $json_follow"
	echo "[y]"
	read key
	case $key in
		[yY])
			curl -sS $url -H "Authorization: Bearer $access_token" >! $json_follow
			cat $json_follow
		;;
	esac
else
	curl -sS $url -H "Authorization: Bearer $access_token" >! $json_follow
	cat $json_follow
fi

api_option=lists/$list_id/accounts
url=$protocol://$host/$api_url/$api_option
tmp=`cat $json_follow | jq -r '.[].acct'`
n=`cat $json_follow | jq length`
n=$((${n} - 1))

echo "
---
$tmp
---
add list[y]"

read key

case $key in
	[yY]) : ;;
	*) exit ;;
esac

for ((i=0;i<=$n;i++))
do
	uri=`cat $json_follow|jq -r ".[$i].id"`
	uri="account_ids=$uri"
	echo curl -sS -F $uri $url -H "Authorization: Bearer $access_token"
	#curl -sS -F $uri $url -H "Authorization: Bearer $access_token"
done
