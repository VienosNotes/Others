#include <signal.h>

 int main()
 {
    int i;
    char buf[16];
    extern void timeout();

    signal(SIGALRM,timeout);

    alarm(5);
    printf("Input keyword : ");
    gets(buf);
    alarm(0);

    printf("end\n");
    return 1;
 }

 void
 timeout(int sig)
 {
    printf("\nSIGALRM timeout\n");
    signal(SIGALRM,timeout);
 }
