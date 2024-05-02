.eqv index_lb $t0
.eqv multiplicador $t1
.eqv index_sw $t2
.eqv index $t3
.eqv char $s0
.eqv digit $s0
.eqv num $s2

# ========================================#
# Initialize Variables

.data
    tamanho: .word 100
    concatenarLinha: .asciiz ", "
    unsorted_list_name: .asciiz "unsortedList.txt"
    sorted_list_name: .asciiz "sorted_list.txt"

    unsorted_list: .space 400
    .align 2
    lista_numerica: .space 400
.text

li index_sw, 0
li index_lb, 0
li index, 0

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
    la   $a1, lista_numerica        # address of buffer from which to write
    li $a2, 401                     # hardcoded buffer length
    syscall                         # write to file
   
    # Close the file 
    li   $v0, 16                    # system call for close file
    move $a0, $s6                   # file descriptor to close
    syscall                         # close file
    j exit

# ========================================#
# End program
exit:
    li $v0, 10                      # Exit command
    syscall         