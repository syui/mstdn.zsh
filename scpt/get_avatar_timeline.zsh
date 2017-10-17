
host_meta=".well-known//webfinger?resource"

touch $json_avatar
rm $json_avatar

case $2 in
	public)
		turl=$protocol://$host/$api_url/timelines/public
	;;
	*)
		turl=$protocol://$host/$api_url/timelines/home
	;;
esac

tjson=`curl -sSL $turl -H "Authorization: Bearer $access_token"`
tbody=`echo "$tjson"|jq -r '.[].account|{avatar,acct,url}'`
tn=`echo "$tjson"| jq -r length`
if [ "$tn" != "0" ];then
	tn=$((${tn} - 1))
fi

unset acct_tmp

for ((i=0;i<=$tn;i++))
do
	acct=`echo $tjson|jq -r ".[$i].account|.acct"`
	if echo "$acct_tmp"|grep -v "$acct" > /dev/null 2>&1;then
		avatar=`echo $tjson|jq -r ".[$i].account|.avatar"`
		avatar_static=`echo $tjson|jq -r ".[$i].account|.avatar_static"`
		url=`echo $tjson|jq -r ".[$i].account|.url"|cut -d / -f -3`
		echo $url
		if [ "$url" != "null" ];then
			output=`curl -sSL -H "Accept: application/json" "$url/${host_meta}=acct:${acct}"|jq -r '.links|.[]|select(.type == "application/atom+xml")|.href'`
			img=`curl -sL $output | awk -vRS="</logo>" '/<logo>/{gsub(/.*<logo>|\n+/,"");print;exit}'`
			if [ $? -eq 0 ] && [ -n "$img" ];then
				if [ $i -eq 0 ] ;then
					echo "[{\"url\":\"$avatar\",\"static\":\"$avatar_static\",\"img\":\"$img\"}" >> $json_avatar
				else
					echo ",{\"url\":\"$avatar\",\"static\":\"$avatar_static\",\"img\":\"$img\"}" >> $json_avatar
				fi
			fi
		fi
		acct_tmp=`echo $acct_tmp\n$acct|sort |uniq`
	fi
done

echo "]"  >> $json_avatar

cat $json_avatar | jq .
