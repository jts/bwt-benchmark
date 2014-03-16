#! /bin/bash

IN=$1

OPT="-bRtm10g"
echo -e "\tOptions: $OPT" 1>&2
programs/ropebwt2/ropebwt2 $OPT -o ropebwt2.bwt $IN > ropebwt.stdout 2>ropebwt2.stderr
