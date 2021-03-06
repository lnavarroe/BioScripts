#!/usr/bin/perl
#-----------------------------------------------------------------------------------------
# myGetSeqByIdList.pl
# Remove sequences from a fasta file based on a ID list text file. Filtered clean sequences
# are saved in file: "<infile>.filtered.fasta".
#
# Usage: myRemoveSeqByIdList.pl sequence.fasta ID.list
# 	
#
# August 4, 2015				Lucio Navarro 
#-----------------------------------------------------------------------------------------

use strict;
use feature 'state';
my @IdList;
my $count;

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

open ( my $outfile, '>', "$ARGV[0].filtered.fasta" );
 
#Read each id in the id-list
#my $count = 0;
print "\nSequences found:\n\n";
foreach my $href ( @$seqs ) { 
	my $count = 0;
	foreach my $id ( @IdList ) { #looping inside $IdList
		if ( $id eq $href->{id} ) {
			$count++;
			print "\t$id\n";
		} 
	}		
	
	if ( $count eq 0 ) {
			print $outfile ">$href->{id} $href->{documentation}\n";
			print $outfile "$href->{sequence}\n";
		} else { next; }

}

print "\n$count sequences were removed out of $num_ids Ids in the list.\n";
print "Check output-file \"$ARGV[0].filtered.fasta\" for results.\n\n";

close $dna;
close $list;
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