#! /bin/bash

IN=$1

programs/ropebwt/ropebwt -o ropebwt.out $IN 2>ropebwt.stderr
