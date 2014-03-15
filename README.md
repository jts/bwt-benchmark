This repository contains a framework to benchmark BWT construction algorithms.

The framework will automatically download and install the required programs,
grab data from an online archive and run a series of benchmarks. You can
run the current version with the following command:

`make -f pipeline.make DATASET=ecoli`

The results can be viewed by running:

`bin/parse-results.pl --reads test/ecoli.fastq results/ecoli/*.profile`
