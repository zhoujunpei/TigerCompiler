BEGIN L1
L8:
addi $6, $0, 1
lw $7, 0($4)
sw $6, -4($7)
addi $9, $0, 1
lw $10, 0($4)
sw $9, -8($10)
addi $12, $0, 0
lw $13, 0($4)
sw $12, -12($13)
L3:
addi $16, $0, 1
add $5, $16, $0
lw $18, 0($4)
lw $17, 4($18)
addi $20, $0, 2
sub $21, $17, $20
bgtz $21, L5
L6:
addi $23, $0, 0
add $5, $23, $0
L5:
addi $25, $0, 0
beq $5, $25, L2
L4:
lw $29, 0($4)
lw $28, 4($29)
subi $28, $28, 1
lw $32, 0($4)
lw $31, -8($32)
lw $34, 0($4)
sw $31, -12($34)
lw $37, 0($4)
lw $36, -4($37)
lw $39, 0($4)
sw $36, -8($39)
lw $43, 0($4)
lw $42, -12($43)
lw $46, 0($4)
lw $45, -8($46)
add $42, $45, $42
lw $48, 0($4)
sw $42, -4($48)
j L3
L2:
lw $52, 0($4)
lw $51, -4($52)
j L7
L7:
END L1

main:
lui  $4, 0x7fff
ori $4, $4, 0xf4c0
sw $4, 0($4)
L10:
addi $57, $0, 0
lw $58, 0($4)
sw $57, -4($58)
addi $60, $0, 0
lw $61, 0($4)
sw $60, -8($61)
lw $65, 0($4)
addi $65, $65, fffffff8
add $56, $65, $0
lw $70, 0($1)
addi $71, $0, 4
sw $71, 4($70)
sw $4, 0($70)
subi $70, $70, 4
sw $70, 0($1)
call L1
lw $79, 0($1)
addi $79, $79, 4
sw $79, 0($1)
add $55, $L1, $0
sw $55, 0($56)
j L9
L9:
