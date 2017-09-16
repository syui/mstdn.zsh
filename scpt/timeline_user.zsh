if [ ! -f $json_account_status ];then
	. $s/status.zsh
fi

cat $json_account_status | jq -r '.[]|.content' | less

