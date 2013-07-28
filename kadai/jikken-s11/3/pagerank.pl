#!/usr/bin/perl
use strict;
use warnings;
my $delta = 1 / 100;# %

my @url_list = ();
my $matrix = [];

open my $fh, "<", shift or die "Failed to open data file.";

while(<$fh>) {
    my @column = split ',';
    my $idx = shift @column;  # index
    my $url = shift @column;  # url
    $url_list[$idx] = $url;
    my $j = 0;
    map {
        $matrix->[$j]->[$idx] = $idx == $j ? 0 : $_;
        $j++;
    } @column;
}
close $fh;

matrix_normalize($matrix);

for (1..100) {
    $matrix = matrix_double($matrix);
    last if is_converged($matrix);
}

map {
    printf "%d,%s,%f\n", $_, $url_list[$_], $matrix->[$_]->[0];
} 0..(scalar @$matrix - 1);


my $prev_matrix = undef;
sub is_converged {
    my $matrix = shift;
    unless( $prev_matrix ) {
        $prev_matrix = $matrix;
        return 0;
    }
    map {
        my $p = $prev_matrix->[$_]->[0];
        next if $p == 0;
        my $d = ( $p - $matrix->[$_]->[0] ) / $p;
        if( $delta < abs( $d ) ) {
            $prev_matrix = $matrix;
            return 0;
        }
    } 0..( scalar @$matrix - 1 );
    return 1;
}

sub matrix_normalize {
    my $matrix = shift;

    my @row_total = ();
    my $i = 0;
    map {
        my $j = 0;
        map {
            $row_total[$j] += $_;
            $j++;
        } @$_;
        $i++;
    } @$matrix;

    $i = 0;
    map {
        die "\nPage:$i has no outer link\n" if $_ == 0;
        $i++;
    } @row_total;




    $i = 0;
    map {
        my $matrix_i = $_;
        my $j = 0;
        map {
            $matrix_i->[$j] /= $row_total[$j];
            $j++;
        } @$matrix_i;
        $i++;
    } @$matrix;
}

sub matrix_double {
    my $matrix = shift;
    my $ret = [];

    my $i = 0;
    map {
        my $matrix_i = $_;
        my $j = 0;
        map {
            my $sum = 0;
            map {
                $sum += $matrix_i->[$_] * $matrix->[$_]->[$j];
                } 0..( scalar @$matrix - 1 );
                $ret->[$i]->[$j] = $sum;
            $j++;
        } @$matrix_i;
        $i++;
    } @$matrix;
    matrix_normalize( $ret );
    $ret;
}
