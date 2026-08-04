#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void process(const char *user_input) {
    printf(user_input);
    fprintf(stderr, user_input);
    char buf[100];
    scanf("%s", buf);
    char *p = alloca(user_input[0]);
    char *tok = strtok(buf, ",");
    int n = atoi(user_input);
    char *home = getenv("HOME");
}
