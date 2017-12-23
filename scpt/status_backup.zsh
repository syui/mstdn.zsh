. $s/status.zsh

n=`cat $json_account_status | jq length`
n=$(($n - 1))

if [ -z "$2" ];then
	echo "[" >! ./index.html
	for ((i=0;i<=$n;i++))
	do
		tnull=`cat $json_account_status| jq ".[$i].reblog"`
		if [ $i -eq 0 ];then
			if [ "$tnull" = "null" ];then
				cat $json_account_status| jq ".[$i]|{id,content,created_at,reblog,account}"
			fi
		else
			if [ "$tnull" = "null" ];then
				echo ,
				cat $json_account_status| jq ".[$i]|{id,content,created_at,reblog,account}"
			fi
		fi
		if [ $i -eq $n ];then
			echo "]"
		fi
	done >> ./index.html
else
	curl -sL $2| jq .  >! ./index.back
	cat ./index.back|sed '$d' >! ./index.html
	if [ $? -eq 1 ];then
		echo error curl
		exit
	fi
	for ((i=0;i<=$n;i++))
	do
		id=`cat $json_account_status| jq ".[$i].id"`
		nu=`cat ./index.back| jq ".[]|select(.id == $id)"`
		if [ -z "$nu" ];then
			tnull=`cat $json_account_status| jq ".[$i].reblog"`
			if [ "$tnull" = "null" ];then
				echo ,
				cat $json_account_status| jq ".[$i]|{id,content,created_at,reblog,account}"
			fi
		fi
	done >> ./index.html
	echo "]" >> ./index.html
fi

# sort
cat ./index.html| jq ".|sort_by(.created_at)" >! ./index.back
mv ./index.back ./index.html
if [ -f ./index.back ];then
	rm ./index.back
fi
