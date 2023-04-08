#include <stdio.h>
#include <stdlib.h>

int func(int first){

    int result;
    int a = 87;
    int b = 3;
    int c = 3;

    result = a << b; 

    result = result / c;

    result = result - a;

    return(result);
}

int main(int argc, char **argv){

    int first  = atoi(argv[1]);

    int result = func(first);

    if (result == 0){
        puts("You win");
    }
    else{
        puts("You Lose :(");
    }

    return(0);
}