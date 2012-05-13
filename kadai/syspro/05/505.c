#include <stdio.h>
#include <signal.h>
#include <unistd.h>

#define TIMEOUT_EXIT_STATUS -2

// static volatile sig_atomic_t toutflag;
int             toutflag;
static void     timeout(int);
int             mygetchar(int);

int 
mygetchar(int time)
{

	toutflag = 0;

	signal(SIGALRM, timeout);
	alarm(time);

	int             val = getchar();

	alarm(0);

	if (toutflag == SIGALRM)
	{
		return TIMEOUT_EXIT_STATUS;
	}
	else
	{
		return val;
	}
}

static void 
timeout(int sig)
{
	toutflag = sig;
	return;
}
