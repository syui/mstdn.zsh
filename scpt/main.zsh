
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
	notify|-n|n)
		. $s/notification.zsh
	;;
	test|--test)
		. $s/test.zsh
	;;
	usertimeline|user|-u|u)
		. $s/timeline_user.zsh
	;;
	get_avatar|g|-g)
		. $s/get_avatar.zsh
	;;
	get_avatar_timeline)
		. $s/get_avatar_timeline.zsh
	;;
	get_media)
		. $s/get_media.zsh
	;;
	get_emoji)
		. $s/get_emoji.zsh
	;;
	reply|-r|r)
		. $s/reply.zsh
	;;
	-ti|ti|timeline_imgcat)
		. $s/timeline_imgcat.zsh
	;;
	post_media)
		. $s/post_media.zsh
	;;
	*)
		echo args
		echo see $readme
		cat $readme
	;;
esac

unset access_token password username
