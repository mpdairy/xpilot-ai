//Evan Gray - May 2012
//Compile: gcc Spinner.c libcAI.so -o Spinner
//Run: ./Spinner
#include "xpilotai.h"
#include <stdio.h>

void AI_loop() {
  turnRight(1);
}

int main(int argc, char *argv[]) {
  printf("------------------heye heyesdfd");
  printf("%d %s\n", argc, argv[0]);
  //return start(argc, argv);
  return start(argc, argv, AI_loop);
}
