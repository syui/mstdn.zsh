
turl="$protocol://$host/$api_url/timelines/public/?limit=40"
tjson=`curl -sSL ${turl} -H "Authorization: Bearer $access_token"`
tbody=`echo "$tjson"|jq -r '.[]|.media_attachments|.[]|{type,url,preview_url,remote_url}'`
tn=`echo "$tjson"|jq -r '.[]|.media_attachments|.[].type'|wc -l`
for ((i=1;i<=$tn;i++))
do
	type=`echo "$tjson"|jq -r ".[]|.media_attachments|.[].type"|awk "NR==$i"`
	url=`echo "$tjson"|jq -r ".[]|.media_attachments|.[].url"|awk "NR==$i"`
	preview_url=`echo "$tjson"|jq -r ".[]|.media_attachments|.[].preview_url"|awk "NR==$i"`
	remote_url=`echo "$tjson"|jq -r ".[]|.media_attachments|.[].remote_url"|awk "NR==$i"`
	if [ $i -eq 1 ] ;then
		echo "[{\"url\":\"$url\",\"preview_url\":\"$preview_url\",\"remote_url\":\"$remote_url\"}"
	else
		echo ",{\"url\":\"$url\",\"preview_url\":\"$preview_url\",\"remote_url\":\"$remote_url\"}"
	fi
	if [ $i -eq $tn ];then
		echo "]"
	fi
done >! $json_media

cat $json_media | jq .
