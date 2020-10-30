#!/bin/bash

rsync -avzW --progress -e "ssh -p 7001" /home/user/dir1 user@192.168.0.1:/home/user
rsync -avzW --progress -e "ssh -p 7001" /home/user/dir2 user@192.168.0.1:/home/user
rsync -avzW --progress -e "ssh -p 7001" /home/user/dir3 user@192.168.0.1:/home/user

exit 0
