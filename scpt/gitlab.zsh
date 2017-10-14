
host_meta=".well-known//webfinger?resource"

surl=$protocol://$host/$api_url/accounts/1/followers
sjson=`curl -sSL $surl -H "Authorization: Bearer $access_token"`
sbody=`echo $sjson|jq -r '.[]|.acct'`
sn=`echo "$sjson" | jq length`
if [ "$sn" != "0" ];then
	sn=$((${sn} - 1))
fi

for ((i=0;i<=$sn;i++))
do
	avatar=`echo $sjson|jq -r ".[$i]|.avatar"`
	echo $avatar
	acct=`echo $sjson|jq -r ".[$i]|.acct"`
	url=`echo $sjson|jq -r ".[$i]|.url"|cut -d / -f -3`
	output=`curl -sSL -H "Accept: application/json" "$url/${host_meta}=acct:${acct}"|jq -r '.links|.[]|select(.type == "application/atom+xml")|.href'`
	curl -sL $output | awk -vRS="</logo>" '/<logo>/{gsub(/.*<logo>|\n+/,"");print;exit}'
done

gurl=$protocol://$host/$api_url/accounts/1/following
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
		curl -sL $output | awk -vRS="</logo>" '/<logo>/{gsub(/.*<logo>|\n+/,"");print;exit}'
	fi
done
