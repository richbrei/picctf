#include <stdio.h>
#include <stdlib.h>

int func1(int first, int second){
    // do some more stuff
    return(second);
}

int main(int argc, char **argv){

    int first  = atoi(argv[1]);
    int second = atoi(argv[2]);

    int result = func1(first, second);

    printf("Result: %d\n", result); 

    return(0);
}