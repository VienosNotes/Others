#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my $url = shift;
chomp $url;

my $mode = shift;
my $res = "./resource";

mkdir $res unless -d $res;
chdir $res;

my $filename = `basename $url`;
chomp $filename;
unlink $filename if -f $filename;
system "/usr/local3/bin/wget $url";
-f $filename or exit(17);

my $ppm = $filename . ".ppm";
unlink $ppm if -f $ppm;
system "/usr/local3/bin/convert $filename $ppm";

open my $bin, "<", $ppm or exit(22);
binmode $bin;

my %header;
my $c;
my $offset = 0;
while(read($bin, $c, 1)) {
    last if ((chr unpack 'c1', $c) =~ /\n/);
    $header{magic} .= chr unpack 'c1', $c;
}

while(read($bin, $c, 1)) {
    last if ((chr unpack 'c1', $c) =~ /\n/);
    $header{size} .= chr unpack 'c1', $c;
}

while(read($bin, $c, 1)) {
    last if ((chr unpack 'c1', $c) =~ /\n/);
    $header{max} .= chr unpack 'c1', $c;
}


my @color;
my $idx = 0;

while(1) {
    if (read($bin, $c, 1)) {
	my $px = [unpack 'C1', $c];
	read($bin, $c, 1);
	push(@$px, unpack 'C1', $c);
	read($bin, $c, 1);
	push(@$px, unpack 'C1', $c);
	push(@color, $px);

    } else {
	last;
    }
}
close $bin;

my %rgb;
for my $px (@color) {
    $rgb{red} += $$px[0];
    $rgb{green} += $$px[1];
    $rgb{blue} += $$px[2];
}

my $total = $rgb{red} + $rgb{green} + $rgb{blue};

eval {

    if ($mode eq "ADD") {
	open my $list, ">>", "./2_1_data.csv";
	printf $list "%s, %03f, %03f, %03f, %s\n", $filename, $rgb{red} / $total, $rgb{green} / $total, $rgb{blue} / $total, $url;
	close $list;
    } elsif ($mode eq "SEARCH") {
	printf "%s, %03f, %03f, %03f, %s\n", $filename, $rgb{red} / $total, $rgb{green} / $total, $rgb{blue} / $total, $url;
    }
};

if ($@) {
    exit(83);
}



