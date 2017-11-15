. $s/status.zsh

n=`cat $json_account_status | jq length`
n=$(($n - 1))

if [ -z "$2" ];then
	echo "[" >! ./index.html
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
	done >> ./index.html
else
	curl -sL $2| jq . |sed '$d' >! ./index.back
	cat ./index.back >! ./index.html
	if [ $? -eq 1 ];then
		echo error curl
		exit
	fi
	for ((i=0;i<=$n;i++))
	do
		id=`cat $json_account_status| jq ".[$i].id"`
		nu=`cat ./index.back| jq ".[]|select(.id == $id)"`
		if [ -n "$nu" ];then
			echo ,
			cat $json_account_status| jq ".[$i]|{id,content}"
		fi
	done >> ./index.html
	echo "]" >> ./index.html
fi
