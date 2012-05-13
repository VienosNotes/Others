#include <stdio.h>

extern int mygetchar(int);

int main (void) {
  printf ("%d\n", mygetchar(3));
}
