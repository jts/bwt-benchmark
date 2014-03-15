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

#program	 Wall time	 CPU (s)	us/bp	Mem (MB)	bytes/bp
beetl-bcr	   2:00.50	  215.09	 0.42	   164.4	    0.34
beetl-ext	  13:06.57	  540.88	 1.06	     2.0	    0.00
ropebwt2-lite	   2:05.55	  320.30	 0.63	  1030.6	    2.11
ropebwt2	   1:54.73	  303.40	 0.59	  1753.7	    3.59
 ropebwt	   1:43.70	  214.53	 0.42	   472.0	    0.97
```
