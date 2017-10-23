
if ! which imgcat > /dev/null ;then
	echo imgcat path
	exit
fi

url="$protocol://$host/$api_url/timelines/home/?limit=40"
curl -sSL $url -H "Authorization: Bearer $access_token" >! $json_timeline
tmp_json=`cat $json_timeline | jq -r -S ".[]|[{account,content}|{(.account.acct | tostring): .content},{(.id | tostring): .account.avatar_static}]"`

n=`cat $json_timeline|jq length`
if [ "$n" != "0" ];then
	n=$((${n} - 1))
fi

for ((i=0;i<=$n;i++))
do
	icon_u=`cat $json_timeline| jq -r ".[$i]|.account.avatar_static"`
	content=`cat $json_timeline| jq -r ".[$i]|.content"`
	acct=`cat $json_timeline| jq -r ".[$i]|.account.acct"|tr '@' '_'`
	icon_f=$img_icon/$acct
	check=0
	if [ ! -f $icon_f.png ];then
		curl -sL $icon_u -o $icon_f.png
		if [ $? -eq 0 ];then
			cd $img_icon;mogrify -resize 30x30! $icon_f.png;
		fi
		if [ $? -eq 1 ];then
			check=1
		else
			check=0
		fi
	fi
	if [ ! -f $icon_f.png ];then
		icon_f=${icon_f}-0
	fi
	if [ $check -eq 0 ];then
		imgcat $icon_f.png
	fi
	echo $acct
	echo $content
done
