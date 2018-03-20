#!/usr/bin/perl -w
use strict;
use warnings;
my $VERSION="0.1";
use Data::Dumper;

my $qIndex = "/home/justin/Desktop/RNASeqProjects/Glenn_Hypoxia/kallisto/transcriptIndex";

my $mainDir = '/home/justin/Desktop/RNASeqProjects/Glenn_NO';
#
my @list = qw/SGWT0NO1-41171176
SGWT0NO2-41172197
SGWT0NO3-41148700
SGWT15NO1-41173192
SGWT15NO2-41155587
SGWT15NO3-41156547/;

foreach my $name (@list) {
	my $dir = "$mainDir/$name";
	print "$dir\n";
	my $run;
        my $run = `mkdir $dir/kallistoOut`;
	$run = "/home/justin/programs/kallisto_linux-v0.43.0/kallisto quant -t 4 -i $qIndex -o $dir/kallistoOut $dir/$name\_R1.fastq $dir/$name\_R2.fastq >$dir/kallistoOut/out.txt 2>$dir/kallistoOut/warn.txt";
	warn $run;
	my $out = `$run`;
	
}


=head1 NAME


=head1 SYNOPSIS


=head1 DESCRIPTION


=head1 SEE ALSO

	
=head1 AUTHOR


justin vaughn (jvaughn7@utk.edu)

=cut
