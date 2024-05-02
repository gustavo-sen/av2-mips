.eqv index_lb $t0
.eqv multiplicador $t1
.eqv index_sw $t2
.eqv index $t3
.eqv char $s0
.eqv digit $s0
.eqv num $s2

#========================================#
.data
    tamanho: .word 100
    concatenarLinha: .asciiz ", "
    unsorted_list_name: .asciiz "unsortedList.txt"
    sorted_list_name: .asciiz "sorted_list.txt"
    
    sorted_list: .space 400
    .align 2
    lista_numerica: .space 400
.text

li index_sw, 0
li index_lb, 0
li index, 0
#========================================#

main:
    jal readFile                # function to load file into RAM and return to main
    jal toInteger               # perform CHAR to INTEGER convertion and return to main
    jal bubbleSort              # perform sort algorithm and return to main
    li $t0, 0                   # reset $t0 (index_lb) 
    jal writeFile               # write file and return to main
    j exit                      # perform exit program

#========================================#
toInteger:
    lb char, lista_numerica(index_lb)
    add index_lb, index_lb, 1
    beq char, '\0', store
    beq char ',', store
    beq char,'-', sinal
    sub digit, char, 0x30
    mul num, num 10
    add num, num, digit
    j toInteger
   
init:
    li num, 0
    li multiplicador, 1
    jal store

sinal:
    li multiplicador, -1
    j toInteger

store:
    mul num, num, multiplicador
    sw num, sorted_list(index_sw)
    add index_sw, index_sw, 4
    beq char, '\0', returnMain
    j init

returnMain:
	jr $ra

bubbleSort:
    la $s0, sorted_list         # load adress of lista_numerica
    lw $s1, tamanho             # store size of list
    li $t2, 1
    jal outerLoop
    jr $ra

outerLoop:
    li $t2, 0
    li $t3, 0

innerLoop:
    mul $t4, $t3, 4
    add $t5, $s0, $t4
    addi $t6, $t5, 4

    lw $t7, 0($t5)
    lw $t8, 0($t6)

    ble $t7, $t8, jump_if_sorted
    sw $t8, 0($t5)
    sw $t7, 0($t6)
    li $t2, 1

jump_if_sorted:
    addi $t3, $t3, 1
    blt $t3, $s1, innerLoop
    beqz $t2, end_jump
    jal outerLoop
  
end_jump:
	jr $ra

#========================================#
readFile:

    li $v0, 13                  # open file
    la $a0, unsorted_list_name  # file path
    li $a1, 0                   # read command 0
    syscall     

    move $s0, $v0               # copy descriptor
    move $a0, $s0               # save value in $a0

    li $v0, 14                  # read data pointed by $a0
    la $a1, lista_numerica      # buffer to store data
    li $a2, 400                 # buffer size
    syscall 
    
    li $v0, 4                   
    move $a0, $a1
    syscall

    # close file
    li $v0, 16
    move $a0, $s0
    syscall
	

writeFile:
    # Open (for writing) a file that does not exist
    li   $v0, 13                    # system call for open file
    la   $a0, sorted_list_name      # output file name
    li   $a1, 1                     # Open for writing (flags are 0: read, 1: write)
    li   $a2, 0                     # mode is ignored
    syscall                         # open a file (file descriptor returned in $v0)
    move $s6, $v0                   # save the file descriptor 

    # Write to file just opened
    li   $v0, 15                    # system call for write to file
    move $a0, $s6                   # file descriptor 
    la   $a1, sorted_list        # address of buffer from which to write
    li $a2, 401                     # hardcoded buffer length
    syscall                         # write to file
   
    # Close the file 
    li   $v0, 16                    # system call for close file
    move $a0, $s6                   # file descriptor to close
    syscall                         # close file
    
    jr $ra
    #faltou voltar pro programa aqui!!!
#========================================#
# End program
exit:
    li $v0, 10                      # Exit command
    syscall         