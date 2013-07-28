#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

our $WRITE = 1;
our @STOP_WORDS;

open my $fh, "<", "stop_words.txt";

while (<$fh>) {
    push @STOP_WORDS, $_;
}
close $fh;

sub extract_words {
    my $title = shift;
    my $url = shift;
    my $text = shift;
    my @words = split /[^a-zA-Z]+/, $text;
    my @nonstop = grep {
        my $ret = 1;
        for my $sw (@STOP_WORDS) {
            if ($sw  =~ /$_/i) {
                $ret = 0;
                last;
            }
        }
        $ret;
    } @words;

    my %all;
    for my $w (@nonstop) {
        $w =~ tr/A-Z/a-z/;
        if (exists $all{$w}) {
            $all{$w}++;
        } else {
            $all{$w} = 1;
        }
    }

    my @array = %all;

    if ($WRITE) {
        open my $fh, ">>", "vector.txt";
        print $fh $title . ", ";
        print $fh $url . ", ";
        print $fh join ", ", @array;
        print $fh "\n";
    }

    return {title => $title, url => $url, vector => \%all};
}

sub cosine_similarity {
  my ($vector_1, $vector_2) = @_;

  my $inner_product = 0.0;
  map {
    if ($vector_2->{$_}) {
      $inner_product += $vector_1->{$_} * $vector_2->{$_};
    }
  } keys %{$vector_1};

  my $norm_1 = 0.0;
  map {
    $norm_1 += $_ ** 2
  } values %{$vector_1};
  $norm_1 = sqrt($norm_1);

  my $norm_2 = 0.0;
  map {
    $norm_2 += $_ ** 2
  } values %{$vector_2};
  $norm_2 = sqrt($norm_2);

  return ($norm_1 && $norm_2) ? $inner_product / ($norm_1 * $norm_2) : 0.0;
}

sub read_vector {
    open my $fh, "<", "vector.txt";
    my @vector_list;
    while (<$fh>) {
        my @line = split /\s*,\s*/, $_;
        my $title = shift @line;
        my $url = shift @line;
        my %hash = @line;
        push @vector_list, {title => $title, url => $url, vector => \%hash};
    }
    close $fh;
    return @vector_list;
}

my $url = shift;
my $mode = shift;
my $res = "./resource";

mkdir $res unless -d $res;
chdir $res;

my $filename = `basename $url`;
chomp $filename;
unlink $filename if -f $filename;
system "/usr/local3/bin/wget $url";
-f $filename or exit(17);


my $text = "";
open $fh, "<", $filename;
while(<$fh>) {
    $text .= $_;
}
close $filename;


if ($mode eq "ADD") {
    $WRITE = 1;
    my $data = extract_words($filename, $url, $text);
} elsif ($mode eq "SEARCH") {
    $WRITE = 0;
    my @vector_list = read_vector();
    my $data = extract_words($filename, $url, $text);

    my @similarity;
    for my $elem (@vector_list) {
        push @similarity, {similarity => cosine_similarity($elem->{vector}, $data->{vector}), target => $elem};
    }

    my @sorted = sort { $b->{similarity} <=>  $a->{similarity}} @similarity;
    for my $sim (@sorted) {
        print "<tr><td><a href=\"" . $sim->{target}{url} . "\">" . $sim->{target}{title} . "</a></td><td>" . $sim->{similarity} . "</td></tr>\n";
    }
}



