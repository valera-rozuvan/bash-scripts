#!/bin/bash

# words.txt - found at https://github.com/dwyl/english-words/blob/master/words_alpha.txt
# rnd_words.awk - found at https://github.com/valera-rozuvan/shell-script-collection/blob/master/text/rnd_words.awk
#
# NOTE: You need to have `gawk` installed for the below to work.

RND_WORDS=$(sleep 1 && cat words.txt | ./rnd_words.awk -v n=10 > rnd_words_list && cat rnd_words_list | sed 's/\s\+//g' | paste -sd' ')
echo $RND_WORDS

exit 0
