#!/usr/bin/perl

# Generates entries that can be pasted into a track hub
# jbard 03/19/2015

use strict;
use warnings;
use Getopt::Long;

#use File::Basename;
#use Parallel::ForkManager;
#my $MAX_PROCESSES = 1;
#my $processes = 1 ;
# Pull options from command line
# The options can be used as the sort or long names with one or two dashesa
# Default output directory is the current directory
my $group = '';
my $type ='';
# Update the variables if they are necessary
GetOptions(     
                'g|group:s' =>\$group,
                't|type:s' =>\$type),
        or die("Error in command line arguments\nUsage: perl generate-hub.pl [-g group -t type]\n");
# Make sure number of processes doesn't get out of hand!

# Remaining arguments are the files to convert
my @extraArgs = @ARGV;

#prints out in UCSC trackhub format
foreach (@extraArgs) {
        print "\n";
        print "track " . $_ . "\n";
        print "parent " . $group . "\n";
        print "visibility dense\n";
        print "bigDataUrl " . $_ . "\n";
        print "shortLabel " . $_ ." $type \n";
        print "longLabel " . $group . " " . $_ . " " . $type . "\n";
        print "type " . $type . "\n";
}
