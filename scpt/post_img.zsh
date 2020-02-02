PAPERCLIP_ROOT_URL=https://github.com/syui/mstdn.page/raw/master/img/mastodon
git_home=~/heroku/mstdn-syui-merge/mstdn.page
git_dir=$git_home/img/mastodon

# img upload
api_option=media
url=$protocol://$host/$api_url/$api_option
message="file=@${2}"

#qlmanage -p ${@:2}

img_push=`curl -F $message -sS $url -H "Authorization: Bearer $access_token"`
img_id=`echo "$img_push"|jq -r .id`
img_purl=`echo "$img_push"|jq -r .preview_url`

echo $img_push

# git push	
img_dir=`echo "$img_push"|jq -r .url|cut -d / -f 10-14`
img_file=`echo "$img_push"|jq -r .url|cut -d / -f 16|cut -d '?' -f 1`
echo $img_dir
echo $img_file
mkdir -p $git_dir/$img_dir/{original,small}
echo "$git_dir/$img_dir/{original,small}/$img_file"
cp -rf $2 $git_dir/$img_dir/original/$img_file
cp -rf $2 $git_dir/$img_dir/small/$img_file

cd $git_home
git add .
git commit -m "up"
git push -f origin master

# toot post
api_option=statuses
url=$protocol://$host/$api_url/$api_option
media_ids="media_ids=${img_id}"
echo $media_ids

case $3 in
    p|-p|f|-f)
		STATUS="$4"
	;;
    *)
		STATUS="#media"
	;;
esac

curl -sSL ${url} -d "status=${STATUS}&media_ids[]=${img_id}" -H "Authorization: Bearer $access_token"

echo $img_purl|cut -d '?' -f 1
copy_img_url=`echo $img_purl|cut -d '?' -f 1|tr -d ' '|tr -d '\n'`

case $OSTYPE in
	darwin*)
		echo "${copy_img_url}"|pbcopy
	;;
	linux*)
		echo "${copy_img_url}"|xclip -i -sel c
	;;
esac

exit
