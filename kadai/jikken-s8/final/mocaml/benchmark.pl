use Benchmark qw/cmpthese/;

cmpthese( 1, {
    ocaml => sub { system "repeat 1000 ocaml ./std.ml" },
    mini_interp => sub { system "repeat 1000 ./interp/miniocaml ./interp.ml" },
    mini_compile => sub { system "repeat 1000 ./compile/miniocaml ./compile.ml" }
}
);
