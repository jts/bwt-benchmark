SHELL=/bin/bash -o pipefail

# Do not delete intermediate files
.SECONDARY:

# Which programs do we want to run?
# There needs to be bin/install-X.sh and bin/run-X.sh for these
PROGRAMS=ropebwt ropebwt2 beetl

# The input data to use
INPUT=test/test.small.fastq

# This matches a program name like ropebwt and installs it
programs/%:
	bin/install-$*.sh

# Run the benchmark for a program
results/%.profile: programs/%
	mkdir -p results
	bin/profile.sh bin/run-$*.sh $(INPUT) 2> $@

# Clean things up
clean-output:
	rm *.out *.stderr beetl.out-*

clean-results:
	rm results/*
