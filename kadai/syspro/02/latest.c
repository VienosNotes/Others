#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char           *
to_char(char *now, char *c)
{
	while (now < c) {
		printf("%c", *now);
		++now;
	}
	return now + 2;
}

int 
console(void)
{

	char           *buf;
	char           *now;
	char           *ir, *or, *pipe;

	buf = (char *) malloc(128);
	if (buf == NULL) {
		printf("Memory allocation failed\n");
		exit(1);
	}

	now = buf;

	if (fgets(buf, 128, stdin) == NULL) {
		printf("Loading string failed\n");
		exit(1);
	}

	if (strchr(buf, '\n') != NULL) {
		buf[strlen(buf) - 1] = '\0';
	}
	else {
		while (getchar() != '\n');
	}

	printf("command name: ");

	pipe = strchr(buf, '|');

	if ((ir = strchr(now, '<')) == NULL) {
		if (pipe == NULL) {
			printf("%s\n", buf);
			printf("input: console\n");
		}
		else {
			printf("\npipe: %s", now = to_char(now, pipe));
		}
	}
	else {
		now = to_char(now, ir);
		printf("\ninput: ");
		if ((or = strchr(now, '>')) == NULL) {
			if (pipe == NULL) {
				printf("%s\n", now);
			}
			else {
				now = to_char(now, pipe);
				printf("\npipe: %s\n", now);
			}
		}
		else {
			now = to_char(now, or);
			printf("\noutput: ");
			if (pipe == NULL) {
				printf("%s\n", now);
			}
			else {
				now = to_char(now, pipe);
				printf("\npipe: %s\n", now);
			}
		}
	}

	free(buf);
	return 0;
}

int 
main(void)
{
	while (1) {
		console();
	}
}
