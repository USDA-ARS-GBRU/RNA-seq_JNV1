#!/usr/bin/perl -w
use strict;
use warnings;
my $VERSION="0.1";
use Data::Dumper;

my $readLength = '75';

#my $readLength = shift;

my $mainDir = '/home/justin/Desktop/RNASeqProjects/Glenn_NO';
my @list = qw/SGWT0NO1-41171176
SGWT0NO2-41172197
SGWT0NO3-41148700
SGWT15NO1-41173192
SGWT15NO2-41155587
SGWT15NO3-41156547/;

foreach my $name (@list) {
	my $dir = "$mainDir/$name";
	print "$dir\n";
# 	my $run = "gunzip $dir/*.gz";
# 	#die($dir);
#  	my $out = `$run`;
# 	my $run = "cat $dir/*1_R1_001.fastq $dir/*2_R1_001.fastq $dir/*3_R1_001.fastq $dir/*4_R1_001.fastq >$dir/$name\_R1.fastq";
# 	print $run;
# 	my $out = `$run`;
# 	my $run = "cat $dir/*1_R2_001.fastq $dir/*2_R2_001.fastq $dir/*3_R2_001.fastq $dir/*4_R2_001.fastq >$dir/$name\_R2.fastq";
# 	print $run;
# 	my $out = `$run`;
# 	my $run = "rm $dir/*001.fastq";
# 	print "$run\t";
#  	my $out = `$run`;
# 	my $run = "fastx_quality_stats -i $dir/$name\_R1.fastq -o $dir/temp1.txt";
# 	warn $run;
# 	my $out = `$run`;
# 	my $run = "fastq_quality_boxplot_graph.sh -i $dir/temp1.txt -o $dir/quality1.png";
# 	warn $run;
# 	my $out = `$run`;
# 	my $run = "fastx_nucleotide_distribution_graph.sh -i $dir/temp1.txt -o $dir/nucDistr1.png";
# 	warn $run;
# 	my $out = `$run`;
# 	my $run = "fastx_quality_stats -i $dir/$name\_R2.fastq -o $dir/temp2.txt";
# 	warn $run;
# 	my $out = `$run`;
# 	my $run = "fastq_quality_boxplot_graph.sh -i $dir/temp2.txt -o $dir/quality2.png";
# 	warn $run;
# 	my $out = `$run`;
# 	my $run = "fastx_nucleotide_distribution_graph.sh -i $dir/temp2.txt -o $dir/nucDistr2.png";
# 	warn $run;
# 	my $out = `$run`;
	my $run = "fastx_trimmer -l $readLength -i $dir/$name\_R1.fastq -o $dir/temp1.fastq";
	warn $run;
	my $out = `$run`;
	my $run = "rm $dir/$name\_R1.fastq";
	warn $run;
	my $out = `$run`;
	my $run = "mv $dir/temp1.fastq $dir/$name\_R1.fastq";
	warn $run;
	my $out = `$run`;
	my $run = "fastx_trimmer -l $readLength -i $dir/$name\_R2.fastq -o $dir/temp2.fastq";
	warn $run;
	my $out = `$run`;
	my $run = "rm $dir/$name\_R2.fastq";
	warn $run;
	my $out = `$run`;
	my $run = "mv $dir/temp2.fastq $dir/$name\_R2.fastq";
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
