api_option=lists
url=$protocol://$host/$api_url/$api_option
body=`curl -sS $url -H "Authorization: Bearer $access_token"`
list_id=`echo $body|jq -r ".[]|.id,.title"|tr '\n' ','|sed -e 's/,$//g'`
list_id=`echo $list_id| peco|cut -d , -f 1`

api_option=lists/$list_id/accounts
url=$protocol://$host/$api_url/$api_option
curl -sS $url -H "Authorization: Bearer $access_token"

api_option=lists/$list_id
url=$protocol://$host/$api_url/$api_option

echo "delete[y]"
read k
case $k in
	y)
		curl -X DELETE -sSL $url -H "Authorization: Bearer $access_token"
	;;
esac

api_option=lists
url=$protocol://$host/$api_url/$api_option
curl -sS $url -H "Authorization: Bearer $access_token"
