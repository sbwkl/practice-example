#include <stdio.h>
#include <unistd.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <fcntl.h>

int main(int argc, char **argv) {
  mode_t mode = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;
  char clientfifo[4096];
  snprintf(clientfifo, 4096, "/tmp/fifo/%d.fifo", getpid());
  mkfifo(clientfifo, mode);

  char *serverfifo = "/tmp/fifo/qrs.fifo";
  int writefd = open(serverfifo, O_WRONLY);
  char buff[4096];
  snprintf(buff, 4096, "%d,%s", getpid(), argv[1]);
  write(writefd, buff, strlen(buff));
  close(writefd);

  int readfd = open(clientfifo, O_RDONLY);
  int n;
  while((n = read(readfd, buff, 4096)) > 0) {
    buff[n] = '\0';
    printf("%s", buff);
  }
  unlink(clientfifo);
  printf("\n");
}
