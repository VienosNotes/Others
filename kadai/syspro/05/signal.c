#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <signal.h>
#include <unistd.h>

int timeout;

void alarm_callback (int sig) {
  timeout = 1;
  return;
}

int mygetchar (void) {
  signal(SIGALRM, alarm_callback);

  char v;
  timeout = 0;
  alarm(5);
  v = getchar();

  if (timeout) {
    printf ("timeout!\n");
  } else {
    printf("%c", v);
  }
}

int main (void) {
  mygetchar();
}
