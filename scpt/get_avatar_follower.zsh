if [ -f $json_account ];then
	user_id=`cat $json_account| jq -r .id`
else
	. $s/account.zsh
	user_id=`cat $json_account | jq -r .id`
fi
host_meta=".well-known//webfinger?resource"


surl=$protocol://$host/$api_url/accounts/$user_id/followers
#surl=$protocol://$host/$api_url/accounts/1/followers
sjson=`curl -sSL $surl -H "Authorization: Bearer $access_token"`
sbody=`echo $sjson|jq -r '.[]|.acct'`
sn=`echo "$sjson" | jq length`
if [ "$sn" != "0" ];then
	sn=$((${sn} - 1))
fi

for ((i=0;i<=$sn;i++))
do
	avatar=`echo $sjson|jq -r ".[$i]|.avatar"`
	avatar_static=`echo $sjson|jq -r ".[$i]|.avatar_static"`
	acct=`echo $sjson|jq -r ".[$i]|.acct"`
	url=`echo $sjson|jq -r ".[$i]|.url"|cut -d / -f -3`
	output=`curl -sSL -H "Accept: application/json" "$url/${host_meta}=acct:${acct}"|jq -r '.links|.[]|select(.type == "application/atom+xml")|.href'`
	img=`curl -sL $output | awk -vRS="</logo>" '/<logo>/{gsub(/.*<logo>|\n+/,"");print;exit}'`
	if [ $i -eq 0 ];then
		echo "[{\"url\":\"$avatar\",\"static\":\"$avatar_static\",\"img\":\"$img\"}"
	else
		echo ",{\"url\":\"$avatar\",\"static\":\"$avatar_static\",\"img\":\"$img\"}"
	fi
done >! $json_avatar
echo "]" >> $json_avatar

cat $json_avatar | jq .
