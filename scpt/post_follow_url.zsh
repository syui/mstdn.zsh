if [ -f $json_account ];then
	user_id=`cat $json_account| jq -r .id`
else
	. $s/account.zsh
	user_id=`cat $json_account | jq -r .id`
fi

api_option=follows
url=$protocol://$host/$api_url/$api_option

n=`cat $txt_follow| wc -l`

for ((i=1;i<=$n;i++))
do
	uri=`cat $txt_follow|awk "NR==$i"`
	uri="uri=$uri"
	curl -sS -F $uri $url -H "Authorization: Bearer $access_token"
done
