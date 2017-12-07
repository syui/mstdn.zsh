if [ -z "$2" ];then
	echo '$2=' ${0:a:h:h}/json/xxxxx.json
	echo '
[
	{
		"host":"mastodon.social",
		"app":"mstdn.zsh",
		"token":"xsiujuitejoiofdsaji",
		"client_id":"dfsjiajfiojaio",
		"client_secret":"dfjioajfoiajio"
	}
]
'
fi

json_user=$j/${2}.json
MASTODON_HOST=`cat $json_user| jq -r '.[].host'`
ACCESS_TOKEN=`cat $json_user| jq -r '.[].token'`
curl -sS https://${MASTODON_HOST}/api/v1/timelines/home --header "Authorization: Bearer ${ACCESS_TOKEN}" | jq .
