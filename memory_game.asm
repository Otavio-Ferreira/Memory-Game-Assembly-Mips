.data

board: .word 1,2,3,4,1,2,3,4,5,6,7,8,5,6,7,8

revealed: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

msg_first_row: .asciiz "Enter the row coordinate of first card: "
msg_first_column: .asciiz "Enter the column coordinate of first card: "
msg_second_row: .asciiz "Enter the row coordinate of second card: "
msg_second_column: .asciiz "Enter the column coordinate of second card: "
msg_match: .asciiz "Match found! \n\n"
msg_dont_match: .asciiz "No match! \n\n"
msg_all_pairs_find: .asciiz "Congratulations! You found all pairs!"
msg_already_exists: .asciiz "\nThe entered pair has already been chosen! Try again! \n\n"
msg_invalid_input: .asciiz "\nThe number must be between 0 and 3! Try again! \n\n"

hidden_symbol: .ascii "*"

pairsLeft: .word 8

cl: .asciiz "\n"
cl2: .asciiz "\n\n"
space: .asciiz " "

.text

main:
    # Variável global 'pairsLeft' para condição do while 
    la $t6, pairsLeft
    lw $t7, 0($t6)
While:
    # Condição do while pairsLeft <= 0
    blez $t7, Exit
    
    # Printar o tabuleiro
    jal PrintBoard
    la $a0, cl2 
    syscall

    # Pergunta a linha do primeiro digito
    li $v0, 4
    la $a0, msg_first_row
    syscall

    # Ler a linha do primeiro digito
    li $v0, 5      
    syscall
    move $s1, $v0
    
    # Validação do número digitado
    blt $s1, 0, IfNumberValidationFirstCase
    bgt $s1, 3, IfNumberValidationFirstCase

    # Pergunta a coluna do segundo digito
    li $v0, 4
    la $a0, msg_first_column
    syscall
    
    # Ler a coluna do primeiro digito
    li $v0, 5
    syscall
    move $s2, $v0  
    
    # Validação do número digitado
    blt $s2, 0, IfNumberValidationFirstCase
    bgt $s2, 3, IfNumberValidationFirstCase
    
    # Leitura em revealed da posição digitada
    mul $t0, $s1, 4
    add $t0, $t0, $s2
    sll $t0, $t0, 2
    la $t1, revealed
    add $t0, $t1, $t0
    
    # Validação se a posição ja foi escolhida
    lw $gp, 0($t0)
    beq $gp, 1, IfNumberIsAlreadySelectedFirstCase
    
    # Marcar a posição digitada em revealed com 1
    li $t2, 1
    sw $t2, 0($t0)
    move $t8, $t0
    
    # Printar o tabuleiro
    jal PrintBoard
    la $a0, cl2 
    syscall

    # Pergunta a linha do segundo digito
    li $v0, 4
    la $a0, msg_second_row
    syscall
    
    # Ler a linha do segundo digito
    li $v0, 5
    syscall
    move $s3, $v0

    # Validação do número digitado
    blt $s3, 0, IfNumberValidationSecondCase
    bgt $s3, 3, IfNumberValidationSecondCase

    li $v0, 4
    la $a0, msg_second_column
    syscall
    
    li $v0, 5
    syscall
    move $s4, $v0
    
    # Validação do número digitado
    blt $s4, 0, IfNumberValidationSecondCase
    bgt $s4, 3, IfNumberValidationSecondCase
    
    mul $t0, $s3, 4
    add $t0, $t0, $s4
    sll $t0, $t0, 2
    la $t1 revealed
    add $t0, $t1, $t0
    
    # Validação se a posição ja foi escolhida
    lw $gp, 0($t0)
    beq $gp, 1, IfNumberIsAlreadySelectedSecondCase
    
    # Marcar a posição digitada em revealed com 1
    li $t3, 1
    sw $t3, 0($t0)
    move $t9, $t0
    
    # Printar o tabuleiro
    jal PrintBoard
    la $a0, cl2 
    syscall

    # Verificar se as posições escolhidas são iguais
    jal checkMatch
    
    # Se forem iguais chama a função MatchFound
    beq $k0, 1, MatchFound

    # Se não forem iguais
    NotMatch:
    	# Printar menssagem referente a quando os pares não são iguais
    	li $v0, 4
    	la $a0, msg_dont_match
    	syscall

	# Colocar 0 novamente nas posições digitadas em revealed
    	li $a1, 0
    	sw $a1, 0($t8)
    	sw $a1, 0($t9)

	# Pular para a função Continue
    	j Continue
	
    # Função caso os pares sejam iguais
    MatchFound:
    	# Decrementar 'pairsLeft'
    	sub $t7, $t7, 1
    	sw $t7, 0($t6)

	# Printar menssagem referente a quando os pares são iguais
    	li $v0, 4
    	la $a0, msg_match
    	syscall
    
    # Pular para a função Continue
    Continue:
    	j While

# Função após sair do loop do while
Exit:
    # Printar menssagem referente a quando todos os pares são encontrados
    li $v0, 4
    la $a0, msg_all_pairs_find
    syscall

    li $v0, 10
    syscall

# Função que verifica as posições digitadas
checkMatch:

    # Carregar de board a primeira posição escolhida
    mul $t0, $s1, 4
    add $t0, $t0, $s2
    sll $t0, $t0, 2
    la $t1, board
    add $t0, $t1, $t0
    lw $t4, 0($t0)
    
    # Carregar de board a segunda posição escolhida
    mul $t0, $s3, 4
    add $t0, $t0, $s4
    sll $t0, $t0, 2
    la $t1, board
    add $t0, $t1, $t0
    lw $t5, 0($t0)

    # Comparar os valores se não forem iguais chama a função NotMatchCheck
    bne $t4, $t5, NotMatchCheck
    
    # Se forem iguais salva 1 em $k0 para a condição
    li $k0, 1
    jr $ra

# Se não forem iguais salva 0 em $k0 para condição
NotMatchCheck:
    li $k0, 0
    jr $ra

# Função que printa o tabuleiro
PrintBoard:
    addi $s0, $zero, 0

    begin_for_i:
    	bge $s0, 4, end_for_i

    	li $v0, 4
    	la $a0, cl
    	syscall

    	addi $k1, $zero, 0

    begin_for_j:
    	bge $k1, 4, end_for_j

    	sll $t0, $s0, 2
    	add $t0, $k1, $t0
    	sll $t0, $t0, 2

    	la $t1, revealed
    	add $t2, $t1, $t0
    	lw $t3, 0($t2)

    	bne $t3, $zero, print_number

    	li $v0, 4
    	la $a0, hidden_symbol
    	syscall
    	j continue_j

    print_number:
    	la $t1, board
    	add $t2, $t1, $t0
    	lw $a0, 0($t2)
    
    	li $v0, 1
    	syscall

    continue_j:
    	li $v0, 4
    	la $a0, space
    	syscall

    	addi $k1, $k1, 1
    	j begin_for_j

    end_for_j:
    	addi $s0, $s0, 1
    	j begin_for_i

    end_for_i:
    	jr $ra

# Função que verifica se a primeira posição digitada ja foi rervelada
IfNumberIsAlreadySelectedFirstCase:
    li $v0, 4
    la $a0, msg_already_exists
    syscall
    j While

# Função que verifica se a segunda posição digitada ja foi rervelada
IfNumberIsAlreadySelectedSecondCase:
    li $v0, 4
    la $a0, msg_already_exists
    syscall
    
    li $a1, 0
    sw $a1, 0($t8)
    
    j While

# Função que verifica se a linha ou coluna da primeira posição digitada esta entre 0 e 3
IfNumberValidationFirstCase:
    li $v0, 4
    la $a0, msg_invalid_input
    syscall
    j While

# Função que verifica se a linha ou coluna da segunda posição digitada esta entre 0 e 3    
IfNumberValidationSecondCase:
    li $v0, 4
    la $a0, msg_invalid_input
    syscall
    
    li $a1, 0
    sw $a1, 0($t8)
    
    j While
