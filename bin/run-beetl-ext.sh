#! /bin/bash

IN=$1

OPT="-a ext --output-format RLE"
echo -e "\tOptions: $OPT" 1>&2
programs/beetl/bin/beetl bwt --input $IN --output beetl.out $OPT 2> beetl.stderr > beetl.stdout
