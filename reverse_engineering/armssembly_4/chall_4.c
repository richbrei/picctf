#include <stdio.h>
#include <stdlib.h>

int func8(int input){

    input = input + 2;

    return input;
}

int func7(int input){

    int result;
    
    if (input < 100){
        result = 7;
    }
    else{
        result = input;
    }

    return(result);
}

int func6(int input){

    int a = 314;
    int b = 1932;
    int result = 0;

    while (result < 899) {
        int c = 800;
        c = c * b;
        int e = c / a;
    }

    return(result);
}

int func5(int input){

    input = func8(input);

    return(input);
}

int func4(int input){

    int result;
    int a = 17;

    result = func1(a);

    return(input);
}

int func3(int input){

    return(func7(input));
}

int func2(int input){

    int result;

    if (input > 499){
        result = func5(input + 13);
    }
    else{
        result = func4(input - 86);
    }

    return(result);
}

int func1(int input){

    int result;

    if (input < 100){
        result = func3(input);
    }
    else{
        result = func2(input + 100);
    }

    return(result);
}

int main(int argc, char **argv){

    int first  = atoi(argv[1]);

    int result = func1(first);

    printf("Result %d\n", result);

    return(0);
}