.section .data
filename : .asciz "input.txt"  #asciz stores a null terminated string
buffer_forward : .space 1
buffer_backward : .space 1
fmt_positive : .asciz "Yes\n"
fmt_negative : .asciz "No\n"


.section .text 
.globl _start
.extern printf                 #Simple to not throw an error during linking.


_start:
    li x10, -100
    la x11, filename            #calling openat syscall here
    li x12, 0                   
    li x13, 0                   #x13 = 0, read only mode.
    li x17, 56
    ecall
    mv x5, x10                  #Stores the fd now in x5.
    j read_file
read_file:
    mv x10, x5                  #Double check although not needed.
    li x11, 0                   # lseek syscall called here with syscall number 62, offset 0
    li x12, 2                   # starts from end
    li x17, 62                  
    ecall
    addi x28, x0, 0    #x28 now stores the forward pointer
    addi x29, x10, -1    #x29 now stores the backward pointer
    mv x6, x10         #x6 now stores the file size
    addi x6, x6, -1    #x6 now stores n-1
    j pointer_logic

pointer_logic:
    

    bge x28, x29, CORRECT      #Need to add base case, forward_pointer <= backwards_pointer

    mv x10, x5                 #x10 now stores the file descriptor
    addi sp, sp, -48           #stack mem allocation 
    sd x6, 0(sp)               #x6 stores n-1
    sd x28, 8(sp)              #x28 is the forward offset
    sd x29, 16(sp)             #x29 is the backward offset
    sd x10, 24(sp)             #x10 still has the fd
    sd x1, 32(sp)


    addi x11, x28, 0           #Calling lseek here.
    li x12, 0
    li x17, 62
    ecall

    ld x10, 24(sp)
    call forward_pointer    #x10 could have been changed here, as its a call
    ld x10, 24(sp)          #restoring x10 back, now again stores the fd

    addi x11, x29, 0
    li x12, 0               #Calling lseek here again.
    li x17, 62
    ecall

    ld x10, 24(sp)
    call backward_pointer   #x10 changed again
    ld x10, 24(sp)          #x10 now has fd again
    ld x1, 32(sp)
    ld x29, 16(sp)
    ld x28, 8(sp)
    ld x6, 0(sp)

    addi sp, sp, 48
              
    la x30, buffer_forward
    lb x30, 0(x30)
    la x31, buffer_backward
    lb x31, 0(x31)
    bne x30, x31, INCORRECT                       #Need to add buffer check here


    addi x28, x28, 1
    addi x29, x29, -1
    j pointer_logic



forward_pointer:
    la x11, buffer_forward                        #Calling the read syscall, here. (Syscall number for this is 63)
    li x12, 1
    li x17, 63
    ecall
    ret
backward_pointer:
    la x11, buffer_backward                        #Calling the read syscall again here. (Sys call number for read is 63.)
    li x12, 1
    li x17, 63
    ecall
    ret

CORRECT:
    li x10, 1          # stdout
    la x11, fmt_positive
    li x12, 4          # "Yes\n" is 4 bytes
    li x17, 64         # write syscall, 64 is the syscall number
    ecall
    li x10, 0
    li x17, 93         # syscall 93 is exit
    ecall

INCORRECT:
    li x10, 1
    la x11, fmt_negative
    li x12, 3          # "No\n" is 3 bytes
    li x17, 64         # write syscall, 64 is the syscall number
    ecall
    li x10, 0
    li x17, 93         # syscall 93 is exit
    ecall







