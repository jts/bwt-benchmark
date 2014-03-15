SHELL=/bin/bash -o pipefail

# Do not delete intermediate files
.SECONDARY:

# Which programs do we want to run?
PROGRAMS=ropebwt ropebwt2 beetl

# The input data to use
# This can be overridden on the command line
DATASET=test.small

#
# Build the output file names, of the form results/<dataset>/<program>.profile
# 
PROFILES := $(addsuffix .profile, $(addprefix results/$(DATASET)/, $(PROGRAMS)))
default: $(PROFILES)

#
# Download input data sets
#
test/ecoli.fastq:
	wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR314/SRR314665/SRR314665_1.fastq.gz
	wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR314/SRR314665/SRR314665_2.fastq.gz
	zcat SRR314665_1.fastq.gz SRR314665_2.fastq.gz > test/ecoli.fastq
	rm SRR314665_1.fastq.gz SRR314665_2.fastq.gz

#
# Install a BWT construction algorithm
#
programs/%:
	bin/install-$*.sh

# 
# Benchmark a program
#
results/$(DATASET)/%.profile: programs/% test/$(DATASET).fastq
	mkdir -p results/$(DATASET)
	bin/profile.sh bin/run-$*.sh test/$(DATASET).fastq 2> $@

#
# Clean up
#
clean-output:
	rm *.out *.stderr beetl.out-*

clean-results:
	rm results/*/*
