#include <stdio.h>
#include <dlfcn.h>

#define MAX_OP_LEN 6
#define LIB_NAME_LEN 16

typedef int (*operation_func)(int, int);  /*Function pointer, represents a function
which takes two integer arguments and returns another integer argument*/

int main(){
    char op[MAX_OP_LEN];
    int num1;
    int num2;
    while(1){
        scanf("%5s %d %d", op, &num1, &num2);      /**Taking input, operation name, and then 2 numbers */
        char lib_name[LIB_NAME_LEN];              
        snprintf(lib_name, sizeof(lib_name), "./lib%s.so", op);   /*Writes into lib_name, writes the string of format lib%s.so*/
        void *handle = dlopen(lib_name, RTLD_LAZY);               /*Handle of the library, opening it in lazy mode*/
        if(handle==NULL){
            fprintf(stderr, "Error opening the library.\n");      /*If null, print to stderror*/
            return 1;
        }
        operation_func operation = (operation_func) dlsym(handle, op);    /*dlsym is used to access anything by name, can be functions, global variables and constants*/
        if(operation == NULL){
            fprintf(stderr, "Error accessing the operation\n");           /*If null, print to stderr*/
            dlclose(handle);                                              /*We close the handle here and not earlier as earlier it was null.*/
            return 1;
        }
        int result = operation(num1, num2);
        printf("%d\n", result);
        dlclose(handle);
    }

    return 0;
}