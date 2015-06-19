#!/bin/bash
# INPUTS
# $1 - Day#
# $2 - MediaFire URL
source scripts/aux/config.sh

while getopts "l:v:h" opt; do
	case $opt in
		l)
			mediafire_download_url="$OPTARG"
			;;
		v)
			local_video="$OPTARG"
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

day="$1"

printf "day: $day\nmediafire_url: $mediafire_download_url\nvideo_file: $local_video\n"

$YOUTUBE_UPLOAD_PREFIX/youtube-upload --title="$day" \
                 --description="https://bazzinotti.wordpress.com/

${mediafire_download_url}" \
                 --category="People & Blogs" \
                 --tags="bazz art" \
                 --client-secrets='scripts/client_secrets.json' \
                 "$local_video"
#                 --credentials-file=my_credentials.json \
