#include<stdio.h>
#include<stdlib.h>
#include<sys/select.h>
#include<assert.h>
#define BUF_SIZE 512
int pipe_fd[2];


int main (int argc, char* argv[]) {
  int pid;
  char buf[512];
  int ret;

  if(pipe(pipe_fd) < 0) {
    perror("pipe failed");
    exit(-1);
  }
  int count = atoi(argv[1]);
  assert(count == 10);
  pid = fork();
  for (int i = 0; i < count; ++i) {

    if (pid == 0) { //child
      //      sleep(1);
      close(3);
      dup2(3, pipe_fd[1]); //copy write
      close(pipe_fd[1]); //close write
      int tmp = pipe_fd[0];
      ret = select(4, &tmp, NULL, NULL, NULL);
      if (ret == -1) {
	perror("select fail");
	exit(-1);
      } else {
	  putchar(i+48);
	  fflush(stdout);
      }
      dup2(2, pipe_fd[0]); //copy read
      close(pipe_fd[0]); //close read
      dup2(pipe_fd[1],3);// resume write
      ret = select(4, NULL, &pipe_fd[1], NULL, NULL);
      printf ("");
      dup2(pipe_fd[0], 2);//resume read
      close(2);
      close(3);
    } 
    else { //parent
      //sleep(1);
      close(4);
      dup2(4, pipe_fd[0]); //copy read
      close(pipe_fd[0]); //close read
      ret = select(6, NULL, &pipe_fd[1], NULL, NULL);
      printf ("");
      dup2(pipe_fd[0],4); //resume read
      dup2(5, pipe_fd[1]); //copy write
      close(pipe_fd[1]); //close write
      int tmp = pipe_fd[0];
      ret = select(6, &tmp, NULL, NULL, NULL);
      if (ret == -1) {
	perror("select fail");
	exit(-1);
      } else {
	  putchar(i+65);
	  fflush(stdout);
      }
      dup2(pipe_fd[1], 5); //resume write
      close(4);
      close(5);
    }
  }
}
