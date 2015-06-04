#!/bin/bash
#INPUT : DAY
source scripts/aux/config.sh

while getopts "m:h" opt; do
	case $opt in
		m)
			#echo 'M'
			mediafire_password="$OPTARG"
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

python scripts/mediafire-cli.py --email "$MEDIAFIRE_EMAIL" --password "$mediafire_password" debug-get-resource mf:/one_a_day/$day.tar.xz | grep normal_download | sed "s/.*\(http.*$day.tar.xz\).*/\1/"