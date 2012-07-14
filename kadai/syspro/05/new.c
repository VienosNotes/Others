
#include <stdio.h>
#include <sys/time.h>

int             mygetchar(int);

int 
main(void)
{

	time_t          timer;
	time(&timer);

	printf("time = %s", ctime(&timer));
	printf("value = %d\n", mygetchar(5));
	time(&timer);
	printf("time = %s", ctime(&timer));

	/* printf("time = %s", ctime(&timer)); */
	/* printf("value = %d\n", mygetchar(5)); */
	/* time(&timer); */
	/* printf("time = %s", ctime(&timer)); */

	/* printf("time = %s", ctime(&timer)); */
	/* printf("value = %d\n", mygetchar(5)); */
	/* time(&timer); */
	/* printf("time = %s", ctime(&timer)); */

	/* printf("time = %s", ctime(&timer)); */
	/* printf("value = %d\n", mygetchar(5)); */
	/* time(&timer); */
	/* printf("time = %s", ctime(&timer)); */

	return 0;
}

int 
mygetchar(int time)
{

        /* 監視するファイルディスクリプタの設定 */
	fd_set          fdset;
	FD_ZERO(&fdset);
	FD_SET(0, &fdset);

	/* タイムアウト時間の設定 */
	struct timeval  tv;
	tv.tv_sec = time;
	tv.tv_usec = 0;

	/* 標準入力を監視 */
	int             n = select(1, &fdset, NULL, NULL, &tv);

	/* タイムアウトした場合 */
	if (n == 0)
	{
		return -2;
	} /* 文字入力があった場合 */
	else if (n == 1)
	{
		if (feof(stdin) != 0) {
		  getchar();
		  return -1;
                }

                int             var;
		var = getchar();
		printf("hoge");
		/* varがEOFでも改行文字でもなければ入力ストリームをクリア */
    		while (feof(stdin) == 0) getchar(); 
		/* 入力された文字を返す */
                return var;

	}
	else /* 何かしらで失敗した場合 */
	{
		return -3;
	}
}
