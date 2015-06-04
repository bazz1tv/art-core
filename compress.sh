#tar --exclude=".DS_Store" -jcvf Day3.tar.bz2 Day3
for day in $@; do
	echo "Compressing $day to archives/$day.tar.xz"
	if ! tar -C $day --exclude=".DS_Store" --exclude="illum" -Jvcf - $day | pv > archives/$day.tar.xz; then
		echo "!!!Problem compressing the archive!!!!"
		exit 1
	fi
done

exit $?