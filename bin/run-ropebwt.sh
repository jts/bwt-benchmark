#! /bin/bash

IN=$1

programs/ropebwt/ropebwt -t -a bcr -o ropebwt.bwt $IN > ropebwt.stdout 2>ropebwt.stderr
