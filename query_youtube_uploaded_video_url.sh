#!/bin/bash
# expects 1 input, day#
day="$1"
youtube_url="`python2.7 scripts/aux/query_youtube_uploaded_video.py | grep $day | cut -f2 -d' '`"
youtube_url="https://www.youtube.com/watch?v=$youtube_url"
printf "$youtube_url"