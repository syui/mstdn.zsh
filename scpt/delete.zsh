. $s/status.zsh
api_option=`cat $json_docs|jq -r '.[]|select(.DELETE)|.[]'|cut -d / -f 4`
if [ `echo "$api_option"|wc -l` -ne 1 ];then
	api_option=`echo "$api_option" | $select_command --query statuses`
fi
tmp_id=`cat $json_account_status | jq '.[]|{id,content}'|tr -d '{' | tr -d '}' | sed -e '/^$/d' -e 's/"id": //g' -e 's/"content": //g'| perl -pe 's/,\n/,/'|$select_command|cut -d , -f 1|tr -d ' '`

url=$protocol://$host/$api_url/$api_option/$tmp_id
uri=`cat $json_account_status| jq -r ".[]|{id,content,uri}|select(.id == $tmp_id)"`
echo $uri
echo "delete [y]?"
read a
case $a in
	[yY])
		echo $url
		curl -X DELETE -sSL $url -H "Authorization: Bearer $access_token"
	;;
esac
