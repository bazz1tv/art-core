#!/bin/bash
## INPUT
# $@ = Days
printf "MF pass: "
stty -echo
trap 'stty echo' EXIT
read mfass
stty echo

echo

for day in $@; do
python scripts/mediafire-cli.py --email modmeista@gmail.com --password "$mfass" --debug file-upload archives/$day.tar.xz mf:/one_a_day/$day.tar.xz &&
echo "$day" >> successful_completion.txt
done
#echo "$day" >> successful_completion.txt