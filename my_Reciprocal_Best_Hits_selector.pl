#!/user/bin/perl

##########################################################################################
# Script: my_Reciprocal_Best_Hits_selector.pl
#
# This script was built to select reciprocal best hits (RBH) based on reciprocal blast
# searches. Input must be a blast output format 6 (option -outfmt in the blast command
# lines). When running the blast searches make sure to filter for maximum one (1) target
# sequence (option -max_target_seqs in the blast command lines). 
#
#	Usage: perl my_Reciprocal_Best_Hits_selector.pl <input1.fmt6> <input2.fmt6>
#
# The final output is a tabulated file listing each pair of RBHs with some additional
# information
#
# Enjoy!!
#
# Lucio Navarro			Feb. 2016
##########################################################################################





use strict;
use Data::Dumper;

##########################################################################################

##--------------------------Parsing input files-------------------------------------------

#--- Parse input 1 ----

open my $INFILE1, "<", $ARGV[0] or die "Unable to open input file ($ARGV[0])\n\n";

print "Selecting top hits on file: $ARGV[0]\n\n";

my $data_blast1 = [];

while ( my $line = <$INFILE1> ) {
	chomp $line;
	
	my $hit = {};
	my ($query, $subj, $ident, $len_alig, $mis, $gopen, $qsta, $qend, $ssta, $send, $evl, $score ) = split " ", $line;
	
		
		$$hit{query} = $query;
		$$hit{subject} = $subj;
		$$hit{identity} = $ident;
		$$hit{lenght} = $len_alig;
		$$hit{mismatch} = $mis;
		$$hit{gapopen} = $gopen;
		$$hit{qustart} = $qsta;
		$$hit{quend} = $qend;
		$$hit{substart} = $ssta;
		$$hit{subend} = $send;
		$$hit{evalue} = $evl;
		$$hit{score} = $score;
		
		push @$data_blast1, $hit;
		
}

close $INFILE1;


open ( my $outfile1, '>', "top_hit_input1.blast" );

foreach my $i ( 0 .. $#{$data_blast1} ) {
	
	unless ( $data_blast1->[$i]->{query} eq $data_blast1->[$i-1]->{query} ) {
		print $outfile1 "$data_blast1->[$i]->{query}\t$data_blast1->[$i]->{subject}\t$data_blast1->[$i]->{identity}\t$data_blast1->[$i]->{lenght}\t$data_blast1->[$i]->{mismatch}\t$data_blast1->[$i]->{gapopen}\t$data_blast1->[$i]->{qustart}\t$data_blast1->[$i]->{quend}\t$data_blast1->[$i]->{substart}\t$data_blast1->[$i]->{subend}\t$data_blast1->[$i]->{evalue}\t$data_blast1->[$i]->{score}\n";
		
	}
}

close $outfile1;

print "Done with file: $ARGV[0]\n\n";

#--- Parse input 2 ----

open my $INFILE2, "<", $ARGV[1] or die "Unable to open input file ($ARGV[1])\n\n";

print "Selecting top hits on file: $ARGV[1]\n\n";

my $data_blast2 = [];

while ( my $line = <$INFILE2> ) {
	chomp $line;
	
	my $hit = {};
	my ($query, $subj, $ident, $len_alig, $mis, $gopen, $qsta, $qend, $ssta, $send, $evl, $score ) = split " ", $line;
	
		
		$$hit{query} = $query;
		$$hit{subject} = $subj;
		$$hit{identity} = $ident;
		$$hit{lenght} = $len_alig;
		$$hit{mismatch} = $mis;
		$$hit{gapopen} = $gopen;
		$$hit{qustart} = $qsta;
		$$hit{quend} = $qend;
		$$hit{substart} = $ssta;
		$$hit{subend} = $send;
		$$hit{evalue} = $evl;
		$$hit{score} = $score;
		
		push @$data_blast2, $hit;
		
}

close $INFILE2;

open ( my $outfile2, '>', "top_hit_input2.blast" );

foreach my $i ( 0 .. $#{$data_blast2} ) {
	
	unless ( $data_blast2->[$i]->{query} eq $data_blast2->[$i-1]->{query} ) {
		print $outfile2 "$data_blast2->[$i]->{query}\t$data_blast2->[$i]->{subject}\t$data_blast2->[$i]->{identity}\t$data_blast2->[$i]->{lenght}\t$data_blast2->[$i]->{mismatch}\t$data_blast2->[$i]->{gapopen}\t$data_blast2->[$i]->{qustart}\t$data_blast2->[$i]->{quend}\t$data_blast2->[$i]->{substart}\t$data_blast2->[$i]->{subend}\t$data_blast2->[$i]->{evalue}\t$data_blast2->[$i]->{score}\n";
		
	}
}

close $outfile2;

print "Done with file: $ARGV[1]\n\n";

##########################################################################################

##--------------------Select reciprocal best hits------------------------------------


 open(my $INFILE3, "<", "top_hit_input1.blast") 
	or die "cannot open < top_hit_input1.blast: $!";

print "Looking for reciprocal best hits in data\n\n";


my $DATA1 = [];

while ( my $line = <$INFILE3> ) {
	chomp $line;
	
	my $hit = {};
	my ($query, $subj, $ident, $len_alig, $mis, $gopen, $qsta, $qend, $ssta, $send, $evl, $score ) = split " ", $line;
	
		
		$$hit{query} = $query;
		$$hit{subject} = $subj;
		$$hit{identity} = $ident;
		$$hit{lenght} = $len_alig;
		$$hit{mismatch} = $mis;
		$$hit{gapopen} = $gopen;
		$$hit{qustart} = $qsta;
		$$hit{quend} = $qend;
		$$hit{substart} = $ssta;
		$$hit{subend} = $send;
		$$hit{evalue} = $evl;
		$$hit{score} = $score;
		
		push @$DATA1, $hit;
		
}

close $INFILE3;

open(my $INFILE4, "<", "top_hit_input2.blast") 
	or die "cannot open < top_hit_input2.blast: $!";

my $DATA2 = [];

while ( my $line = <$INFILE4> ) {
	chomp $line;
	
	my $hit = {};
	my ($query, $subj, $ident, $len_alig, $mis, $gopen, $qsta, $qend, $ssta, $send, $evl, $score ) = split " ", $line;
	
		
		$$hit{query} = $query;
		$$hit{subject} = $subj;
		$$hit{identity} = $ident;
		$$hit{lenght} = $len_alig;
		$$hit{mismatch} = $mis;
		$$hit{gapopen} = $gopen;
		$$hit{qustart} = $qsta;
		$$hit{quend} = $qend;
		$$hit{substart} = $ssta;
		$$hit{subend} = $send;
		$$hit{evalue} = $evl;
		$$hit{score} = $score;
		
		push @$DATA2, $hit;
		
}

close $INFILE4;

#create final output:

open ( my $finalout, '>', "reciprocal_best_hits_list_ouput.txt" );

print $finalout "Gene_input1\tGene_input2\tIdentity\tHit_lenght\tEvalue_1vs2\tEvalue_2vs1\n";

foreach my $j ( 0 .. $#{$DATA1} ) {

	foreach my $k ( 0 .. $#{$DATA2} ) {
	
		if (( $DATA1->[$j]->{query} eq $DATA2->[$k]->{subject} ) && ( $DATA1->[$j]->{subject} eq $DATA2->[$k]->{query} )) {
		
			print $finalout "$DATA1->[$j]->{query}\t$DATA2->[$k]->{query}\t$DATA1->[$j]->{identity}\t$DATA1->[$j]->{lenght}\t$DATA1->[$j]->{evalue}\t$DATA2->[$j]->{evalue}\n";
		}
	}
}

close $finalout;

print "Process done. Check for output file: reciprocal_best_hits_list_ouput.txt\n\n";
exit;

