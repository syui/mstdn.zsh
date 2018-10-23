. $s/status.zsh > /dev/null 2>&1

n=`cat $json_account_status | jq length`
n=$(($n - 1))
echo $n

f=$d/index.html
fb=$d/index.back
jb=$d/toot.json

if [ -z "$2" ];then
	echo "[" >! $f
	for ((i=0;i<=$n;i++))
	do
		echo $i
		tnull=`cat $json_account_status| jq ".[$i].reblog"`
		if [ $i -eq 0 ];then
			if [ "$tnull" = "null" ];then
				#cat $json_account_status| jq ".[$i]|{id,content,created_at,reblog,account}"
				cat $json_account_status| jq ".[$i]|{id,content,created_at,reblog,account}" >> $f
			fi
		else
			if [ "$tnull" = "null" ];then
				echo ,
				echo , >> $f
				#cat $json_account_status| jq ".[$i]|{id,content,created_at,reblog,account}"
				cat $json_account_status| jq ".[$i]|{id,content,created_at,reblog,account}" >> $f
			fi
		fi
		if [ $i -eq $n ];then
			echo "]" >> $f
		fi
	done
else
	curl -sL $2 -o $fb
	cat $fb|sed '$d' >! $f
	if [ $? -eq 1 ];then
		echo error curl
		exit
	fi
	for ((i=0;i<=$n;i++))
	do
		echo $i
		id=`cat $json_account_status| jq ".[$i].id"`
		nu=`cat $fb| jq ".[]|select(.id == $id)"`
		if [ -z "$nu" ];then
			tnull=`cat $json_account_status| jq ".[$i].reblog"`
			if [ "$tnull" = "null" ];then
				echo ,
				echo , >> $f
				cat $json_account_status| jq ".[$i]|{id,content,created_at,reblog,account}" >> $f
				#cat $json_account_status| jq ".[$i]|{id,content,created_at,reblog,account}"
			fi
		fi
	done
	echo "]" >> $f
fi

# sort
cat $f| jq ".|sort_by(.created_at)" >! $fb
cp -rf $fb $f
if [ -f $fb ];then
	rm $fb
fi
