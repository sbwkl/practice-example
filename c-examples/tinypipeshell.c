#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char **argv) {

  char cmdstring[1024];
  int len = read(STDIN_FILENO, cmdstring, sizeof(cmdstring));
  cmdstring[len - 1] = '\0';
  char *subcmd = strtok(cmdstring, "|");

  char *cl[16];
  int n = 0;
  while (subcmd != NULL) {
    cl[n] = (char *) malloc(strlen(subcmd) * sizeof(char));
    strcpy(cl[n], subcmd);
    n++;
    subcmd = strtok(NULL, "|");
  }

  int *pl[16];
  for (int i = 0; i <= n; i++) {
    pl[i] = (int *) malloc(2 * sizeof(int));
    pipe(pl[i]);
  }

  for (int i = 1; i <= n; i++) {
    if (fork() == 0) {
      dup2(pl[i][0], STDIN_FILENO);
      int j = (i + 1) % (n + 1);
      dup2(pl[j][1], STDOUT_FILENO);

      for (int i = 0; i <= n; i++) {
        close(pl[i][0]);
        close(pl[i][1]);
      }

      execve(cl[i - 1], NULL, NULL);
    }
  }
  // parent process remain pl[0][0] for read.
  for (int i = 1; i <= n; i++) {
    close(pl[i][0]);
    close(pl[i][1]);
  }
  close(pl[0][1]);
  char pbuff[1024];
  int pn;
  while((pn = read(pl[0][0], pbuff, sizeof(pbuff))) > 0) {
    if (pbuff[pn - 1] == '\n') {
      pbuff[pn - 1] = '\0';
    }
    printf("%s\n", pbuff);
  }
  for (int i = 1; i <= n; i++) {
    wait(NULL);
  }
}
