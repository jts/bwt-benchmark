#! /bin/bash

IN=$1

programs/beetl/bin/beetl bwt -a BCR --no-parallel-prefetch --input $IN --output beetl.out --output-format ASCII --concatenate-output 2> beetl.stderr > beetl.stdout
