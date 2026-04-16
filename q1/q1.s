.globl make_node
.globl insert
.globl get
.globl getAtMost

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
    addi sp, sp, -32         #Clear out the stack
    sd x1, 24(sp)            
    sd x10, 16(sp)
    sd x11, 8(sp)
    beq x10, x0, base_case   #Check if the root is NULL, if so branch to base case
    lw x6, 0(x10)            #Load root's value after NULL check. 
    blt x11, x6, less_than   
    bgt x11, x6, greater_than
    j insert_exit
less_than:
    ld x10, 8(x10)
    call insert               #Call insert with correct arguments
    ld x5, 16(sp)             #Load the root back into x5, as x10 now has insert(root->left)
    sd x10, 8(x5)             #root->left = insert(root->left, val)
    addi x10, x5, 0           #Restore x10 back
    j insert_exit
greater_than:
    ld x10, 16(x10)
    call insert               #Call insert with correct arguments
    ld x5, 16(sp)             #Load the root back into x5, as x10 now has insert(root->right)
    sd x10, 16(x5)            #root->right = insert(root->right, val)
    addi x10, x5, 0           #Restore x10 back 
    j insert_exit
base_case:
    ld x10, 8(sp)             #if root is null, call make_node with correct args
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
    beq x10, x0, base_case_get       #If root is NULL, branch to base case
    lw x6, 0(x10)                    #Load root's value after NULL check   
    blt x11,x6, less_than_get        #If val < root->val, branch to less_than_get
    bgt x11,x6, greater_than_get     #If val > root->val, branch to greater_than_get
    beq x11,x6, equals_get           #If val == root->val, branch to equals_get
    j get_exit
less_than_get:
    ld x10, 8(x10)                   #x10 now has the pointer to root->left
    call get                         #Call get with correct arguments
    j get_exit
greater_than_get:
    ld x10, 16(x10)                  #x10 now has the pointer to root->right
    call get                         #Call get with correct arguments
    j get_exit
equals_get:
    j get_exit                       #val found, x10 already holds the node pointer, return it
base_case_get:
    addi x10, x0, 0                  #val not found, return NULL (0)
    j get_exit
get_exit:
    ld x1, 16(sp)
    addi sp, sp, 24
    jalr x0, 0(x1)



getAtMost:
    addi sp, sp, -24
    sd x10, 0(sp)   #Value is stored in x10 because of switched order
    sd x11, 8(sp)   #Root pointer
    sd x1, 16(sp)   #Return address
    beq x11, x0, getAtMost_negative     #If the root pointer is null, return -1
    lw x28, 0(x11)         
    beq x10, x28, getAtMost_return_self  #If the value equals, root->val return the self value
    blt x10, x28, getAtMost_less         #If the value is less than the roots value, then call again with right args
    ld x11,16(x11)                          #x11 now has the pointer to root->right
    ld x10, 0(sp)                           #x10 has the integer value argument
    call getAtMost                          #Calling with correct arguments
    ld x11, 8(sp)                 
    addi x5, x10, 0                         #x5 has the right_res value
    addi x6, x0, -1                         #x6 now has -1
    lw x10, 0(x11)                          #x10 now has the current roots value
    beq x5, x6, getAtMost_return_self       #If right_res == -1, then return the current root's value
    addi x10, x5, 0                         #If not, return the right_res's value
    j getAtMost_exit                 
getAtMost_negative:
    addi x10, x0, -1                        #Store -1 in the return address register and return back.
    j getAtMost_exit
getAtMost_return_self:
    j getAtMost_exit                        #Return the current value of the root.
getAtMost_less:
    ld x10, 0(sp)                           
    ld x11,8(x11)
    call getAtMost
    j getAtMost_exit
getAtMost_exit:
    ld x1, 16(sp)
    addi sp, sp, 24
    jalr x0, 0(x1)






 




    