
if [ ! -f $json_user ];then
	echo $json_user
	cat $json_user_e
	echo "host : "
	read host
	echo "app name : "
	read app
	echo "
		{\"host\":\"$host\"},
		{\"app\":\"$app\"}
	" >! $json_user
fi

if ! cat $json_user| jq . > /dev/null 2>&1;then
	echo error $json_user
	exit
fi

host=`cat $json_user|jq -r '.host'`
app=`cat $json_user|jq -r '.app'`

if [ ! -f $json_client ];then
	curl -X POST -sS https://$host/api/v1/apps \
	  -F "client_name=${app}" \
	  -F "redirect_uris=urn:ietf:wg:oauth:2.0:oob" \
	  -F "scopes=read write follow" >! $json_client
else
	echo "delete $json_client ? [y]"
	read a
	if [ "$a" = "y" ];then
		rm $json_client
		curl -X POST -sS https://$host/api/v1/apps \
		  -F "client_name=${app}" \
		  -F "redirect_uris=urn:ietf:wg:oauth:2.0:oob" \
		  -F "scopes=read write follow" >! $json_client
	else
		exit
	fi
fi

if ! cat $json_client| jq . > /dev/null 2>&1;then
	echo error $json_user
	exit
fi

client_id=`cat $json_client|jq -r .client_id`
client_secret=`cat $json_client|jq -r .client_secret`
scope="read write follow"

echo "mastodon username (mail address) :"
read username
username=$username
echo "mastodon password :"
read password
password=$password

curl -H "Content-Type: application/json" -X POST -Ss https://$host/oauth/token \
	-d "{
		\"client_id\": \"$client_id\",
		\"client_secret\": \"$client_secret\",
		\"grant_type\": \"password\",
		\"username\": \"$username\",
		\"password\": \"$password\",
		\"scope\": \"$scope\"
	}" >! $json_token
unset username password
