#!/bin/bash

original_file=$1

filename=$(basename -- "${original_file}")
extension="${filename##*.}"
filename="${filename%.*}"
filename="${filename// /_}"

echo "original_file = ${original_file}"
echo "filename = ${filename}"
echo "extension = ${extension}"

ffmpeg -i "${original_file}" -vn -codec:a libmp3lame -ar 44100 -ac 2 -q:a 0 "${filename}.mp3"

echo "Done!"

exit 0
