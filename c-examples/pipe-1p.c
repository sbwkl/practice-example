#include <sys/wait.h>
#include <stdio.h>
#include <unistd.h>

int main(int argc, char **argv) {

  int pipefd[2];
  pipe(pipefd);

  if (fork() == 0) {
    close(pipefd[0]);
    write(pipefd[1], "Hello world!", 12);
    _exit(0);
  }
  close(pipefd[1]);
  char msg[1024];
  int n;
  while((n = read(pipefd[0], msg, sizeof(msg))) > 0) {
    printf("receive %d bytes msg: %s\n", n, msg);
  }
  wait(NULL);
}
