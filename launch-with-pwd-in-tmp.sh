#!/bin/bash

uid=$(id -u)
gid=$(id -g)

sudo docker run -it --rm \
     --user $uid:$gid \
     --mount type=bind,source="$(pwd)",target=/tmp/pwd \
     --env PS1='[gccgo-cross] \w \$ ' \
     --workdir /tmp/pwd \
     sparc-sun-solaris2.10-gccgo \
     /bin/bash
