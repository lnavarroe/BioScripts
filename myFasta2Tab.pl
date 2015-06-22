#!/usr/bin/perl
use strict;
use feature 'state';

#--------------------------------------------------------------------------------------
# Usage: perl myFasta2Tab.pl infile.fasta > outfile.tab
# It creates a tabulated sequence file from a fasta file
#
# May 28 2014		Lucio Navarro
#--------------------------------------------------------------------------------------

open my $dna, "<", $ARGV[0], or die "Unable to open input file ($ARGV[0])\n\n";

my $seqs = getSequences ( $dna );

foreach my $i ( 0 .. $#{$seqs} ) { #looping inside $seqs
	print "$seqs->[$i]->{id}\t$seqs->[$i]->{sequence}\n";
}

#---------------------------------------Subroutine---------------------------------------#

#----------------------------------------------------------------------------------------
#	getSequences:
#	
#	Read sequence in fasta format and return all sequences as a reference to an array of 
#	hashes with the keys "id", "documentation", and "sequence".
#	
#	USAGE: $ref = getSequences($dna);
#----------------------------------------------------------------------------------------
 
sub getSequences {

my ($infile) = @_;

	my $id;
	my $doc;
	my $gene;
	my @seq;
	state @seq;

	while ( my $line = <$infile> ) {	#Read fasta file
		chomp $line;
		
		if ( $line =~ /^>\s*/ ) {	# Find each sequence 
			$line =~ s/^>//;
			
			$gene = {};
			push @seq, $gene;	# Store each sequence in an array of hashes
			
			( $id, $doc ) = split " ", $line, 2;
			$$gene{id} = $id;
			$$gene{documentation} = $doc;
					        
		} else {
			$$gene{sequence} .= $line;	#Concatenate the DNA sequence for each gene
		}
	} 
	
return \@seq;

}
