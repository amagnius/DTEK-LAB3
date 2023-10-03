  # labwork.S
  # Written 2015-2017 by F Lundevall
  # Skeleton file for IS1200/IS1500 lab 1.
  # The macros PUSH and POP are in the public domain.
  # Please add your own code at the end of the file.

  #
  # Please keep the two macros PUSH and POP unchanged
  #
.macro	PUSH reg
	addi	$sp,$sp,-4
	sw	\reg,0($sp)
.endm

.macro	POP reg
	lw	\reg,0($sp)
	addi	$sp,$sp,4
.endm
  #
  # Please add your own code below this line
  #

	.data
	.text
	.global hexasc

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

	.global delay
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
	
	.global time2string
time2string:
	PUSH $ra
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

	move $t4, $v0		# LAB: Save tens-digit in $t4

	sb $v0, 3($s0)		# Write to the memory address
	
	move $a0, $a1		# Give mytime to $a0
	jal hexasc
	nop

	move $t5, $v0		# LAB: Save ones-digit in $t5

	sb $v0, 4($s0)		# Write to the memory address

	add $t6, $t4, $t5
	li $t7, 0x60
	beq $t6, $t7, DING
	nop

	li $t3, 0x00		# Load the null byte
	sb $t3, 5($s0)		# Store the null byte
	
	move $a0, $s0
	POP $ra
	jr $ra
	nop

	DING:
		li $t1, 0x44
		li $t2, 0x49
		li $t3, 0x4E
		li $t4, 0x47
		li $t5, 0x00

		sb $t1, 0($s0)
		sb $t2, 1($s0)
		sb $t3, 2($s0)
		sb $t4, 3($s0)
		sb $t5, 4($s0)

		POP $ra
		jr $ra
		nop

enable_interrupt:
	ei
	jr $ra