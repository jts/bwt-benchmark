#! /bin/bash

IN=$1

programs/beetl/bin/beetl bwt --input $IN --output beetl.out --concatenate-output 2> beetl.stderr > beetl.stdout
