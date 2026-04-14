.section .data
fmt: .string "%ld "
fmt_nl: .string "\n"



.section .text
.globl main
main:
    addi sp, sp, -16        
    sd ra, 0(sp)

    addi s2, x10, -1         #x12 -> s2 = n = argc - 1
    addi x11, x11, 8         #skip argv[0] (8 bytes now)
    addi s3, x11, 0          #x11 -> s3 = argv pointer
                             
    addi sp, sp, -16         
    sd x1, 0(sp)             
    addi x10, s2, 0          #Move n to a0
    slli x10, x10, 3         #n*8 bytes
    call malloc
    addi s4, x10, 0          #s4 = arr base pointer
    ld x1, 0(sp)
    addi sp, sp, 16
    addi x14, x0, 0          #x14 = i = 0
read_loop:
    bge  x14, s2, read_done
    slli x15, x14, 3
    add  x15, s3, x15
    ld   x10, 0(x15)
    
    addi sp, sp, -32         
    sd x1, 0(sp)             
    sd x14, 8(sp)            #Save loop index
    call atoi                #Converts a string to an integer
    ld x1, 0(sp)             
    ld x14, 8(sp)
    addi sp, sp, 32
    
    slli x15, x14, 3
    add  x15, s4, x15
    sd   x10, 0(x15)
    addi x14, x14, 1
    j    read_loop
read_done:
    # x12 = n, x13 = arr
mallocing_result:
    addi sp, sp, -16         
    sd x1, 0(sp)             
    addi x10, s2, 0          #Move n to a0
    slli x10, x10, 3        
    call malloc
    addi s5, x10, 0          #x10 -> s5 = result pointer
    ld x1, 0(sp)
    addi sp, sp, 16
    
    addi x31, sp, 0          #x31 will now store my initial stack pointer
    addi x29, s2, -1         #x29 is my outer loop variable which stores n-1
    addi x30, x0, 0          #x30 will be the count for the number of elements in the stack

    addi x28, x0, -1         #x28 stores -1
    addi x5, x0, 0           #x5 stores the induction variable                        
    j LOOP_init
LOOP_init:
    bge x5, s2, LOOP_outer     #base_case
    slli x6, x5, 3              #x6 now stores x5 multiplied by 8
    add x7, x6, s5              #s5 stores the result base pointer
    sd x28, 0(x7)               
    addi x5, x5, 1
    j LOOP_init
LOOP_outer:
    blt x29, x0, return_func       #If x29 is less than 0, simply branch to return function
    bgt x30, x0, intermediate_stage  #If the stack is not empty, go to an intermediate checker
    j common_stage
intermediate_stage:
    addi x5, x30, 0                #x5 will now store my x30 - 0 (number of elements in stack -0)
    slli x5, x5, 3                 #x5 will now store my offset in bytes (8*(nos-0))
    sub x5, x31, x5                #x5 now stores the actual stack.top()'s address (sp - 8*(nos-0))
    ld x6, 0(x5)                   #x6 now stores the actual index stored in the stack.top()
    slli x6, x6, 3          #x6 now stores the offset correctly
    add x6, x6, s4          #s4 now stores the correct offset from the base address
    ld x7, 0(x6)            #x7 now stores the actual element in the array corresponding to the index x6
    addi x6, x29, 0         #x6 now stores my induction variable
    slli x6, x6, 3
    add x6, x6, s4          #now x6 stores the current correct offset from the base address
    ld x6, 0(x6)            #x6 now has arr[i]
    ble x7, x6, pop_the_stack
    j common_stage
pop_the_stack:
    addi sp, sp, 8
    addi x30, x30, -1
    j LOOP_outer
common_stage:
    bgt x30, x0, set_result
    j final_common_stage
set_result:
    ld x6, 0(sp)            #x6 now holds the index at the top of the stack
    addi x7, x29, 0         #Copy i (x29) into a temp register x7
    slli x7, x7, 3          #Multiply i by 8 to get the byte offset
    add x7, x7, s5          #s5 is base address of result array
    sd x6, 0(x7)            #Store the value in x6 into the memory address at x7
    j final_common_stage
final_common_stage:
    addi sp, sp, -8
    sd x29, 0(sp)
    addi x30, x30, 1
    addi x29, x29, -1
    j LOOP_outer
return_func:
    addi sp, x31, 0         #Reset stack pointer to original state before printing
    addi x5, x0, 0          #i = 0
print_loop:
    bge x5, s2, print_done
    slli x6, x5, 3
    add x6, x6, s5
    ld x11, 0(x6)          #x11 = result[i] (second arg to printf)
    
    addi sp, sp, -16        
    sd x1, 0(sp)            
    sd x5, 8(sp)            
    la x10, fmt            #first arg = format string
    call printf
    ld x1, 0(sp)
    ld x5, 8(sp)
    addi sp, sp, 16
    
    addi x5, x5, 1
    j print_loop
print_done:
    la x10, fmt_nl
    call printf
    
    ld x1, 0(sp)             
    addi sp, sp, 16
    addi x10, x0, 0        #return 0
    ret