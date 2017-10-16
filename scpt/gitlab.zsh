
host_meta=".well-known//webfinger?resource"

touch $json_gitlab
rm $json_gitlab

surl=$protocol://$host/$api_url/accounts/1/following
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
	acct=`echo $sjson|jq -r ".[$i]|.acct"`
	url=`echo $sjson|jq -r ".[$i]|.url"|cut -d / -f -3`
	output=`curl -sSL -H "Accept: application/json" "$url/${host_meta}=acct:${acct}"|jq -r '.links|.[]|select(.type == "application/atom+xml")|.href'`
	img=`curl -sL $output | awk -vRS="</logo>" '/<logo>/{gsub(/.*<logo>|\n+/,"");print;exit}'`
	if [ $i -eq 0 ];then
		echo "[{\"url\":\"$avatar\",\"img\":\"$img\"}"
	else
		echo ",{\"url\":\"$avatar\",\"img\":\"$img\"}"
	fi
done >> $json_gitlab

gurl=$protocol://$host/$api_url/accounts/1/followers
gjson=`curl -sSL $gurl -H "Authorization: Bearer $access_token"`
gbody=`echo $gjson|jq -r '.[]|{avatar,acct,url}'`
gn=`echo "$gjson" | jq length`
if [ "$gn" != "0" ];then
	gn=$((${gn} - 1))
fi

for ((i=0;i<=$gn;i++))
do
	avatar=`echo $gjson|jq -r ".[$i]|.avatar"`
	acct=`echo $gjson|jq -r ".[$i]|.acct"`
	url=`echo $gjson|jq -r ".[$i]|.url"|cut -d / -f -3`
	if ! echo "$gjson"| jq -r ".[]|select(.acct == \"${acct}\")" > /dev/null 2>&1;then
		output=`curl -sSL -H "Accept: application/json" "$url/${host_meta}=acct:${acct}"|jq -r '.links|.[]|select(.type == "application/atom+xml")|.href'`
		img=`curl -sL $output | awk -vRS="</logo>" '/<logo>/{gsub(/.*<logo>|\n+/,"");print;exit}'`
		if [ $i -eq 0 ] && cat $json_gitlab| head -n 1|grep -v '[' > /dev/null 2>&1;then
			echo "{\"url\":\"$avatar\",\"img\":\"$img\"}"
		else
			echo ",{\"url\":\"$avatar\",\"img\":\"$img\"}"
		fi
	fi
done >> $json_gitlab

echo "]"  >> $json_gitlab

cat $json_gitlab | jq .
