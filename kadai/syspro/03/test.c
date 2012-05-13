#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <utmpx.h>

main()
{
        struct utmpx    *up;

        while ((up = getutxent()) != NULL) {
                printf("%8.8s|%16.16s|%8.8s|%s", up->ut_user,
                    up->ut_host, up->ut_line, ctime(&up->ut_tv.tv_sec));
	}
}
