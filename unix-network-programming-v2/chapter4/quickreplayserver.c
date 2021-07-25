#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <fcntl.h>

static char *quick_reply[16] = {
  "Hello world!",
  "mdzz",
  "fuck",
  "SB"
};

int main(int argc, char **argv) {
  char *serverfifo = "/tmp/fifo/qrs.fifo";
  mode_t mode = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;
  mkfifo(serverfifo, mode);
  int readfd = open(serverfifo, O_RDONLY);
  // exec when client come.
  open(serverfifo, O_WRONLY);
  char buff[1024]; 
  int n;
  while((n = read(readfd, buff, 1024)) > 0) {
    buff[n] = '\0';
    int idx = atoi(strchr(buff, ',') + 1);
    char *pid = strtok(buff, ",");

    char clientpath[1024];
    snprintf(clientpath, 1024, "/tmp/fifo/%s.fifo", pid);
    int writefd = open(clientpath, O_WRONLY);
    if (idx > -1 && idx < 4) {
      write(writefd, quick_reply[idx], strlen(quick_reply[idx]));
    } else {
      write(writefd, "no such reply", 13);
    }
    close(writefd);
  }
  exit(0);
}
