#!/bin/bash

# #############
#
# You can also add the following to your `~/.bashrc` script for greater convenience:
#
#   alias e='function _e(){ emacsclient --create-frame --quiet --no-wait "${1}" ; };_e'
#   alias mc='EDITOR=run-emacsclient mc'
#
# #############

emacsclient --create-frame --quiet --no-wait "${1}"

exit 0
