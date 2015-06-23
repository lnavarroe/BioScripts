#!/usr/bin/perl

#-----------------------------------------------------------------------------------------
# myGetDNARegion.pl
# Extract a sequence region using an ID and positions.
#
# Usage: myGetDNARegion.pl -f <seq.fasta> -i <ID> -s <start_position> -e <end_position>
# Output will be in file "<ID>_<start_position>-<end_position>.fasta".
#
# June, 2014				Lucio Navarro 
#-----------------------------------------------------------------------------------------

use strict;
use Getopt::Std;
our ( $opt_s, $opt_e, $opt_f, $opt_i);
getopt ( 's:e:f:i:' );

my (%info,%sequences);
my ($name, $doc, $seq, $lines);
# Create output file names
open ( my $FASTAOUT, '>', "$opt_i-$opt_s-$opt_e.fasta" );

# Open the fasta input file where ID patterns will be searched
open my $fasta, "<", $opt_f or die "Unable to open FASTA input ($opt_f)\n\n";

while ( my $line = <$fasta> ) {
	chomp $line;
	
	if ( $line =~ /^>/ ) {						# identify sequence names
		$line =~ s/^>//;		#remove >
		
		if	($seq) {
		$info{$name} = $doc;
		$sequences{$name} = $seq;
		}
			
		($name, $doc) = split " ", $line, 2;	
		
		$seq = '';
	}
		
	else {							# other lines represent the sequences
	$lines = join '', $line;
	$lines =~ s/\s+//g; 			# remove whitespace
	$seq .= $lines; 				# add sequences
	}	
}	

$info{$name} = $doc;				
$sequences{$name} = $seq;			# add last sequence

close $fasta;

# Go though each sequence to find de ID and get the sequence region
foreach my $header ( keys %sequences ) {
	
	if ( $header eq "$opt_i" ) {
		my $start = $opt_s - 1;
		my $end = $opt_e - $start;
		my $newseq = substr $sequences{$header}, $start, $end;		# look for residues $opt_s-$opt_e
		
		print $FASTAOUT ">$header [$opt_s-$opt_e]\n";
		print $FASTAOUT "$newseq\n"
	}
}
