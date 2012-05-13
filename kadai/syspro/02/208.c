#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define STR_LENGTH 128

/*
 * 現在の位置から、与えられたポインタの一つ前の文字ま
 * でを出力する関数
 */
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

	char           *buf;	/* 取得した文字列を格納するポイ�
				 * ��タ */
	char           *now;	/* 現在の位置を表現するポインタ */
	char           *ir, *or, *pipe;	/* 入力リダイレクション、出
					 * 力リダイレクション、パイ
					 * プ記号の位置を格納するポ�
					 * ��ンタ */

	/* 領域の確保 */
	buf = (char *) malloc(STR_LENGTH);
	if (buf == NULL)
	{
		printf("Memory allocation failed\n");
		exit(1);
	}

	now = buf;

	/* 文字列の取得 */
	if (fgets(buf, STR_LENGTH, stdin) == NULL)
	{
		printf("Loading string failed\n");
		exit(1);
	}

	/* 行末まで読み込めていたら改行を終端記号に置換 */
	if (strchr(buf, '\n') != NULL)
	{
		buf[strlen(buf) - 1] = '\0';
	}
	else
	{			/* 残っている入力ストリームをク�
				 * ��ア */
		while (getchar() != '\n');
	}

	printf("command name: ");

	pipe = strchr(buf, '|');

	if ((ir = strchr(now, '<')) == NULL)
	{			/* 入力リダイレクションが無い場�
				 * �� */
		if (pipe == NULL)
		{		/* パイプが無ければ残りの文字列�
				 * ��最後まで出力 */
			printf("%s\n", buf);
			printf("input: console\n");
		}
		else
		{		/* パイプが有るならパイプの直前�
				 * ��で出力し、パイプの内容を出力 */
			printf("\npipe: %s", now = to_char(now, pipe));
		}
	}
	else
	{			/* 入力リダイレクションがある場�
				 * �� */
		/* 入力リダイレクションの直前までを出力 */
		now = to_char(now, ir);
		printf("\ninput: ");
		if ((or = strchr(now, '>')) == NULL)
		{		/* 出力リダイレクションが無い場�
				 * �� */
			if (pipe == NULL)
			{	/* パイプが無い場合 */
				printf("%s\n", now);
				printf("output: console\n");
			}
			else
			{	/* パイプが有る場合 */
				printf("\npipe: %s\n", now = to_char(now, pipe));
			}
		}
		else
		{		/* 出力リダイレクションが有る場�
				 * �� */
			/*
			 * 出力リダイレクションの直前までを出
			 * 力
			 */
			now = to_char(now, or);
			printf("\noutput: ");
			if (pipe == NULL)
			{	/* パイプが無い場合 */
				printf("%s\n", now);
			}
			else
			{	/* パイプが有る場合 */
				printf("\npipe: %s\n", now = to_char(now, pipe));
			}
		}
	}
	/* 確保した領域を開放 */
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
