. $s/status.zsh

n=`cat $json_account_status | jq length`
n=$(($n - 1))

if [ -z "$2" ];then
	echo "["
	for ((i=0;i<=$n;i++))
	do
		if [ $i -eq 0 ];then
			cat $json_account_status| jq ".[$i]|{id,content}"
		else
			echo ,
			cat $json_account_status| jq ".[$i]|{id,content}"
		fi
		if [ $i -eq $n ];then
			echo "]"
		fi
	done
else
	tmp_json=`curl -sL $2| jq .|sed '$d'`
	if [ $? -eq 1 ];then
		echo error curl
		exit
	fi
	for ((i=0;i<=$n;i++))
	do
		echo ,
		id=`cat $json_account_status| jq ".[$i].id"`
		nu=`cat $tmp_json| jq ".[]|select(.id == \"$id\")"`
		if [ -n "$nu" ];then
			cat $json_account_status| jq ".[$i]|{id,content}"
		fi
		if [ $i -eq $n ];then
			echo "]"
		fi
	done
fi
