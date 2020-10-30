#!/bin/sh

mplayer tv:// -tv driver=v4l2:width=960:height=540:device=/dev/video0:fps=30:outfmt=yuy2

exit 0
