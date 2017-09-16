if [ ! -f $json_account_status ];then
	. $s/status.zsh
fi

cat $json_account_status | jq '.[]|.content' | $select_command

