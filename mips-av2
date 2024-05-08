.eqv index_lb $t0
.eqv multiplicador $t1
.eqv index_sw $t2
.eqv index $t3
.eqv char $s0
.eqv num $s2
.eqv digit $s3

.eqv index_num $s1
.eqv digito $s2
.eqv index_lw $a0
.eqv divisor $a1
.eqv index_sto $t9

# ========================================= #
.data
.align 2
    virgula: .ascii ", "
.align 2
    menos: .ascii "-"
.align 2
    numToChar: .space 400
.align 2
    numero: .space 4
    tamanho: .word 100
    unsorted_list_name: .asciiz "unsorted_list.txt"
    sorted_list_name:   .asciiz "sorted_list.txt"

    .align 2
    sorted_list:     .space 400
    .align 2
    lista_numerica:     .space 400
    .align 2
    writeList: .space 400
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
       
    jal Sort  
     
    escreve:                   # perform sort algorithm and return to main
    li index_sw, 0
    li index_lb, 0
    li index, 0
    jal initToChar
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
    sw num, sorted_list(index_sw)    #
    add index_sw, index_sw, 4           #
    beq char, '\0', end_toInteger       #
    j init                              #

end_toInteger:
	jr $ra                              # return to caller 

# ======================================== #
# convert to char
initToChar:
# inicializa
    li $t0 , 0 
    lw $t1 , tamanho
    li index_lw, 0

toChar:
    beq $t0, $t1, return
    addi $t0, $t0, 1
    li divisor , 10
    lw $t3, sorted_list(index_lw)
    addi index_lw, index_lw, 4
    li index_num, 0
    blt $t3, 0, negativo

# loop numero positivo
loop:	
    # vai fazer o loop do numero, se achar que o digito e  /0 vai pegar os registradores e armazenar em num to char
    div $t3, divisor
    mflo $t3
    mfhi digito
    addi digito, digito, 0x30 #adiciona 30 para tabela ascii
    sw digito, numero(index_num)
    beqz $t3, exitloop #exitloop sem sinal negativo
    addi index_num, index_num, 4
    j loop

negativo: # caso o numero seja negativo ele multiplica por 2
    li divisor , 10

loopN:
# vai fazer o loop do numero, se achar que o digito e  /0 vai pegar os registradores e armazenar em num to char
    div $t3, divisor
    mflo $t3
    mfhi digito
    mul digito, digito, -1
    addi digito, digito, 0x30 #adiciona 30 para tabela ascii
    sw digito, numero(index_num)
    beqz $t3, exitloopN
    addi index_num, index_num, 4
    j loopN

exitloopN:
# tem que salvar o "-" e  incrementar o index de store
    lw $s4, menos
    sb $s4, numToChar(index_sto)
    addi index_sto, index_sto, 1

exitloop:
    lw  $s3, numero(index_num)
    beq $s3, 0, separador #caso nao esteja mandando  o numero completo, joga isso aqui pro fianla 

    sb $s3, numToChar(index_sto)
    sub index_num, index_num, 4
    addi index_sto, index_sto, 1

# salva a virgula
j exitloop

separador:
beq $t0, $t1, return
lw $s4, virgula
sb $s4, numToChar(index_sto)
addi index_sto, index_sto, 1
j toChar
jr $ra

# ============================================================== #
return:
	jr $ra                              # return to caller
# ============================================================== #
#Sorting Algorithm
Sort:
la 		$s7, sorted_list                # endereco dos numeros

li	 	$s0, 0                          # counter loop 1
la		$s6, tamanho
lw		$s6, 0($s6)
sub		$s6, $s6, 1                     # comecando no 0 e indo ate n-1

li 		$s1, 0                          # counter do loop 2

li		$t3, 0  
la		$t4, tamanho
lw		$t4, 0($t4)			            # counter do print



bubbleSort:
    sll 	$t7, $s1, 2                 # multiplica s1 por 2 e bota em t7
    add		$t7, $s7, $t7               # adiciona os enderecos a t7

    lw		$t0, 0($t7)                 # carrega primeiro numero {n}
    lw 		$t1, 4($t7)                 # carrega segundo numero {n+1}

    slt 	$t2, $t0, $t1               # se t0 < t1
    bne 	$t2, $zero, increment

    sw 		$t1, 0($t7)                 # troca os numeros
    sw 		$t0, 4($t7)

increment:

    addi 	$s1, $s1, 1                	# incrementa t1
    sub 	$s5, $s6, $s0               # subtrai s0  de s6 e armazena

    bne  	$s1, $s5, bubbleSort       	# se o contador nao for igual ao tamanho -1 ele continua
    addi 	$s0, $s0, 1                 # incrementa o s0 se for falso
    li 		$s1, 0                     	# reseta s1

    bne 	$s0, $s6, bubbleSort     	# volta o loop pra ordenar novamente os numeros

jr $ra

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
    la   $a1, numToChar                 # address of buffer from which to write
    li $a2, 400                         # hardcoded buffer length
    syscall                             # write to file

    # Close the file 
    li   $v0, 16                        # system call for close file
    move $a0, $s6                       # file descriptor to close
    syscall                             # close file

    jr $ra                              # return call
#========================================#

#End program
exit:
    li $v0, 10                          # Exit command
    syscall
