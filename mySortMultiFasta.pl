#!/usr/bin/perl

use strict;
use feature 'state';

#-----------------------------------------------------------------------------------------
# Script: mySortMultiFasta.pl
# Sort sequences by length from largest to smallest. Output will have the extension
# file "<input_name>.sorted.fasta"
#
# Usage: perl mySortMultiFasta.pl <input.fasta>
#
# Feb. 24 2015					Lucio Navarro
#-----------------------------------------------------------------------------------------

#Open multi-fasta input file
open my $dna, "<", $ARGV[0] or die "Unable to open FASTA input $ARGV[0]\n\n";

# Use the subroutine "getSequences" (below) to get all sequences (id + sequence)
my $seqs = getSequences ( $dna );

# Sort sequences by length (descending)
@$seqs = sort { length $b->{sequence} <=> length $a->{sequence} } @$seqs;

# Create output file
open ( my $outfile, '>', "$ARGV[0].sorted.fasta" );

# Print results in output file
foreach my $href ( @$seqs ) { #looping inside $seqs
	my $len = length $href->{sequence};
	print $outfile ">$href->{id} len=$len\n";
	print $outfile "$href->{sequence}\n";
	}
	
close $outfile;



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