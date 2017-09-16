
url_docs=`cat $json_api| jq -r '.[].docs'`
url_docs=`curl -sL $url_docs`
url_get=`echo "$url_docs"|grep 'GET '`
url_post=`echo "$url_docs"|grep 'POST '`
url_delete=`echo "$url_docs"|grep 'DELETE '`
url_patch=`echo "$url_docs"|grep 'PATCH '`

echo "$url_get"
echo "$url_post"

# make json

url=`echo "$url_get"|cut -d 'G' -f 2|cut -d ' ' -f 2`
n=`echo "$url"| wc -l`
for (( i=1;i<=$n;i++ ))
do
	if [ $i -eq 1 ];then
		echo "["
	fi
	t=`echo "$url"|awk "NR==$i"`
	echo "{\"GET\":\"$t\"},"
done >! $json_docs

url=`echo "$url_delete"|cut -d 'D' -f 2|cut -d ' ' -f 2`
n=`echo "$url"| wc -l`
for (( i=1;i<=$n;i++ ))
do
	t=`echo "$url"|awk "NR==$i"`
	echo "{\"DELETE\":\"$t\"},"
done >> $json_docs

url=`echo "$url_patch"|cut -d 'P' -f 2|cut -d ' ' -f 2`
n=`echo "$url"| wc -l`
for (( i=1;i<=$n;i++ ))
do
	t=`echo "$url"|awk "NR==$i"`
	echo "{\"PATCH\":\"$t\"},"
done >> $json_docs

url=`echo "$url_post"|cut -d 'P' -f 2|cut -d ' ' -f 2`
n=`echo "$url"| wc -l`
for (( i=1;i<=$n;i++ ))
do
	t=`echo "$url"|awk "NR==$i"`
	if [ $i -eq  $n ];then
		echo "{\"POST\":\"$t\"}]"
	else
		echo "{\"POST\":\"$t\"},"
	fi
done >> $json_docs

cat $json_docs | jq .
