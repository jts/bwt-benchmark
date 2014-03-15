#! /bin/bash

IN=$1

programs/ropebwt2/ropebwt2 -tm512m -o ropebwt2.bwt $IN > ropebwt.stdout 2>ropebwt2.stderr
