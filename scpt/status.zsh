if [ -f $json_account ];then
	user_id=`cat $j/accounts.json | jq -r .id`
else
	. $s/account.zsh
	user_id=`cat $j/accounts.json | jq -r .id`
fi

url="$url/accounts/$user_id/statuses?limit=40"
#echo curl -sSL $url -H "Authorization: Bearer $access_token" 
curl -sSL $url -H "Authorization: Bearer $access_token"  | jq . >! $json_account_status
#cat $json_account_status | jq .
cat $json_account_status
