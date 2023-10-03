  # timetemplate.asm
  # Written 2015 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

.macro	PUSH (%reg)
	addi	$sp,$sp,-4
	sw	%reg,0($sp)
.end_macro

.macro	POP (%reg)
	lw	%reg,0($sp)
	addi	$sp,$sp,4
.end_macro

	.data
	.align 2
mytime:	.word 0x5957
timstr:	.ascii "text more text lots of text\0"
	.text
main:
	# print timstr
	la	$a0,timstr
	li	$v0,4
	syscall
	nop
	# wait a little
	li	$a0,2
	jal	delay
	nop
	# call tick
	la	$a0,mytime
	jal	tick
	nop
	# call your function time2string
	la	$a0,timstr
	la	$t0,mytime
	lw 	$a1,0($t0)
	jal	time2string
	nop
	# print a newline
	li	$a0,10
	li	$v0,11
	syscall
	nop
	# go back and do it all again
	j	main
	nop
# tick: update time pointed to by $a0
tick:	lw	$t0,0($a0)	# get time
	addiu	$t0,$t0,1	# increase
	andi	$t1,$t0,0xf	# check lowest digit
	sltiu	$t2,$t1,0xa	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x6	# adjust lowest digit
	andi	$t1,$t0,0xf0	# check next digit
	sltiu	$t2,$t1,0x60	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa0	# adjust digit
	andi	$t1,$t0,0xf00	# check minute digit
	sltiu	$t2,$t1,0xa00	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x600	# adjust digit
	andi	$t1,$t0,0xf000	# check last digit
	sltiu	$t2,$t1,0x6000	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa000	# adjust last digit
tiend:	sw	$t0,0($a0)	# save updated result
	jr	$ra		# return
	nop

  # you can write your code for subroutine "hexasc" below this line
  #
hexasc:
	li $v0, 0		# Reset $v0 to zero

	andi $t1, $a0, 0x0F 	# Keep only the 4 least significant bits
	
	ble $t1, 9, digit 	# If the output should be a digit
	
	addi $v0, $t1, 0x37 	# The argument is 10 or larger
			    	# The output should be a letter
	jr $ra
	
	digit:
		addi $v0, $t1, 0x30
		jr $ra
		
delay:
	
	while:
		blez $a0, whiledone
		nop
	
		addi $a0, $a0, -1
		
		li $t1, 0	# int i = 0
		
		li $t2, 4711	# Loop constant
	
		for:
			beq $t1, $t2, while
			nop
			
			addi $t1, $t1, 1
			j for
			nop
	whiledone:
	
	jr $ra
	nop
	
time2string:
	PUSH ($ra)
	move $s0, $a0 	# Save the memory address in $s0
	
	move $a0, $a1		# Give mytime to $a0
	srl $a0, $a0, 12	# Align the minutes tens-digit
	jal hexasc
	nop
	sb $v0, 0($s0)		# Write to the memory address
	
	move $a0, $a1		# Give mytime to $a0
	srl $a0, $a0, 8		# Align the minutes ones-digit
	jal hexasc
	nop
	sb $v0, 1($s0)		# Write to the memory address

	li $t3, 0x3A		# Load the colon into $t3
	sb $t3, 2($s0)		# Store the colon			

	move $a0, $a1		# Give mytime to $a0
	srl $a0, $a0, 4		# Align the seconds tens-digit
	jal hexasc
	nop
	sb $v0, 3($s0)		# Write to the memory address
	
	move $a0, $a1		# Give mytime to $a0
	jal hexasc
	nop
	sb $v0, 4($s0)		# Write to the memory address

	li $t3, 0x00		# Load the null byte
	sb $t3, 5($s0)		# Store the null byte
	
	move $a0, $s0
	POP ($ra)
	jr $ra
	nop