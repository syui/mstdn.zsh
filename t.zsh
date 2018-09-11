#!/bin/zsh
#
d=${0:a:h}
j=$d/json/avatar.json
h=~/heroku/mstdn-syui-merge/pages.gitlab.io/public/mastodon
hg=~/heroku/mstdn-syui-merge/pages.gitlab.io
n=`cat $j| jq length`

for (( i=0;i<$n;i++ ))
do
	url=$h/`cat $j|jq -r ".[$i].url"|cut -d / -f 6-`
	static=`cat $j|jq -r ".[$i].static"|cut -d / -f 6-`
	img=`cat $j|jq -r ".[$i].img"`
	#echo $h/$url
	#echo $static
	echo $img
	if [ ! -f $url ];then 
		curl -sSL "$img" -o $url
	fi
done

cd $hg
git add .
git commit -m "img up"
git push -u origin master
