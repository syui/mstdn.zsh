
host=`cat $json_user|jq -r '.host'`
app=`cat $json_user|jq -r '.app'`

curl -X POST -sS https://$host/api/v1/apps \
  -F "client_name=${app}" \
  -F "redirect_uris=urn:ietf:wg:oauth:2.0:oob" \
  -F "scopes=read write follow" >! $json_client

if ! cat $json_client| jq . > /dev/null 2>&1;then
	echo error $json_user
	exit
fi

client_id=`cat $json_client|jq -r .client_id`
client_secret=`cat $json_client|jq -r .client_secret`
scope="read write follow"

username=`cat $json_user| jq 'has("username")'`
password=`cat $json_user| jq 'has("password")'`

if [ "$username" = "true" ] && [ "$password" = "true" ];then
	username=`cat $json_user|jq -r '.username'`
	password=`cat $json_user|jq -r '.password'`

else
	echo "mastodon username (mail address) :"
	read username
	username=$username
	echo "mastodon password :"
	read password
	password=$password
fi

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
