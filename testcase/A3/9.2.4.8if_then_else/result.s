main:
lui  $4, 0x7fff
ori $4, $4, 0xf4c0
sw $4, 0($4)
L8:
addi $6, $0, 0
lw $7, 0($4)
sw $6, -4($7)
lw $10, 0($4)
lw $9, -4($10)
addi $12, $0, 0
beq $9, $12, L1
L2:
addi $14, $0, 2
lw $15, 0($4)
sw $14, -4($15)
L3:
lw $18, 0($4)
lw $17, -4($18)
addi $20, $0, 0
beq $17, $20, L4
L5:
j L7
L1:
addi $23, $0, 1
lw $24, 0($4)
sw $23, -4($24)
j L3
L4:
addi $27, $0, 3
lw $28, 0($4)
sw $27, -4($28)
j L5
L7:
