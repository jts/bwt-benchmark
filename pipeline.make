SHELL=/bin/bash -o pipefail

# Do not delete intermediate files
.SECONDARY:

# Which programs do we want to install
# There must be a bin/install-X.sh script for each
INSTALL_PROGRAMS=$(addprefix programs/, ropebwt ropebwt2 beetl)

# Which programs/algorithms do we want to run
# There must be a bin/run-X.sh script for each
RUN_PROGRAMS=ropebwt ropebwt2 ropebwt2-lite beetl-bcr beetl-ext

# The input data to use
# This can be overridden on the command line
DATASET=test.small

#
# Build the output file names, of the form results/<dataset>/<program>.profile
# 
PROFILES := $(addsuffix .profile, $(addprefix results/$(DATASET)/, $(RUN_PROGRAMS)))
default: $(PROFILES)

#
# Download input data sets
#
test/ecoli.fastq:
	wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR314/SRR314665/SRR314665_1.fastq.gz
	wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR314/SRR314665/SRR314665_2.fastq.gz
	zcat SRR314665_1.fastq.gz SRR314665_2.fastq.gz > test/ecoli.fastq
	rm SRR314665_1.fastq.gz SRR314665_2.fastq.gz

test/celegans.fastq:
	wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR065/SRR065390/SRR065390_1.fastq.gz 
	wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR065/SRR065390/SRR065390_2.fastq.gz 
	zcat SRR065390_1.fastq.gz SRR065390_2.fastq.gz > test/celegans.fastq
	rm SRR065390_1.fastq.gz SRR065390_2.fastq.gz

#
# Install a BWT construction algorithm
#
programs/%:
	bin/install-$*.sh

# 
# Benchmark a program
#
results/$(DATASET)/%.profile: $(INSTALL_PROGRAMS) test/$(DATASET).fastq
	mkdir -p results/$(DATASET)
	bin/profile.sh bin/run-$*.sh test/$(DATASET).fastq 2> $@

#
# Clean up
#
clean-output:
	rm *.out *.stderr beetl.out-*

clean-results:
	rm results/*/*
