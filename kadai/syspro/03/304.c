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
    list = tmp;
  }
}

utmplist *
read_utmp()
{
  utmplist *ulp, *head = NULL;
  struct utmpx *tmp = NULL;
  ulp = (utmplist*) malloc(sizeof (utmplist*));
  while (1) {
    if (ulp == NULL) 
      {
	perror("memory allocation failed");
	exit(-1);
      }

    tmp = getutxent();

    if (tmp == NULL)
      {
	break;
      }
    else {
      ulp->u = malloc(sizeof(struct utmpx));
      *ulp->u = *tmp;
    }

    if (head == NULL) {
      head = ulp;
    }
    ulp = ulp->next = (utmplist*) malloc(sizeof (utmplist*));
  }
  return head;
}


bool is_same (utmplist *before, utmplist *after) {
  if (before == NULL) {
    return false;
  }
    while (before->u != NULL || after->u != NULL) {
      if ((before->u != NULL && after->u == NULL) || (before->u == NULL && after->u != NULL)) {
	return false;
      }
      if (strcmp(ctime(&before->u->ut_tv.tv_sec), ctime(&after->u->ut_tv.tv_sec)) != 0) {
	return false;
      }
      before = before->next;
      after = after->next;
  }

  return true;
}


void
write_utmp(utmplist *list)
{
    while (list->u != NULL) {
      myprintf(list->u);
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
    if (!is_same(before, after)) {
      write_utmp(after);
    }
    sleep(SEC);
  }

  free_list(before);
  free_list(after);
  return 0;
}
