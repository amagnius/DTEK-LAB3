  # hexmain.asm
  # Written 2015-09-04 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

	.text
main:
	li	$a0, 17		# change this to test different values

	jal	hexasc		# call hexasc
	nop			# delay slot filler (just in case)	

	move	$a0,$v0		# copy return value to argument register

	li	$v0,11		# syscall with v0 = 11 will print out
	syscall			# one byte from a0 to the Run I/O window
	
stop:	j	stop		# stop after one run
	nop			# delay slot filler (just in case)

  # You can write your own code for hexasc here
  #
hexasc:
	andi $t1, $a0, 0x0F 	# Keep only the 4 least significant bits
	
	ble $t1, 9, digit 	# If the output should be a digit
	
	addi $v0, $t1, 0x37 	# The argument is 10 or larger
			    	# The output should be a letter
	jr $ra
	
	digit:
		addi $v0, $t1, 0x30
		jr $ra
	
	
	
	
