#!/usr/bin/perl

use strict;
use Data::Dumper;


if($#ARGV<2){
   die "Usage $0 <sequence FASTA file> <fold sequence coverage> <read length>\n";
}

my $fasta=$ARGV[0];
my $cov=$ARGV[1];
my $rl=$ARGV[2];

print "\nDetermining $ARGV[0] size and how many reads needed...\n";


open(IN,$fasta) || die "can't open $fasta for reading -- fatal.\n";
my $seq = "";
while(<IN>){
   chomp;
   if(/\>/){

   }else{
      $seq .= $_;
   }
}
close IN;

my $length=length($seq);

print "...done. Size is $length bp.\n";


my $numreads = int($length * $cov / $rl);
print "You are requesting $cov -fold sequence coverage of a $length genome.  Thats is $numreads reads\n";

print "Generating $numreads [unique] random numbers...\n";

srand(time() ^($$ + ($$ <<15)));

#####goes thru number $max times
my $rdm;

for (my $x=0;$x<$numreads;$x++){

   my $random_number=int(rand($length));
   #print "$random_number\n";
   my $sleep_time=rand();
   sleep($sleep_time);

   #while(defined $rdm->{$random_number}){
      $random_number=int(rand($length));
   #   print "\t$random_number\n";
      $sleep_time=rand();
      sleep($sleep_time);
   #}

   $rdm->{$random_number}++;

}

print "...done.\n";

my $ct=0;
my $read_h;

open (OUT, ">AAreadsLEN$rl-COV$cov.fa");
foreach my $coord(sort {$a<=>$b} keys %$rdm){

   my $fwd=substr($seq,$coord,$rl);
   #my $rev=reverse($fwd);
   my $iteration = $rdm->{$coord};
   for(my $i=1;$i<=$iteration;$i++){
      $ct++;
      print OUT ">cnt$ct\n$fwd\n";
   }
   #print OUT ">cnt$coord:$is\n$fwd:$rev\n";
}



close OUT;
exit;


#-----------------------
sub reverseComplement{
   $_ = shift;
   $_ = uc();
   tr/ATGC/TACG/;
   return (reverse());
}




