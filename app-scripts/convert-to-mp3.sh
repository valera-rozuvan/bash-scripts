#!/bin/bash

original_file=$1

filename=$(basename -- "${original_file}")
extension="${filename##*.}"
filename="${filename%.*}"
filename="${filename// /_}"

echo "original_file = ${original_file}"
echo "filename = ${filename}"
echo "extension = ${extension}"

# ffmpeg -t 00:54:32 -i "${original_file}" -vn -filter:a loudnorm -codec:a libmp3lame -ab 320k -ar 44100 -ac 2 -q:a 0 "${filename}.mp3"
ffmpeg -i "${original_file}" -vn -filter:a loudnorm -codec:a libmp3lame -ab 320k -ar 44100 -ac 2 -q:a 0 "${filename}.mp3"

echo "Done!"

exit 0
