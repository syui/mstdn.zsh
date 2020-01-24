
. $s/add.so

# check 
if [ -z "$j" ];then
	echo error add.so
fi

case $1 in
	"")
		cat ${0:a}|grep ". \$s"|grep -v add.so|grep -v main.zsh| cut -d / -f 2| cut -d . -f 1|peco >! $txt_main
		. $s/main.zsh `cat $txt_main`
	;;
	select|-s|s)
		. $s/select.zsh
	;;
	status|-status)
		. $s/status.zsh
	;;
	status_backup|-status_backup)
		. $s/status_backup.zsh
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
	img|-i|i)
		. $s/post_img.zsh
	;;
	imgupload|-ii|ii)
		. $s/post_img_upload.zsh
	;;
	notify|-n|n)
		. $s/notification.zsh
	;;
	test|--test)
		. $s/test.zsh
	;;
	usertimeline)
		. $s/timeline_user.zsh
	;;
	user|-u|u)
		. $s/user.zsh
	;;
	get_avatar|g|-g)
		. $s/get_avatar.zsh
	;;
	get_avatar_timeline)
		. $s/get_avatar_timeline.zsh
	;;
	get_avatar_reblog)
		. $s/get_avatar_reblog.zsh
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
	reply_notify)
		. $s/reply_notify.zsh
	;;
	-ti|ti|timeline_imgcat)
		. $s/timeline_imgcat.zsh
	;;
	post_media)
		. $s/post_media.zsh
	;;
	post_follow)
		. $s/post_follow.zsh
	;;
	post_follow_url)
		. $s/post_follow_url.zsh
	;;
	post_unfollow)
		. $s/post_unfollow.zsh
	;;
	get_avatar_following)
		. $s/get_avatar_following.zsh
	;;
	get_avatar_follower)
		. $s/get_avatar_follower.zsh
	;;
	delete_all)
		. $s/delete_all.zsh
	;;
	post_list_follow)
		. $s/post_list_follow.zsh
	;;
	delete_list)
		. $s/delete_list.zsh
	;;
	*)
		echo args
		echo see $readme
		cat $readme
	;;
esac

unset access_token password username
