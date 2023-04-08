#include <stdio.h>
#include <stdlib.h>

int func1(int first){

    int result;
    int i = 0;
    int j = 0;

    while (i < first){
        i = i + 1;
        j = j + 3;
    }

    result = j;

    return(result);
}

int main(int argc, char **argv){

    int first  = atoi(argv[1]);

    int result = func1(first);

    printf("Result %d\n", result);

    return(0);
}