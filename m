#!/usr/bin/perl
#CODY
use strict;
use warnings;
use Socket;
my $WhatThisDoes = "ssh's to m0000000 w/just number and checks against multiple DNS suffix.";

my ($cmd,$host,$ipaddy);
my @Domains=("<internal domain names>",".<internal domain names>","");

if(!$ARGV[0]){
	&ERRORS("No params passed. Requires a host.");
}
elsif($ARGV[0] =~ m/^\d+$/){
	$host = sprintf('m%07s', $ARGV[0]); 
}
else{
	@Domains=("") if $ARGV[0] =~ m/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/; 
	$host=$ARGV[0];
}

foreach (@Domains){
	$ipaddy=gethostbyname("$host$_");
	if($ipaddy){
		$ipaddy=inet_ntoa($ipaddy);
		$cmd = "ssh -A $host$_";
		print "$cmd [$ipaddy]\n";
		exec "$cmd";
	}
}

&ERRORS("$host does not resolve.");

sub ERRORS { 
	my($tmp)=@_;
	print "ERROR:\t$tmp\n$WhatThisDoes\nSuffix Search List: [".join(' ] [ ',@Domains)."]\nExample: m 5 or m m0000005 or m0000005.FQDN.net or 10.0.0.10\n";
	exit 1; 
}
