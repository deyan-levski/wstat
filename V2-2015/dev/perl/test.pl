#!/usr/bin/perl 

my @array = `du -sh`;
push @array, 'Moo';
foreach my $record(@array)

{

print "$record\n";

} 
