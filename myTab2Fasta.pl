#/usr/bin/perl -l

use strict;

#------------------------------------------------------------------------------------
# myTab2Fasta.pl
# Converts a tabulated sequence file to a fasta-formatted file. Input file should
# have just two columns: ID and sequence 
# Usage: perl myTab2Fasta.pl sequencefile.tab > sequencefile.fasta
#
# May 28 2014		Lucio Navarro
#------------------------------------------------------------------------------------

open my $infile, "<", $ARGV[0], or die "Unable to open input file ($ARGV[0])\n\n";

while (my $line = <$infile>) {
	chomp $line;
	
	my ($id, $seq) = split " ", $line;
	print ">$id\n";
	print "$seq\n";
} 

close $infile;
