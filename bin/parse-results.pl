#! /usr/bin/perl
use strict;
use Getopt::Long;
use File::Basename;

my $reads_file = "";
my $fix_time_bug = 0;
GetOptions("reads=s" => \$reads_file,
           "fix-time-bug" => \$fix_time_bug);

die("A --reads file must be provided") if $reads_file eq "";

print_system_info();

my ($n_reads, $n_bases, $read_length) = estimate_sequences_in_file($reads_file);
print "# Dataset: $reads_file\n";
print "# Estimated reads: $n_reads\n";
print "# Estimated read length: $read_length\n";
print "# Estimated bases: $n_bases\n\n";
printf("%-14s\t%10s\t%8s\t%5s\t%8s\t%8s\t%s\n", "#program", "Wall time", "CPU (s)", "us/bp", "Mem (MB)", "bytes/bp", "options");

foreach my $file (@ARGV) {
    results_for_file($file, $n_bases);
}

sub results_for_file
{
    my($filename, $n_bases) = @_;

    my $name = "";
    my $cpu_time = 0;
    my $wall_time = 0;
    my $max_memory = 0;
    my $options = "";
    my $base = basename($filename);
    my ($script) = ($base =~ /(\S*).profile/);
    my ($name) = split("-", $script);    
    open(F, $filename);
    while(<F>) {
        if(/User .*: (.*)$/) {
            $cpu_time = $1;
        }
        
        if(/Elapsed .*: (.*)$/) {
            $wall_time = $1;
        }

        if(/Maximum resident .*: (.*)$/) {
            $max_memory = $1;
            $max_memory /= 4 if $fix_time_bug;
        }
        
        if(/Options: (.*)$/) {
            $options = $1;
        }

    }

    my $uspb = $cpu_time * 1000000 / $n_bases;
    my $bpb = $max_memory * 1024 / $n_bases;
    printf("%-14s\t%10s\t%8s\t%5.2f\t%8s\t%8.2f\t%s\n", $name, $wall_time, $cpu_time, $uspb, kb2mb($max_memory), $bpb, $options);
    close(F);
}

sub estimate_sequences_in_file
{
    my($file) = @_;

    die("Only fastq is supported") unless $file =~ /.fastq$/;

    my $filesize = -s $file;

    # Count the number of bytes and average read length
    # for the first and last N records of the file. We
    # use these values to estimate the total number of records in the file.
    my $read_lines = 40000;
    my $half_lines = $read_lines / 2;
    my $read_records = $read_lines / 4;
    my @lines = `head -$half_lines $file`;
    push @lines, `tail -$half_lines $file`;

    # Confirm we read "proper" fastq by checking the first
    # and third line of each record for the expected tokens
    for(my $i = 0; $i < scalar(@lines); $i += 2) {
        my $tok = ($i % 4 == 0) ? "@" : "+";
        if(substr($lines[$i],0,1) ne $tok) {
            die("Invalid FASTQ");
        }
    }

    # Count the number of bytes and bases read
    my $read_bytes = 0;
    my $read_sequence = 0;
    for(my $i = 0; $i < scalar(@lines); $i++) {
        $read_bytes += length($lines[$i]);
        $read_sequence += (length($lines[$i]) - 1) if (($i % 4) == 1);
    }
    
    my $average_bytes = $read_bytes / $read_records;
    my $average_sequence = $read_sequence / $read_records;
    my $total_records = int($filesize / $average_bytes);
    my $total_bases = int($total_records * $average_sequence);
    return ($total_records, $total_bases, $average_sequence);
}

sub print_system_info
{
    open(P, "cat /proc/cpuinfo|");

    my $model_printed = 0;
    while(<P>) {
        if(/model name\s+:(.*)/ && !$model_printed) {

            # Remove extra whitespace from model
            my $f = join(" ", split(' ', $1));
            print "# CPU: " . $f . "\n";
            $model_printed = 1;
        }
    }
    close(P);

    open(P, "cat /proc/meminfo|");
    while(<P>) {
        if(/MemTotal:\s+(\d+)/) {
            print "# Maximum Memory: " . kb2mb($1) . " MB\n";
        }
    }
    close(P);
}


sub kb2mb
{
    my($kb) = @_;
    return sprintf("%.1f", ($kb / (1024)));
}
