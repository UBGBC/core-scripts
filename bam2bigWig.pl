#!/usr/bin/perl

# full conversion of bam to extended (scaled) big wig files
# @author jbard
# @date 02-17-16

use strict;
use warnings;
use Getopt::Long;
use File::Basename;
use Parallel::ForkManager;
my $MAX_PROCESSES = 24;

# Pull options from command line
# The options can be used as the sort or long names with one or two dashesa
# Default output directory is the current directory
my $outdir = '';
my $processes = 1;
my $scale = 0.0;
my $split = 0;
my $bedpe = 0;
my $scaleFactor = 0.0;
my $genome = "";
my $extend = 0;
# value to extend read by (e.g read length + r = true fragment length)
my $r = 0;

# Update the variables if they are necessary
GetOptions(	'o|output-dir:s' => \$outdir,
		'p|processes:n' => \$processes,
		'scale' =>\$scale,
		'split' =>\$split,
		'g|genome:s' =>\$genome,
		'x|extend' =>\$extend,
		'r:s' =>\$r,
		'bedpe' =>\$bedpe),
	or die("Error in command line arguments\nUsage: perl bam2bigWig.pl [--processes] [--extend,--r,--scale,--split,--genome,--bedpe] --output-dir\n");

# Make sure number of processes doesn't get out of hand!
if ($processes > $MAX_PROCESSES) { $processes = $MAX_PROCESSES;}
print "Number of processes: $processes\n";

# Remaining arguments are the files to convert
my @extraArgs = @ARGV;
# Create new fork manager object
my $fm = Parallel::ForkManager->new($processes);

foreach (@extraArgs) {

# Fork process
	$fm-> start and next;
	my ($filepart,$dirpart,$extpart) = fileparse($_, qr/\.\D.*/);

# Shorten file name to everything before the first underscore if possible
	my $file = '';
	if( $filepart =~ m/(.*?)\./ ) {
		$file = $1;
		print "Shortened file name: $file\n";
	}
	else { $file = $filepart; }

# BAM TO BED
	print "Converting BAM to BED on $_ \n";
	if (!$split  && !$bedpe){
		system("bedtools bamtobed -i $_ \> $file.bed");
	} 
	elsif ($split && !$bedpe) {
		system("bedtools bamtobed -split -i $_ \> $file.bed");
	}
	elsif ($bedpe && !$split){
		system("bedtools bamtobed -bedpe -i $_ \> $file.bed");
	} 
	else {
		print "We are working on splitting the file...";
		system("bedtools bamtobed -split -bedpe -i $_ \> $file.bed");
	}

	print "Extending to true fragment lenght: $r \n";
	system("bedtools slop -i $file.bed -g $genome -l 0 -r $r -s \> $file.slop.bed");

	print "Converting from Bed to BedGraph \n";
	if ($scale){
		print "Calculating sample scale factor \n";
		my $frags = 0.0;
		my @temp = split(" ",`wc -l $file.slop.bed`);
		$frags =  $temp[0] . "\n";
                #scaling to 10 million mapped reads
		$scaleFactor = 10000000.00 / $frags;
		print "Scaling by: " . $scaleFactor . "\n";
                #converting to bedGraph
		system("bedtools genomecov -scale $scaleFactor -split -bg -i $file.slop.bed -g $genome \> $file.bedGraph");
	}
	else {
		system("bedtools genomecov -split -bg -i $file.slop.bed -g $genome \> $file.bedGraph");
	}

	print "Finalizing bigWig \n";
	system("bedGraphToBigWig $file.bedGraph $genome $file.bigWig");

        print "Removing intermediates \n";
        system("rm $file.slop.bed");
        system("rm $file.bedGraph");
        system("rm $file.bed");

# Exit the process
	$fm->finish;
}	
# Wait for all the processes to end before exiting
$fm->wait_all_children;

__END__
