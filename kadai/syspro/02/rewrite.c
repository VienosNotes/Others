#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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

	char           *current = malloc(128);
	char           *current_orig = current;
	char           *mode = "command: ";

	while (*now != '\0') {
		if (*now == ' ') {
			now++;
			continue;
		}
		if (*now != '<' && *now != '>' && *now != '|') {
			*current = *now;
			current++;
		}
		else {
			printf("%s", mode);
			if (*now == '<') {
				mode = "input: ";
			}
			else if (*now == '>') {
				mode = "output: ";
			}
			else {
				mode = "pipe: ";
			}

			char           *c = current_orig;
			while (c < current) {
				putchar(*c);
				c++;
			}

			printf("\n");
			current = current_orig;
		}

		now++;
	}

	printf("%s ", mode);
	char           *c = current_orig;

	while (c < current) {
		putchar(*c);
		c++;
	}
	printf("\n");
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
