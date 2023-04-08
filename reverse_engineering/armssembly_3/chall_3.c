#include <stdio.h>
#include <stdlib.h>

int func2(int input){

    int result = input + 3;

    return(result);
}

int func1(int first){

    int result = 0;

    while (first != 0){

        if ((first & 1) != 0){
            result = func2(result);
        }
        first = first >> 1;
    };

    return(result);
}

int main(int argc, char **argv){

    int first  = atoi(argv[1]);

    int result = func1(first);

    printf("Result %d\n", result);

    return(0);
}