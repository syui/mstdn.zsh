
. $s/add.so

# check 
if [ -z "$j" ];then
	echo error add.so
fi

case $1 in
	"")
		. $s/post.zsh
	;;
	select|-s|s)
		. $s/select.zsh
	;;
	status|-status)
		. $s/status.zsh
	;;
	delete|-d|d)
		. $s/delete.zsh
	;;
	timeline|-t|t)
		. $s/timeline_public.zsh
	;;
	latest|-l|l)
		. $s/timeline_latest.zsh
	;;
	app|-a|a)
		. $s/add_app.zsh
	;;
	account|-account)
		. $s/account.zsh
	;;
	docs|-docs)
		. $s/docs.zsh
	;;
	post|-p|p)
		. $s/post.zsh
	;;
	test|--test)
		. $s/test.zsh
	;;
	*)
		echo args
		echo see $readme
		cat $readme
	;;
esac

unset access_token password username
