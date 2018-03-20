#!/usr/bin/perl -w
use strict;
use warnings;
my $VERSION="0.1";
use Data::Dumper;

use Math::Round;

my $mainDir = '/home/justin/Desktop/RNASeqProjects/Glenn_NO';
#
my @list = qw/SGWT0NO1-41171176
SGWT0NO2-41172197
SGWT0NO3-41148700
SGWT15NO1-41173192
SGWT15NO2-41155587
SGWT15NO3-41156547/;

my @sampleList = @list;
foreach (@sampleList) {
    $_ =~ s/-/_/g;
    #push(@sampleList, $n);
}

#die Dumper(@list, @sampleList);

my %genes;

# my @skipList = qw/XR_001989281.1
# XR_001989282.1
# XR_001989283.1/;
# 
# my %skipList;
# foreach (@skipList) {
#     $skipList{$_} = 1;
# }

foreach my $name (@list) {
	my $dir = "$mainDir/$name/kallistoOut";
	warn "$dir\n";
	open IN, "$dir/abundance.tsv";
	my $first = <IN>;
	while (<IN>) {
            chomp $_;
            my @s = split /\t/, $_;
            #next if $skipList{$s[0]};
            #push(@{$genes{$s[0]}}, $s[3]); 
            push(@{$genes{$s[0]}}, round($s[3])); #adds rounded estimated counts because DESeq2 does not like decimals
	}
	close IN;
}

print "geneID\t".join("\t",@sampleList)."\n";
foreach (keys %genes) {
    print "$_\t".join("\t",@{$genes{$_}})."\n";
}


=head1 NAME


=head1 SYNOPSIS


=head1 DESCRIPTION


=head1 SEE ALSO

	
=head1 AUTHOR


justin vaughn (jvaughn7@utk.edu)

=cut
