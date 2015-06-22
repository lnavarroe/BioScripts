#!/usr/bin/perl
#-----------------------------------------------------------------------------------------
# myGetSeqByIdList_on_IndvFasta.pl
# Extract sequences from a fasta file based on a ID list text file. Each extracted 
# sequence is printed as individual fasta file: "$id.fasta".
#
# Usage: myGetSeqByIdList_on_IndvFasta.pl sequence.fasta ID.list
# 	
#
# April 30, 2014				Lucio Navarro 
#-----------------------------------------------------------------------------------------

use strict;
use feature 'state';
my @IdList;

# Open the fasta input file where ID patterns will be searched
open my $dna, "<", $ARGV[0] or die "Unable to open FASTA input $ARGV[0]\n\n";

# Use the subroutine getSequences (below) to get all sequences (id + sequence)
my $seqs = getSequences ( $dna );

# Open id-list file	
open my $list, "<", $ARGV[1] or die "Unable to open file $ARGV[1]\n\n";

while ( my $line = <$list> ) {
	chomp $line;
	push @IdList, $line;
} 

my $num_ids = @IdList; # count the number of Ids is the Id-file
 
#Read each id in the id-list
my $count = 0;
print "\nSequences found:\n\n";
foreach my $id ( @IdList ) { 
	foreach my $href ( @$seqs ) { #looping inside $seqs
		if ( $id eq $href->{id} ) {
			$count++;
			print "\t$id\n";
			open ( my $outfile, '>', "$id.fasta" );
			print $outfile ">$href->{id}\n";
			print $outfile "$href->{sequence}\n";
			close $outfile;
		} 
	}
}

print "\n$count sequences were extracted out of $num_ids Ids in the list.\n";
print "Check output-file \"selected_sequences.fasta\" for results.\n\n";

close $dna;
close $list;


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
