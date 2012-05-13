#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

int console (void) {

  char *buf;
  char *now;
  int flag = 0;

  buf = (char *)malloc(128);
  if (buf == NULL) {
    printf("Memory allocation failed\n");
    exit(1);
  }

  now = buf;
  
  if (fgets(buf, 128, stdin) == NULL) {
    printf ("Loading string failed\n");
    exit(1);
  }

  if (strchr(buf, '\n') != NULL) {
    buf[strlen(buf) - 1] = '\0';
  } else {
    while(getchar() != '\n');
  }

  printf ("command name: ");

  while (*now != '\0') {
    if (*now == ' ') {
      ++now;
      if (*now == '<') { ++flag; break; }
      else { printf (" "); }
    }
    printf ("%c", *now);
    ++now;
  } 
  
  if (flag == 1) {
    printf ("\ninput: ");
    now += 2;
    while (*now != '\0') {
      printf ("%c", *now);
      ++now;
    }
  }
  else {
    printf ("\ninput: console");
  }

  printf ("\n");

  free(buf);

  return 0;
}

int main (void) {
  while (1) {
    console();
  }
}
