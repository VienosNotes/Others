use v5.14.0;

my @array = (10, 2, 8, 9, 2, 1, 4, 7, 6, 3);
my @graph = ();
my @graph2 = ();
my $depth = 0;

say join ",", mergesort(@array);
pop @graph;
pop @graph2;

for (@graph) {
    print for @{$_}; print "\n";
}
for (reverse @graph2) {
    last if !defined $_;
    print for @{$_}; print "\n";
}

sub mergesort {
  my @array = @_;
  $depth++;
  if (defined $graph[$depth]) {
      push @{$graph[$depth]}, "[" . (join ", ", @_) . "]";
  } else {
      $graph[$depth] = ();
      push @{$graph[$depth]}, "[" . (join ", ", @_) . "]";
  }

  my $size  = $#array;
  my (@former, @latter);
  my @res;

  if ($size == 0) {
      if (defined $graph2[$depth]) {
          push @{$graph2[$depth]}, "{" . (join ", ", @array) . "}";
      } else {
          $graph2[$depth] = ();
          push @{$graph2[$depth]}, "{" . (join ", ", @array) . "}";
      }
      $depth--;
      return @array;
  } else {
    @former = mergesort(@array[0 .. $size / 2]);
    @latter = mergesort(@array[$size / 2 + 1 .. $size]);
    while (@former && @latter) {
      if ($former[0] <= $latter[0]) {
        push(@res, shift @former);
      } else {
        push(@res, shift @latter);
      }
    }
    if (@former) {
      push(@res, @former);
    } else {
      push(@res, @latter);
    }
    if (defined $graph2[$depth]) {
        push @{$graph2[$depth]}, "{" . (join ", ", @res) . "}";
    } else {
        $graph2[$depth] = ();
        push @{$graph2[$depth]}, "{" . (join ", ", @res) . "}";
    }
    $depth--;
    return @res;
  }
}
