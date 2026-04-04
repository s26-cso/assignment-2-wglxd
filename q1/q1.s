

#Argument in x10
#Next memory address x5
#size of struct = 24
make_node:
    addi sp, sp, -16   #We need to allocate stack memory as malloc completely overrides the temporary registers.
    sd x1, 0(sp)
    add x6, x10, x0    #x6 now stores the initial Argument
    sd x6, 8(sp)
    addi x10, x0, 24   #x10 now stores the size of the memory to allocate
    call malloc        #calling malloc and now x10 stores the pointer to that memory address
    ld x1, 0(sp)
    ld x6, 8(sp)
    addi sp, sp, 16
    addi x7, x10, 0    #x7 now stores that address
    sw x6, 0(x7)       #storing the value in x6 at the address in x7
    addi x7, x7, 8     #Padding
    sd x0, 0(x7)       #Storing the null pointer at x7
    addi x7, x7, 8     #Offset
    sd x0, 0(x7)       #Storing the null pointer at x7
    jalr x0, 0(x1)     #Must return


 




    