----------------------------------------------------------------------
学籍番号: 200904321
名前: 青木大祐
課題番号：1
練習問題番号：105
題名：プログラミングとデバッグ

以下のCプログラムを作成し、バブルソートとコムソートの比較を行った。

#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<time.h>

void
swap(int data[], int i, int j)
{
	int             tmp;

	tmp = data[i];
	data[i] = data[j];
	data[j] = tmp;
}

void
bobble_sort(int data[], int count)
{
	int             i, j;
	int             n_loop = 0;
	int             n_swap = 0;

	for (i = 0; i < count - 1; ++i)
	{
		++n_loop;
		for (j = 0; j < (count - 1) - i; ++j)
		{

			if (data[j] > data[j + 1])
			{
				++n_swap;
				swap(data, j, j + 1);
			}

		}
	}

	printf("[bobble sort]\n loop: %d time(s), swap: %d time(s)\n", n_loop, n_swap);
}

void
comb_sort(int data[], int count)
{
	int             h = count * 10 / 13;
	int             i;

	int             n_loop = 0;
	int             n_swap = 0;

	if (h == 9 || h == 10)
	{
		h = 11;
	}

	while (1)
	{
		//print_data(data, 10);
		int             flag = 0;
		++n_loop;
		for (i = 0; i + h < count; ++i)
		{

			if (data[i] > data[i + h])
			{
				//printf("%s", "swap!");
				swap(data, i, i + h);
				++n_swap;
				++flag;
			}
		}

		if (h == 1)
		{
			if (flag == 0)
			{
				break;
			}
		}
		else
		{
			h = h * 10 / 13;
			if (h == 9 || h == 10)
			{
				h = 11;
			}
		}
	}
	printf("[comb sort]\n loop: %d time(s), swap: %d time(s)\n", n_loop, n_swap);
}

int
main(int argc, char *argv[])
{

	int             CNT = atoi(argv[2]);
	int            *sample = malloc(sizeof(int) * CNT);

	srand((unsigned) time(NULL));
	for (int i = 0; i < CNT; ++i)
	{
		sample[i] = rand();
	}
	if (!strcmp(argv[1], "bobble"))
	{
		bobble_sort(sample, CNT);
	}
	else if (!strcmp(argv[1], "comb"))
	{
		comb_sort(sample, CNT);
	}
	else
	{
		printf("%s : not implemeted yet\n", argv[1]);
	}
	return 1;
}

* 実行結果

 * 1000回 
% time ./a.out bobble 1000 
[bobble sort]
 loop: 999 time(s), swap: 257110 time(s)
./a.out bobble 1000  0.01s user 0.00s system 28% cpu 0.032 total

% time ./a.out comb 1000  
[comb sort]
 loop: 25 time(s), swap: 4288 time(s)
./a.out comb 1000  0.00s user 0.00s system 9% cpu 0.028 total

 * 10000回
% time ./a.out bobble 10000
[bobble sort]
 loop: 9999 time(s), swap: 24937890 time(s)
./a.out bobble 10000  0.69s user 0.01s system 82% cpu 0.845 total

% time ./a.out comb 10000  
[comb sort]
 loop: 34 time(s), swap: 61885 time(s)
./a.out comb 10000  0.00s user 0.00s system 21% cpu 0.028 total

1000,10000要素の乱数を用いた配列で検証した結果、バブルソートを改良したコムソートの方が反復回数/置換回数ともに少ない事がわかった。また、実行速度も高速である。

----------------------------------------------------------------------
