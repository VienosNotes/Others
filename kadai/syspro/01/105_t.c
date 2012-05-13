#include<stdio.h>

void
print_data(int data[], int count)
{
	int             i;

	for (i = 0; i < count; ++i)
	{
		printf("%2d\t", data[i]);
	}

	printf("\n");
}

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

	while (1)
	{
		int             flag = 0;
		++n_loop;
		for (i = 0; i + h < count; ++i)
		{

			if (data[i] > data[i + h])
			{
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
		}
	}
	printf("[comb sort]\n loop: %d time(s), swap: %d time(s)\n", n_loop, n_swap);
}

int
main()
{

	int             sample[10] = {8, 10, 3, 5, 7, 4, 2, 9, 6, 1};
	int             sample2[10] = {8, 10, 3, 5, 7, 4, 2, 9, 6, 1};

	bobble_sort(sample, 10);
	comb_sort(sample2, 10);
	return 1;
}
