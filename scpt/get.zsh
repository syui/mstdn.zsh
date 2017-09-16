
api_option=`cat $json_docs|jq -r '.[]|select(.GET)|.[]'|cut -d / -f 4-|$select_command`

if echo $api_option| grep ':id' > /dev/null 2>&1;then
	echo "id : "
	read id
	api_option=`echo $api_option | sed "s/:id/$id/"`
fi

url=$protocol://$host/$api_url/$api_option

curl -sSL $url -H "Authorization: Bearer $access_token"
