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
x=0
while getopts "m:w:p:i:v:h" opt; do
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
			local_video="-v $OPTARG"
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

for day in $@; do
	scripts/compress.sh $day &&
	python scripts/mediafire-cli.py --email "$MEDIAFIRE_EMAIL" --password "$mediafire_password" --debug file-upload "archives/$day.tar.xz" "mf:/one_a_day/$day.tar.xz" &&
	# Get mediafire Download URL
	mediafire_download_link=`scripts/aux/mediafire_get_download_url.sh -m $mediafire_password $day` &&
	if ! [ "$local_video" = "" ]; then
		# upload video to youtube
		scripts/youtube_upload.sh -l $mediafire_download_link $local_video
	fi &&
	# add wordpress blog post!! 
	scripts/wordpress_upload.sh -m "$mediafire_password" -w "$wordpress_password" $local_video $image_location $day &&

	echo "$day" >> successful_completion.txt
done

#mfass=''
#python mediafire-cli.py --email modmeista@gmail.com --password $mfass file-upload /tmp/derp mf:/one_a_day/derp.txt