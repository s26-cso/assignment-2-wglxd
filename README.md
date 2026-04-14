[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/d5nOy1eX)



Approach for Q1 :
    Structure I used for recursive calls 
    -> Store ra on the stack so we don't lose it.
    -> main function, only have branching logic here
    -> Branching logic, assume stack has everything and recursion does everything.
    -> Base case and exit, self explanatory.

Approach for Q2:
    -> Used the program stack to implement the stack, and malloced. (No issues, because I never called a function other than in reading the loop.)
    -> have a read loop, and implemented an NGE using a montonically decreasing stack, used atoi to convert the string CLI to integers.

Approach for Q3 A:
    -> Used riscv64-linux-gnu-objdump -s target_wglxd | grep -A 4 -B 4 "passed" to get the password.
    -> Could also use riscv64-linux-gnu-objdump -s -j .rodata target_wglxd.
    -> Then ran echo password > payload.txt
Approach for Q3 B:
    -> Used a python script to generate the payload of 200 bytes, + the address of .pass in the objdump.
    -> Used a return address overwrite. Overflows the buffer and overwrites the saved return address on the stack, forcing the function to return to .pass, where the success message is printed.

Approach for Q4 : 
    -> The program reads input in a loop using scanf.
    -> The loop continues as long as valid input is provided.
    -> When EOF (end of input) is reached, scanf fails and the loop exits automatically, terminating the program.

Approach for Q5 :
    -> Used a 1 byte buffer and multiple offsets, to keep loading the respective byte and checking equality. Terminate immediately if equality is violated, if not print yes.
    -> Used 5 syscalls
        -> Syscall 56, with openat, used to open the file, in read only mode.
        -> Sycall 62, with lseek, used to update pointer positions.
        -> Syscall 63, read, used for reading the byte into the buffer.
        -> Syscall 64, for writing, could've also used printf, but didn't use main, which is why resorted to this syscall.
        -> Syscall 93, for exiting.