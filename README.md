This repository contains a framework to benchmark BWT construction algorithms.

The framework will automatically download and install the required programs,
grab data from an online archive and run a series of benchmarks. You can
run the current version with the following command:

`make -f pipeline.make DATASET=ecoli`

The results can be viewed by running:

`bin/parse-results.pl --reads test/ecoli.fastq results/ecoli/*.profile`

Example output on a fairly old desktop:

```
# CPU: Intel(R) Core(TM) i5 CPU 750 @ 2.67GHz
# Maximum Memory: 16045.9 MB
# Dataset: test/ecoli.fastq
# Estimated reads: 5065461
# Estimated read length: 101
# Estimated bases: 511611561

#program      	 Wall time	 CPU (s)	us/bp	Mem (MB)	bytes/bp	options
beetl         	   1:56.26	  206.29	 0.40	   165.4	    0.34	-a BCR --output-format RLE
beetl         	   5:49.53	  190.48	 0.37	     2.1	    0.00	-a ext --output-format RLE
ropebwt2      	   0:47.94	  142.19	 0.28	   889.4	    1.82	-bRtm512m
ropebwt2      	   0:47.40	  142.22	 0.28	   888.6	    1.82	-bRtm10g
ropebwt       	   0:38.20	  100.07	 0.20	   244.0	    0.50	-bRt -a bcr
```
