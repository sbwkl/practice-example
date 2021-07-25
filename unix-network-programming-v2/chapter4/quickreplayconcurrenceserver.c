#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/wait.h>

static char *settings[2] = {
  "手持两把锟斤拷",
  "口中疾呼烫烫烫"
};

void reap_child(int sig) {
  while (waitpid(-1, NULL, WNOHANG) > 0) {

  }
  return ;
}

int main(int argc, char **argv) {

  signal(SIGCHLD, reap_child);

  char *serverfifo = "/tmp/fifo/qrs.fifo";
  mode_t mode = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;
  mkfifo(serverfifo, mode);
  int readfd = open(serverfifo, O_RDONLY);
  // exec when client come.
  open(serverfifo, O_WRONLY);

  char buff[4096]; 
  int n;
  while((n = read(readfd, buff, 4096)) > 0) {
    buff[n] = '\0';
    int idx = atoi(strchr(buff, ',') + 1);
    char *pid = strtok(buff, ",");

    if (fork() == 0) {
      char clientpath[4096];
      snprintf(clientpath, 4096, "/tmp/fifo/%s.fifo", pid);
      int writefd = open(clientpath, O_WRONLY);
      if (idx > 0 && idx < 3) {
        write(writefd, settings[idx - 1], strlen(settings[idx - 1]));
      } else {
        write(writefd, "index out of range.", 19);
      }
      close(writefd);
      exit(0);
    }
  }
  exit(0);
}
