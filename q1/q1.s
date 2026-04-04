

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



insert:
    addi sp, sp, -32
    sd x1, 24(sp)
    sd x10, 16(sp)
    sd x11, 8(sp)
    beq x10, x0, base_case
    lw x6, 0(x10)
    blt x11, x6, less_than
    bgt x11, x6, greater_than
    j insert_exit
less_than:
    ld x10, 8(x10)
    call insert
    ld x5, 16(sp)
    sd x10, 8(x5)
    addi x10, x5, 0
    j insert_exit
greater_than:
    ld x10, 16(x10)
    call insert
    ld x5, 16(sp)
    sd x10, 16(x5)
    addi x10, x5, 0
    j insert_exit
base_case:
    ld x10, 8(sp)
    call make_node
insert_exit:
    ld x1, 24(sp)
    addi sp, sp, 32
    jalr x0, 0(x1)


get:
    addi sp, sp, -24
    sd x10, 0(sp)
    sd x11, 8(sp)
    sd x1, 16(sp)
    beq x10, x0, base_case_get
    lw x6, 0(x10)
    blt x6, x11, less_than_get
    bgt x6, x11, greater_than_get
    beq x6, x11, equals_get
    j get_exit
less_than_get:
    ld x10, 8(x10)
    call get
    j get_exit
greater_than_get:
    ld x10, 16(x10)
    call get
    j get_exit
equals_get:
    j get_exit
base_case_get:
    addi x10, x0, 0
    j get_exit
get_exit:
    ld x1, 16(sp)
    addi sp, sp, 24
    jalr x0, 0(x1)






 




    