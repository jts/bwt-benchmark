#! /bin/bash

IN=$1

OPT="-bRt -a bcr"
echo -e "\tOptions: $OPT" 1>&2
programs/ropebwt/ropebwt $OPT -o ropebwt.bwt $IN > ropebwt.stdout 2>ropebwt.stderr
