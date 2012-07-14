#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <utmpx.h>

typedef struct utmpxlist
{
	struct utmpx data;
	struct utmpxlist* next;
}cell;

void load_utmpx( cell** head );
int compare_list( cell* prev, cell* now );
void free_list( cell** head );
void print_list( cell* head );
void print_cell( cell* p );

int main( void )
{
	cell* Head_Prev = NULL;
	cell* Head_Now = NULL;
	
	while ( 1 )
	{
		//読み込み
		load_utmpx( &Head_Now );
		
		//比較
		if ( compare_list( Head_Prev, Head_Now ) )
		{
			printf("----------------------------------------\n");
			time_t timer;
			time(&timer);
			printf("%s", ctime(&timer));
			printf("----------------------------------------\n");
			print_list( Head_Now );
		}
		
		//前回の結果を開放
		free_list( &Head_Prev );
		
		Head_Prev = Head_Now;
		Head_Now = NULL;

		sleep( 20 );
	}
	
	return 0;
}

void load_utmpx( cell** head )
{
	
	//utmpxを最初から読み込む
	setutxent();
	
	struct utmpx* up;
	
	cell* p_Prev = NULL;
	cell* p_Now = NULL;
	while ( (up = getutxent()) != NULL )
	{
		//記録条件に合わない場合
		if ( (up->ut_type != LOGIN_PROCESS) && (up->ut_type != USER_PROCESS) )
		{
			continue;
		}

		//メモリ確保
		p_Now = malloc( sizeof(cell) );
		if ( p_Now == NULL )
		{
			perror( "malloc" );
			exit(-1);
		}
		
		//データコピー
		p_Now->data = *up;
		p_Now->next = NULL;
		
		//先頭か否か
		if ( *head == NULL )
		{
			*head = p_Now;
		}
		else
		{
			p_Prev->next = p_Now;
		}
		
		p_Prev = p_Now;
		p_Now = NULL;
	}
}

int compare_list( cell* prev, cell* now )
{
	//リストが前回と違う時　return 1
	
	//初回時
	if ( prev == NULL )
	{
		return 1;
	}

	cell* p = prev;
	cell* n = now;
	while ( !(p == NULL && n == NULL) )
	{
		//リスト終端が違う
		if ( p == NULL || n == NULL )
		{
			return 1;
		}
		
		//時刻を比較
		if ( &p->data.ut_tv.tv_sec != &n->data.ut_tv.tv_sec )
		{
			return 1;
		}
		//次要素へ
		p = p->next;
		n = n->next;
	}
	
	return 0;
}

void free_list( cell** head )
{
	cell* p = *head;
	cell* tmp;
	
	while ( p != NULL )
	{
		tmp = p;
		p = p->next;
		free(tmp);
	}
	
}

void print_list( cell* head )
{
	cell* p = head;
	while ( p != NULL )
	{
		print_cell( p );
		p = p->next;
	}
}

void print_cell( cell* p )
{
	printf( "%8.8s|%16.16s|%8.8s|%s",
		   p->data.ut_user,
		   p->data.ut_host,
		   p->data.ut_line,
		   ctime(&p->data.ut_tv.tv_sec)
		   );	
}
