SHELL=/bin/bash -o pipefail

# Do not delete intermediate files
.SECONDARY:

# Which programs do we want to run?
# There needs to be bin/install-X.sh and bin/run-X.sh for these
PROGRAMS=ropebwt ropebwt2

# The input data to use
INPUT=test/test.small.fastq

# This matches a program name like ropebwt and installs it
programs/%:
	bin/install-$*.sh

results/%.profile: programs/%
	mkdir -p results
	bin/profile.sh bin/run-$*.sh $(INPUT) 2> $@

clean-output:
	rm *.out *.stderr

clean-results:
	rm results/*
