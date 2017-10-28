. $s/status.zsh

api_option=`cat $json_docs|jq -r '.[]|select(.DELETE)|.[]'|cut -d / -f 4`
if [ `echo "$api_option"|wc -l` -ne 1 ];then
	api_option=`echo "$api_option" | $select_command --query statuses`
fi
tmp_id=`cat $json_account_status | jq -r '.[]|.id'`
n=`cat $json_account_status | jq length`
n=$((${n} - 1))

for ((i=0;i<=$n;i++))
do
	#id=`echo "$tmp_id"|awk "NR==$i"`
	id=`cat $json_account_status | jq -r ".[$i]|.id"`
	url=$protocol://$host/$api_url/$api_option/$id
	curl -X DELETE -sSL $url -H "Authorization: Bearer $access_token"
done
