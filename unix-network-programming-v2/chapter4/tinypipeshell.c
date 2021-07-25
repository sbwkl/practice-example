#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char **argv, char **envp) {

  char cmdstring[1024];
  int len = read(STDIN_FILENO, cmdstring, sizeof(cmdstring));
  cmdstring[len - 1] = '\0';

  char *cl[16];
  int n = 0;
  char *subcmd = strtok(cmdstring, "|");
  while (subcmd != NULL) {
    cl[n] = (char *) malloc(strlen(subcmd) * sizeof(char));
    strcpy(cl[n], subcmd);
    n++;
    subcmd = strtok(NULL, "|");
  }

  int *pl[16];
  for (int i = 0; i < n; i++) {
    pl[i] = (int *) malloc(2 * sizeof(int));
    pipe(pl[i]);
  }

  for (int i = 0; i < n; i++) {
    if (fork() == 0) {
      dup2(pl[i][0], STDIN_FILENO);
      if (i + 1 < n) {
        dup2(pl[i + 1][1], STDOUT_FILENO);
      }

      for (int i = 0; i < n; i++) {
        close(pl[i][0]);
        close(pl[i][1]);
      }

      execve(cl[i], argv, envp);
    }
  }
  for (int i = 0; i < n; i++) {
    close(pl[i][0]);
    close(pl[i][1]);
  }

  for (int i = 0; i < n; i++) {
    wait(NULL);
  }
}