.eqv index_lb $t0
.eqv multiplicador $t1
.eqv index_sw $t2
.eqv index $t3
.eqv char $s0
.eqv num $s2
.eqv digit $s3

# ========================================= #
.data
    tamanho:            .word 100
    concatenarLinha:    .asciiz ", "
    unsorted_list_name: .asciiz "unsorted_list.txt"
    sorted_list_name:   .asciiz "sorted_list.txt"

    .align 2
    lista_numerica:     .space 400
.text

li index_sw, 0
li index_lb, 0
li index, 0
# ======================================== #

main:
    jal readFile                        # function to load file into RAM and return to main
    li index_lb, 0                      # reset $t0 (index_lb) 
    jal toInteger                       # perform CHAR to INTEGER convertion and return to main
    li index_lb, 0                      # reset $t0 (index_lb) 

    jal bubbleSort                      # perform sort algorithm and return to main
    jal writeFile                       # write file and return to main
    j exit                              # perform exit program

# ======================================== #
# convert to integer
toInteger:
    lb  char, lista_numerica(index_lb)  # load a char from file at [index]
    add index_lb, index_lb, 1           # increment counter
    beq char, '\0', store               # if equal `\0` go to store
    beq char, '-', sinal                # if equals `-` goto signald, signed -> unsigned
    beq char, ',', store                # if equals `,` go to store     
    sub digit, char, 0x30               # convert string into integer by performing subtraciotn (char - 0x30)
    mul num, num, 10                    # multiply by 10 to increment a decimal   
    add num, num, digit                 # add num to new digit
    j toInteger                         # loop toInteger
   
init:
    li num, 0                           # set num to 0
    li multiplicador, 1                 # set multiply to '1'
    j toInteger                             

sinal:
    li multiplicador, -1                # set multiply to '-1' 
    j toInteger                         # 

store:
    mul num, num, multiplicador         #
    sw num, lista_numerica(index_sw)       #
    add index_sw, index_sw, 4           #
    beq char, '\0', end_toInteger       #
    j init                              #

end_toInteger:
	jr $ra                              # return to caller 

# ============================================================== #
#Sorting Algorithm

bubbleSort:
    la $s0, lista_numerica              # Load adress of lista_numerica
    lw $s1, tamanho                     # Store size of list
    li index_sw, 1                      # Load start number 
    j outerLoop                         # Jump to OuterLoop

outerLoop:
    li index_sw, 0                      # Set index_sw -> 0
    li index, 0                         # Set index to -> 0

innerLoop:
    mul $t4, index, 4                   #
    add $t5, $s0, $t4                   #
    addi $t6, $t5, 4                    #

    lw $t7, 0($t5)                      #
    lw $t8, 0($t6)                      #

    ble $t7, $t8, jump_if_sorted        #
    sw $t8, 0($t5)                      #
    sw $t7, 0($t6)                      #
    li $t2, 1                           #

jump_if_sorted:
    addi index, index, 1                #
    blt  index, $s1, innerLoop           #
    beqz index_sw, end_jump             #
    j outerLoop                         #
  
end_jump:                       
	jr $ra                              # return call

# ======================================== #
# File I/O
readFile:

    li $v0, 13                          # open file
    la $a0, unsorted_list_name          # file path
    li $a1, 0                           # read command 0
    syscall     

    move $s0, $v0                       # copy descriptor

    li $v0, 14                          # read data pointed by $a0
    move $a0, $s0                       # save file descriptor
    la $a1, lista_numerica              # buffer to store data
    li $a2, 400                         # buffer size
    syscall 

    # close file
    li $v0, 16
    move $a0, $s0
    syscall

    jr $ra                              # return call
	

writeFile:
    # Open (for writing) a file that does not exist
    li   $v0, 13                        # system call for open file
    la   $a0, sorted_list_name          # output file name
    li   $a1, 1                         # Open for writing (flags are 0: read, 1: write)
    li   $a2, 0                         # mode is ignored
    syscall                             # open a file (file descriptor returned in $v0)
    move $s6, $v0                       # save the file descriptor 

    # Write to file just opened
    li   $v0, 15                        # system call for write to file
    move $a0, $s6                       # file descriptor 
    la   $a1, lista_numerica            # address of buffer from which to write
    li $a2, 400                         # hardcoded buffer length
    syscall                             # write to file

    # Close the file 
    li   $v0, 16                        # system call for close file
    move $a0, $s6                       # file descriptor to close
    syscall                             # close file
    
    jr $ra                              # return call
#========================================#

# End program
exit:
    li $v0, 10                          # Exit command
    syscall         