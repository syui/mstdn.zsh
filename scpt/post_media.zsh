echo $media_file
file=`zsh -c "cd $media_file;ls -A ."|peco`
file="file=$file"
media_gen=$media_file/$file
curl -sSL -F $file ${turl} -H "Authorization: Bearer $access_token"

#if [ -f $json_account ];then
#	user_id=`cat $j/accounts.json | jq -r .id`
#else
#	. $s/account.zsh
#	user_id=`cat $j/accounts.json | jq -r .id`
#fi
#user_id=`seq -f %03g $user_id`
#media_home=`cat $j/accounts.json|jq -r .avatar|cut -d 0 -f 1|sed 's/\/accounts\/avatars//g'`
#media_home=$media_home/media_attachments/files/000/000/$user_id
#
#turl="$protocol://$host/$api_url/media"
#id=`od -vAn -tx1 -N8 </dev/urandom |tr -d '[:space:]' |sed -e 'a\'`
#fid="id=$id"
#mtype=`echo 'images
#video
#gifv'|peco`
#case $mtype in
#	images)
#		f=png
#		;;
#	video)
#		f=mp4
#		;;
#	gifv)
#		f=gif
#		;;
#esac
#original=$media_home/original/$id.$f
#small=$media_home/small/$id.$f
#case $2 in
#	-d)
#		page_dir=$3
#		echo $page_dir
#		if [ -d $page_dir ] && [ ! -f $page_dir/$original ];then
#			mkdir -p {$page_dir/$media_home/original,$page_dir/$media_home/small}
#			echo "$media_gen -> $page_dir/media_attachments/files/000/000/$user_id/original/$id.$f"
#			cp -rf $media_gen $page_dir/media_attachments/files/000/000/$user_id/original/$id.$f
#			cp -rf $media_gen $page_dir/media_attachments/files/000/000/$user_id/small/$id.$f
#		fi
#	;;
#esac
#
#preview_url="preview_url=$original"
#url="url=$original"
#
#echo "[
#	{
#		\"type\":\"$mtype\",
#		\"small\":\"$small\",
#		\"original\":\"$original\"
#	}
#]"
#mtype="type=$mtype"
#
#echo "curl -sSL -F \"$fid\" -F \"$mtype\" -F \"$url\" -F \"$preview_url\" ${turl} -H \"Authorization: Bearer $access_token\" [y]"
#read key
#case $key in
#	[yY])
#		curl -sSL -F $fid -F $mtype -F $url -F $preview_url ${turl} -H "Authorization: Bearer $access_token"
#	;;
#	*)
#		exit
#	;;
#esac	
