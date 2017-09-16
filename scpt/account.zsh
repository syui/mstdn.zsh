host=`cat $json_user| jq -r .host`
access_token=`cat $json_token| jq -r .access_token`

api_url=`cat $json_api| jq -r '.[]|.url'`
protocol=`cat $json_api| jq -r '.[]|.protocol'`
api_option=accounts/verify_credentials
url=$protocol://$host/$api_url/$api_option
curl -sSL $url -H "Authorization: Bearer $access_token" >! $j/accounts.json
cat $j/accounts.json | jq .
