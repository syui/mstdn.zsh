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

echo "$img_purl"|cut -d '?' -f 1

case $OSTYPE in
	darwin*)
		echo "$img_purl"|cut -d '?' -f 1|pbcopy
	 	;;
  linux*)
		echo "$img_purl"|cut -d '?' -f 1|xclip -i -sel c
		;;
esac

