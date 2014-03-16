#! /bin/bash

IN=$1

OPT="-a BCR --output-format RLE"
echo -e "\tOptions: $OPT" 1>&2
programs/beetl/bin/beetl bwt -a BCR --input $IN --output beetl.out --output-format RLE --concatenate-output 2> beetl.stderr > beetl.stdout
