#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define STR_LENGTH 128

/* ���ߤΰ��֤��顢Ϳ����줿�ݥ��󥿤ΰ������ʸ���ޤǤ���Ϥ���ؿ� */
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

	char           *buf;	/* ��������ʸ������Ǽ����ݥ��� */
	char           *now;	/* ���ߤΰ��֤�ɽ������ݥ��� */
	char           *ir, *or, *pipe;	/* ���ϥ�����쥯����󡢽��ϥ�����쥯�����
					 * �ѥ��׵���ΰ��֤��Ǽ����ݥ���
					 * /

	/* �ΰ�γ��� */
	buf = (char *) malloc(STR_LENGTH);
	if (buf == NULL)
	{
		printf("Memory allocation failed\n");
		exit(1);
	}

	now = buf;

	/* ʸ����μ��� */
	if (fgets(buf, STR_LENGTH, stdin) == NULL)
	{
		printf("Loading string failed\n");
		exit(1);
	}

	/* �����ޤ��ɤ߹���Ƥ�������Ԥ�ü������ִ� */
	if (strchr(buf, '\n') != NULL)
	{
		buf[strlen(buf) - 1] = '\0';
	}
	else
	{			/* �ĤäƤ������ϥ��ȥ꡼��򥯥ꥢ */
		while (getchar() != '\n');
	}

	printf("command name: ");

	pipe = strchr(buf, '|');

	if ((ir = strchr(now, '<')) == NULL)
	{			/* ���ϥ�����쥯�����̵����� */
		if (pipe == NULL)
		{		/* �ѥ��פ�̵����лĤ��ʸ�����Ǹ�ޤǽ��� */
			printf("%s\n", buf);
			printf("input: console\n");
			printf("output: console\n");
		}
		else
		{		/* �ѥ��פ�ͭ��ʤ�ѥ��פ�ľ���ޤǽ��Ϥ���
				 * �ѥ��פ����Ƥ�ɽ�� */
		        printf("output: console\n");
			printf("\npipe: %s", now = to_char(now, pipe));
		}
	}
	else
	{			/* ���ϥ�����쥯����󤬤����� */
		/* ���ϥ�����쥯������ľ���ޤǤ���� */
		now = to_char(now, ir);
		printf("\ninput: ");
		if ((or = strchr(now, '>')) == NULL)
		{		/* ���ϥ�����쥯�����̵����� */
			if (pipe == NULL)
			{	/* �ѥ��פ�̵����� */
				printf("%s\n", now);
				printf("output: console\n");
			}
			else
			{	/* �ѥ��פ�ͭ���� */
				printf("\npipe: %s\n", now = to_char(now, pipe));
			}
		}
		else
		{		/* ���ϥ�����쥯�����ͭ���� */
			/* ���ϥ�����쥯������ľ���ޤǤ���� */
			now = to_char(now, or);
			printf("\noutput: ");
			if (pipe == NULL)
			{	/* �ѥ��פ�̵����� */
				printf("%s\n", now);
			}
			else
			{	/* �ѥ��פ�ͭ���� */
				printf("\npipe: %s\n", now = to_char(now, pipe));
			}
		}
	}
	/* ���ݤ����ΰ���� */
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
