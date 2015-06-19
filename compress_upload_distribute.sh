#!/bin/bash
# INPUT
# $@ = Days
source scripts/aux/config.sh
#source scripts/aux/password.sh

mediafire_password=''
wordpress_password=''
include_video=''
image_location=''
local_video=''
dont_publish=''
description=''
x=0
while getopts "d:m:w:p:i:v:hn" opt; do
	case $opt in
		d)
			description="-d \"$OPTARG\""
			;;
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
			local_video="-v $OPTARG"
			;;
		h)
			printf 'usage:\n'
			printf -- '-m: mediafire_password\n'
			printf -- '-w: wordpress_password\n'
			printf -- '-i: image file for wordpress\n'
			printf -- '-v: video file for youtube/wordpress\n'
			printf -- "-n: don't publish wordpress article\n"
			exit 1
			;;
		n)
			dont_publish='-n'
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

for day in $@; do
	scripts/compress.sh $day &&
	python scripts/mediafire-cli.py --email "$MEDIAFIRE_EMAIL" --password "$mediafire_password" --debug file-upload "archives/$day.tar.xz" "mf:/one_a_day/$day.tar.xz" &&
	# Get mediafire Download URL
	mediafire_download_link=`scripts/aux/mediafire_get_download_url.sh -m $mediafire_password $day` &&
	if ! [ "$local_video" = "" ]; then
		# upload video to youtube
		scripts/youtube_upload.sh -l $mediafire_download_link $local_video "$day" &&
		# add wordpress blog post!! 
		scripts/wordpress_upload.sh -m "$mediafire_password" -w "$wordpress_password" -v $image_location "$dont_publish" "$description" "$day"
	else
		scripts/wordpress_upload.sh -m "$mediafire_password" -w "$wordpress_password" "$image_location" "$dont_publish" "$description" "$day"
	fi &&

	echo "$day" >> successful_completion.txt
done

#mfass=''
#python mediafire-cli.py --email modmeista@gmail.com --password $mfass file-upload /tmp/derp mf:/one_a_day/derp.txt