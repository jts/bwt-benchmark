#! /usr/bin/perl
use strict;
use Getopt::Long;
use File::Basename;

my $reads_file = "";
GetOptions("reads=s" => \$reads_file);

die("A --reads file must be provided") if $reads_file eq "";

print_system_info();

foreach my $file (@ARGV) {
    results_for_file($file);
}

sub results_for_file
{
    my($filename) = @_;

    my $name = "";
    my $cpu_time = 0;
    my $wall_time = 0;
    my $max_memory = 0;

    my $base = basename($filename);
    my ($name) = ($base =~ /(\S*).profile/);

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
        }
    }

    printf("%10s\t%6s\t%10s\t%6s\n", $name, $cpu_time, $wall_time, kb2mb($max_memory));
    close(F);
}

sub estimate_bases_in_file
{
    my($file) = @_;

    die("Only fastq is supported") unless $file =~ /.fastq$/;
}

sub print_system_info
{
    open(P, "cat /proc/cpuinfo|");

    my $model_printed = 0;
    while(<P>) {
        if(/model name\s+:(.*)/ && !$model_printed) {

            # Remove extra whitespace from model
            my $f = join(" ", split(' ', $1));
            print "#CPU: " . $f . "\n";
            $model_printed = 1;
        }
    }
    close(P);

    open(P, "cat /proc/meminfo|");
    while(<P>) {
        if(/MemTotal:\s+(\d+)/) {
            print "#Memory: " . kb2mb($1) . "\n";
        }
    }
    close(P);
}


sub kb2mb
{
    my($kb) = @_;
    return sprintf("%.1fM", ($kb / (1024)));
}
