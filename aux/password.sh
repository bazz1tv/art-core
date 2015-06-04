mediafire_password=''
wordpress_password=''
while getopts "m:p:h" opt; do
	case $opt in
		m)
			mediafire_password=$OPTARG
			;;
		w)
			wordpress_password=$OPTARG
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
	shift $((OPTIND-1))
done

