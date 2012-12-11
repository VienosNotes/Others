use Benchmark qw/cmpthese/;

cmpthese( shift, {
    ocaml => sub { system "cd .;ocaml ./std.ml" },
    mini_interp => sub { system "cd interp; ./miniocaml ./run.ml" },
    mini_compile => sub { system "cd compile; ./miniocaml ./run.ml" }
}
);
