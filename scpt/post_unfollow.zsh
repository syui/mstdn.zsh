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
	stmp=`cat $json_follower | jq -r '.[].acct'`
	echo "remove $json_follower"
	echo "[y]"
	read key
	case $key in
		[yY])
			curl -sS $url -H "Authorization: Bearer $access_token" >! $json_follower
		;;
	esac
fi

stmp=`cat $json_follower | jq -r '.[].acct'`
api_option=accounts/$user_id/following
url=$protocol://$host/$api_url/$api_option
curl -sS $url -H "Authorization: Bearer $access_token" >! $json_following
ttmp=`cat $json_following | jq -r '.[].acct'`

tmp=`echo "$stmp\n$ttmp" | sort | uniq -u`
n=`echo "$tmp" |wc -l`

for ((i=1;i<=$n;i++))
do
	acct=`echo "$tmp"|awk "NR==$i"`
	id=`cat $json_following| jq -r ".[]|select(.acct == \"$acct\")|.id"`
	if [ -n "$id" ];then
		api_option=accounts/$id/unfollow
		url=$protocol://$host/$api_url/$api_option
		echo "unfollow $acct -> $id"
		echo "$url"
		#curl -sS $url -H "Authorization: Bearer $access_token"
	fi
done

#echo "
#---
#$tmp
#---
#all unfollow[y]"
#
#read key
#
#case $key in
#	[yY]) : ;;
#	*) exit ;;
#esac
#
#for ((i=1;i<=$n;i++))
#do
#	uri=`echo "$tmp"|awk "NR==$i"`
#	uri="uri=$uri"
#	curl -sS -F $uri $url -H "Authorization: Bearer $access_token"
#done
