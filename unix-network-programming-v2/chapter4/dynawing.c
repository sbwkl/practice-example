#include <stdio.h>
#include <unistd.h>

int main(int argc, char **argv) {
  char msg[1024];
  int n;
  while((n = read(STDIN_FILENO, msg, sizeof(msg))) > 0) {
      msg[n] = '\0';
      printf("%s", msg);
  }
  printf("dynawing\n");
}
