#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <time.h>
#include <utmpx.h>
#include <unistd.h>
#include <stdbool.h>
#include <assert.h>
#define SEC 2

typedef struct utmplist_t {
  struct utmplist_t *next;
  struct utmpx     *u;
} utmplist;

void myprintf (struct utmpx *ulp) {
    printf("%8.8s|%16.16s|%8.8s|%s", ulp->ut_user,
	    ulp->ut_host, ulp->ut_line, ctime(&ulp->ut_tv.tv_sec));
    return;
}

void free_list (utmplist *list) {
  utmplist *tmp = NULL;
  while (list->u != NULL) {
    free(list->u);
    tmp = list->next;
    //    free(list);
    list = tmp;
  }
  printf ("free success\n");
}

utmplist *
read_utmp()
{
  //  utmplist *orig = head;
  utmplist *ulp, *head = NULL;
  struct utmpx *tmp = NULL;
  ulp = (utmplist*) malloc(sizeof (utmplist*));
  while (1) {
    //    printf ("loop start\n");
    if (ulp == NULL) 
      {
	perror("memory allocation failed");
	exit(-1);
      }

    tmp = getutxent();

    if (tmp == NULL)
      {
	printf ("no entry\n");
	break;
      }
    else {
           printf ("found... ");
           myprintf(tmp);
      ulp->u = malloc(sizeof(struct utmpx));
      *ulp->u = *tmp;
    }

    if (head == NULL) {
      head = ulp;
    }
    ulp = ulp->next = (utmplist*) malloc(sizeof (utmplist*));
  }

  printf ("read done\n");
  //  free_list(orig);
  return head;
}


bool is_same (utmplist *before, utmplist *after) {
  if (before == NULL) {
    printf ("first one\n");
    return false;
  }
    while (before->u != NULL || after->u != NULL) {
    assert(before->u != NULL && after->u != NULL);
    //    printf ("comparing now...\n");
    if ((before->u != NULL && after->u == NULL) || (before->u == NULL && after->u != NULL)) {
      printf ("  updown\n");
      return false;
    }
    printf ("%s%s\n",ctime(&before->u->ut_tv.tv_sec), ctime(&after->u->ut_tv.tv_sec));
    if (strcmp(ctime(&before->u->ut_tv.tv_sec), ctime(&after->u->ut_tv.tv_sec)) != 0) {
      printf ("  diff\n");
      return false;
    }
    before = before->next;
    after = after->next;
  }
  printf ("same\n");
  return true;
}


void
write_utmp(utmplist *list)
{
    printf ("called\n");
    while (list->u != NULL) {
      //      printf ("printing\n");
      myprintf(list->u);
      //      printf ("next print\n");
      list = list->next;
  }
  
}

int main()
{
  utmplist *before = NULL;
  utmplist *after = NULL;

  while (1) {
    setutxent();
    before = after;
    after = read_utmp();
    assert(after != NULL);
    if (!is_same(before, after)) {
      write_utmp(after);
    }
    //     free_list(before);
    printf ("sleeping\n");
    sleep(SEC);
  }
  return 0;
}
