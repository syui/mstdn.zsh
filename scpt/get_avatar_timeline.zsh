
host_meta=".well-known//webfinger?resource"


case $2 in
	public)
		turl="$protocol://$host/$api_url/timelines/public/?limit=40"
	;;
	*)
		turl="$protocol://$host/$api_url/timelines/home/?limit=40"
	;;
esac

curl -sSL $turl -H "Authorization: Bearer $access_token" >! $json_timeline

tjson=`cat $json_timeline`
tbody=`cat $json_timeline|jq -r '.[].account|{avatar,acct,url}'`
tn=`cat $json_timeline| jq -r length`
if [ "$tn" != "0" ];then
	tn=$((${tn} - 1))
fi
unset acct_tmp

for ((i=0;i<=$tn;i++))
do
	acct=`cat $json_timeline|jq -r ".[$i].account|.acct"`
	if [ $i -eq 0 ];then
		echo "[" >! $json_avatar_timeline
	fi
	if echo "$acct_tmp"|grep -v "$acct" > /dev/null 2>&1;then
		avatar=`cat $json_timeline|jq -r ".[$i].account|.avatar"`
		avatar_static=`cat $json_timeline|jq -r ".[$i].account|.avatar_static"`
		url=`cat $json_timeline|jq -r ".[$i].account|.url"|cut -d / -f -3`
		if [ "$url" != "null" ];then
			output=`curl -sSL -H "Accept: application/json" "$url/${host_meta}=acct:${acct}"|jq -r '.links|.[]|select(.type == "application/atom+xml")|.href'`
			img=`curl -sL $output | awk -vRS="</logo>" '/<logo>/{gsub(/.*<logo>|\n+/,"");print;exit}'`
			if [ $? -eq 0 ] && [ -n "$img" ];then
				if [ `cat $json_avatar_timeline|wc -l` -eq 1 ] ;then
					echo "{\"url\":\"$avatar\",\"static\":\"$avatar_static\",\"img\":\"$img\"}" >> $json_avatar_timeline
				else
					echo ",{\"url\":\"$avatar\",\"static\":\"$avatar_static\",\"img\":\"$img\"}" >> $json_avatar_timeline
				fi
			fi
		fi
		acct_tmp=`echo $acct_tmp\n$acct|sort |uniq`
	fi
done

echo "]"  >> $json_avatar_timeline

cat $json_avatar_timeline | jq .
