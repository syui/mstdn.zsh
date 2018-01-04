. $s/status.zsh

n=`cat $json_account_status | jq length`
n=$(($n - 1))

f=$d/index.html
fb=$d/index.back

if [ -z "$2" ];then
	echo "[" >! $f
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
	done >> $f
else
	curl -sL $2| jq .  >! $fb
	cat $fb|sed '$d' >! $f
	if [ $? -eq 1 ];then
		echo error curl
		exit
	fi
	for ((i=0;i<=$n;i++))
	do
		id=`cat $json_account_status| jq ".[$i].id"`
		nu=`cat $fb| jq ".[]|select(.id == $id)"`
		if [ -z "$nu" ];then
			tnull=`cat $json_account_status| jq ".[$i].reblog"`
			if [ "$tnull" = "null" ];then
				echo ,
				cat $json_account_status| jq ".[$i]|{id,content,created_at,reblog,account}"
			fi
		fi
	done >> $f
	echo "]" >> $f
fi

# sort
cat $f| jq ".|sort_by(.created_at)" >! $fb
cp -rf $fb $f
if [ -f $fb ];then
	rm $fb
fi
