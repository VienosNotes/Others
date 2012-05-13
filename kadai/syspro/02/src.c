----------------------------------------------------------------------
学籍番号: 200911434
名前: 青木大祐
課題番号：2
練習問題番号：209
題名：文字，文字列，標準入出力

以下に演習208の要求を満たすソースコードを提示する。


#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char           *
to_char(char *now, char *c)
{
	while (now < c)
	{
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
	if (buf == NULL)
	{
		printf("Memory allocation failed\n");
		exit(1);
	}

	now = buf;

	if (fgets(buf, 128, stdin) == NULL)
	{
		printf("Loading string failed\n");
		exit(1);
	}

	if (strchr(buf, '\n') != NULL)
	{
		buf[strlen(buf) - 1] = '\0';
	}
	else
	{
		while (getchar() != '\n');
	}

	printf("command name: ");

	pipe = strchr(buf, '|');

	if ((ir = strchr(now, '<')) == NULL)
	{
		if (pipe == NULL)
		{
			printf("%s\n", buf);
			printf("input: console\n");
		}
		else
		{
			printf("\npipe: %s", now = to_char(now, pipe));
		}
	}
	else
	{
		now = to_char(now, ir);
		printf("\ninput: ");
		if ((or = strchr(now, '>')) == NULL)
		{
			if (pipe == NULL)
			{
				printf("%s\n", now);
			}
			else
			{
				now = to_char(now, pipe);
				printf("\npipe: %s\n", now);
			}
		}
		else
		{
			now = to_char(now, or);
			printf("\noutput: ");
			if (pipe == NULL)
			{
				printf("%s\n", now);
			}
			else
			{
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
	while (1)
	{
		console();
	}
}


なお、このプログラムが入力として受け付けるのは128文字までのASCII文字列であり、それ以外の入力を行った場合の動作については保証しない。
以下に実行結果を示す。
$ ./a.out
hoge
command name: hoge
input: console
hoge < piyo
command name: hoge 
input: piyo
hoge < piyo | fuga
command name: hoge 
input: piyo 
pipe: fuga
hoge < piyo > fuga
command name: hoge 
input: piyo 
output: fuga
hoge < piyo > fuga | homhom
command name: hoge 
input: piyo 
output: fuga 
pipe: homhom

----------------------------------------------------------------------
