. $s/status.zsh > /dev/null 2>&1
cat $json_account_status | jq '.[]|.content' | $select_command
