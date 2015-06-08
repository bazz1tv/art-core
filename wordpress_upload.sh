#!/bin/bash
source scripts/aux/config.sh
#source scripts/aux/password.sh

mediafire_password=''
wordpress_password=''
include_video=''
image_location=''
x=0
while getopts "m:w:p:i:vh" opt; do
	case $opt in
		m)
			#echo 'M'
			mediafire_password="$OPTARG"
			;;
		w)
			#echo 'W'
			wordpress_password="$OPTARG"
			;;
		i)
			image_location="-i $OPTARG"
			;;
		v)
			include_video='y'
			;;
		h)
			printf 'usage:\n'
			printf -- '-m: mediafire_password\n'
			printf -- '-w: wordpress_password\n'
			exit 1
			;;
		\?)
			echo "Invalid option: -$OPTARG" >&2
			;;
		:)
			echo "Option -$OPTARG requires an argument." >&2
			;;
	esac
	#x=$((x+1))
	#shift $((OPTIND-$x))
done
shift $((OPTIND-1))

#echo $mediafire_password
#echo $wordpress_password

#echo $@
#exit

if [ "$mediafire_password" = "" ]; then
	printf "Need a mediafire password: "
	stty -echo
	trap 'stty echo' EXIT
	read mediafire_password
	stty echo
	echo
fi

if [ "$wordpress_password" = "" ]; then
	printf "Need a wordpress password: "
	stty -echo
	trap 'stty echo' EXIT
	read wordpress_password
	stty echo
	echo
fi



#echo $assword
#echo $@
#exit

for day in $@; do
	if ! [ "$include_video" = "" ]; then
		youtube_url=`scripts/query_youtube_uploaded_video_url.sh "$day"`
		printf "youtube URL: $youtube_url\n"
		video="-v $youtube_url"
	fi

mediafire_download_link=`scripts/aux/mediafire_get_download_url.sh -m $mediafire_password "$day"`
printf "mediafire_download_link: $mediafire_download_link\n"
python2.7 scripts/aux/wordpress_upload.py -p $wordpress_password $image_location $video -m "$mediafire_download_link" "$day"
done
