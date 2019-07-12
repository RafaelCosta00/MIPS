#Extra credit covers binary to ASCII data type conversion (range -999 to +999)

.data

.align 0
space: .space 100	#stores number in ASCII format
promp:	.asciiz "Enter number between -999 and +999: "
promp2: .asciiz "The number entered is: "

.text

.globl main
main:

#Collect input
li $v0, 51
la $a0, promp
syscall

la $a1, space # a1 = string pointer

#$a0 - user input int
#$a1 - pointer to asciiz string
jal BinarytoASCII


#Print Decimal number
la $a0, promp2
li $v0, 59
syscall

exit:
li $v0, 10
syscall

#$a0 - user input int
#$a1 - pointer to asciiz string
BinarytoASCII:
addi $sp, $sp, -20
sw   $ra, 16($sp)

# set '+000' as default 
li   $t1, '0'
sb   $t1, 3($a1)
sb   $t1, 2($a1)
sb   $t1, 1($a1)
li   $t1, '+'
sb   $t1, 0($a1)
#if(input != 0) goto BinarytoASCIINotZero
bnez $a0, BinarytoASCIINotZero

move $v0, $a1

lw   $ra, 16($sp)
addi $sp, $sp, 20
jr   $ra

BinarytoASCIINotZero:
li   $t3, 3		#counter
#if(input > 0) goto BinarytoASCIIRepeat
bgtz $a0, whileloop
li   $t1, '-'
sb   $t1, 0($a1)	#replace '+' with '-'
neg  $a0, $a0		#set a0 to its negative (now positive)
  
whileloop:
# t3 = 3 (counter)
#if(counter == 0) goto loop done
beqz $t3, BinarytoASCIIExit

addi $t0, $zero, 10	# t0 = 10
div  $a0, $t0         	# a0/10
mflo $s0              	# s0 = quotient
mfhi $s1              	# s1 = remainder  

add  $t1, $a1, $t3	#update position of space (descending)
addi $t2, $s1, 0x30 	# convert to ASCII
sb   $t2, 0($t1)    	# store number in space
addi $t3, $t3, -1	#update counter
move $a0, $s0		#update number with quotient

j whileloop
  
BinarytoASCIIExit:
lw $ra, 16($sp) 
addi $sp, $sp, 20
jr $ra
