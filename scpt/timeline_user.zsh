. $s/status.zsh
cat $json_account_status | jq '.[]|.content' | $select_command
