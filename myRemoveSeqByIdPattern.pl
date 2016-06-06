#!/usr/bin/perl
#-----------------------------------------------------------------------------------------
# myRemoveSeqByIdPattern.pl
# Remove sequences based on an ID pattern name from a fasta file. It prints a list of the
# IDs matching the pattern and a fasta file with the filtered sequences.
#
# Usage: myRemoveSeqByIdPattern.pl -p <pattern> -o <st|co|ex> -f <sequence.fasta>
# 	
#		Options (-o):
#			st		ID starts with <pattern>
#			co		ID contains <pattern>
#			ex		ID equal to exact <pattern>
#
# August 4, 2015				Lucio Navarro 
#-----------------------------------------------------------------------------------------

use strict;
use feature 'state';
use Getopt::Std;
our ( $opt_p, $opt_o, $opt_f);
getopt ( 'p:o:f:' );

# Create output file names
open ( my $IDLIST, '>', "removed_id_list.txt" );
open ( my $FASTAOUT, '>', "$opt_f.filtered.fasta" );

# Open the fasta input file where ID patterns will be searched
open my $fasta, "<", $opt_f or die "Unable to open FASTA input ($opt_f)\n\n";

# Use the subroutine getFasta (below) to get every sequence (id + sequence) from fasta
# input file as references to hashes ($seq)
while ( my $seq = getFasta( $fasta ) ) {

	my $header = $$seq{id};
	my $doc = $$seq{documentation};
	
	
	if ( $opt_o eq "st" ) {		# if using option <st> 
		if ( $header =~ /^$opt_p/ ) {
			print $IDLIST "$header\n";
			next;
		} else {
		print $FASTAOUT ">$header $doc\n";
		print $FASTAOUT "$$seq{sequence}\n";
		}
	}
	if ( $opt_o eq "co" ) {		# if using option <co> 
		if ( $header =~ m/$opt_p/ ) {
		print $IDLIST "$header\n";
		next;
		} else {
		print $FASTAOUT ">$header $doc\n";
		print $FASTAOUT "$$seq{sequence}\n";
		}
	}
	if ( $opt_o eq "ex" ) {		# if using option <ex> 
		if ( $header eq "$opt_p" ) {
		print $IDLIST "$header\n";
		next;
		} else {
		print $FASTAOUT ">$header $doc\n";
		print $FASTAOUT "$$seq{sequence}\n";
		}
	} 
	
}

#---------------------------------------Subroutine---------------------------------------#

#----------------------------------------------------------------------------------------
#	getFasta:
#	
#	Read sequence in fasta format and return each sequence as reference to a hash
#	with the keys "id" (gene name), "documentation" and "sequence".
#	
#	USAGE: $ref = getFasta($dna);
#----------------------------------------------------------------------------------------
 
sub getFasta {

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
	
	# Return each sequence as reference to a hash
	while (@seq) {
		my $sq = shift(@seq);
		if ($sq) {
			return $sq;
		} else {
			return undef;	# Return "undef" after the last sequence
		}
	} 
		
} 

exit;