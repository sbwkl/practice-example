#include <stdio.h>
#include <unistd.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <fcntl.h>

int main(int argc, char **argv)
{
  char *serverfifo = "/tmp/fifo/qrs.fifo";
  mode_t mode = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;
  char clientfifo[1024];
  snprintf(clientfifo, 1024, "/tmp/fifo/%d.fifo", getpid());
  mkfifo(clientfifo, mode);
  int writefd = open(serverfifo, O_WRONLY);
  char buff[1024];
  snprintf(buff, 1024, "%d,%s", getpid(), argv[1]);
  write(writefd, buff, strlen(buff));
  close(writefd);

  int readfd = open(clientfifo, O_RDONLY);

  int n;
  while((n = read(readfd, buff, 1024)) > 0) {
    buff[n] = '\0';
    printf("%s", buff);
  }
  unlink(clientfifo);
  printf("\n");
}
