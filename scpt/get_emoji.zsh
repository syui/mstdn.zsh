if [ -f $json_emoji ];then
	rm $json_emoji
fi

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
tn=`cat $json_timeline| jq -r length`
if [ "$tn" != "0" ];then
	tn=$((${tn} - 1))
fi

for ((i=0;i<=$tn;i++))
do
	emoji=`cat $json_timeline|jq -r ".[$i]|{emojis}|.[]|.[]"`
	if [ $i -eq 0 ] ;then
		echo "[" >> $json_emoji
	fi
	if [ -n "$emoji" ];then
		url=`cat $json_timeline|jq -r ".[$i].url"`
		emoji_url=`cat $json_timeline|jq -r ".[$i]|{emojis}|.[]|.[]|.url"`
		emoji_static=`cat $json_timeline|jq -r ".[$i]|{emojis}|.[]|.[]|.static_url"`
		code=`cat $json_timeline|jq -r ".[$i]|{emojis}|.[]|.[]|.shortcode"`
		img=`curl -sSL $url | grep custom_emoji | tr '"' '\n' | grep png`
		if [ `cat $json_emoji| wc -l` -eq 1 ];then
			echo "{\"url\":\"$url\",\"emoji_url\":\"$emoji_url\",\"static\":\"$emoji_static\",\"code\":\"$code\",\"img\":\"$img\"}" >> $json_emoji
		else
			echo ",{\"url\":\"$url\",\"emoji_url\":\"$emoji_url\",\"static\":\"$emoji_static\",\"code\":\"$code\",\"img\":\"$img\"}" >> $json_emoji
		fi
	fi
done

echo "]"  >> $json_emoji

cat $json_emoji | jq .
