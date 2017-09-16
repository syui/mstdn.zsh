
if [ -f $json_account ];then
	user_id=`cat $j/accounts.json | jq .id`
else
	. $s/account.zsh
	user_id=`cat $j/accounts.json | jq .id`
fi

url="$url/accounts/$user_id/statuses?limit=40"
curl -sSL $url -H "Authorization: Bearer $access_token"  | jq . >! $json_account_status
cat $json_account_status | jq .
