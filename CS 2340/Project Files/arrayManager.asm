.data
	# creating the necessary space for each array to store 16 word elements
	.globl contentArray
	contentArray: .space 64
	.globl keyArray
	keyArray: .space 64
	.globl randContentArray
	randContentArray: .space 64
	.globl randKeyArray
	randKeyArray: .space 64
	X: .word 5
	Y: .word 5
	

.text
	Start:
		la $t0, contentArray		# load base address of contentArray into $t0
		la $t1, keyArray			# load the base address of keyArray into $t1
		li $t2, 0					# set $t2 to be our index and start it at 0
		li $s0, 1					# the constant 1
		
	InitializeArrays:
		addi $t2, $t2, 1			# increment index
		li $v0, 41					# get ready to generate a random number within range
		li $a0, 0					
		syscall						# generate random int
		
		rem $a0, $a0, 5				# turn random number into int from 0 to 4
		add $a0, $a0, $s0			# increase rand int by 1 so now it goes from 1 to 5
		bgtz $a0, setX				# confirming that the random int was a positive number
		sub $a0, $zero, $a0			# if random int is negative, perform 0-randomInt to make it positive
		
		setX:
			sw $a0, X				# store random int into X
			lw $t3, X				# load content of X into $t3
		
		li $v0, 41					# get ready to generate a random number within range
		li $a0, 0					
		syscall						# generate random int
		
		rem $a0, $a0, 5				# turn random number into int from 0 to 4
		add $a0, $a0, $s0			# increase rand int by 1 so now it goes from 1 to 5
		bgtz $a0, setY 				# confirming that the random int was a positive number
		sub $a0, $zero, $a0			# if random int is negative, perform 0-randomInt to make it positive
		
		setY:
			sw $a0, Y				# store random int into Y
			lw $t4, Y				# load content of Y into $t4
		
		mul $t5, $t3, $t4			# multiply X and Y, then store the value in $t5
		sw $t5, 0($t0)				# put the product of X and Y into the content array
		sw $t5, 0($t1)				# put the product of X and Y into the key array
		
		addi $t0, $t0, 4			# move to the location of the next element in the content array
		addi $t1, $t1, 4			# move to the location of the next element in the key array
		
		addi $t6, $t3, 48			# add 48 to value of X to get its ASCII value
		addi $t7, $t4, 48			# add 48 to value of Y to get its ASCII value
		li $t8, 120					# ASCII value for 'x'
		
		sb $t6, 0($t0)				# store the string version of X value into content array
		addi $t0, $t0, 1			# move to the next BYTE in content array
		sb $t8, 0($t0)				# store the "x" into content array
		addi $t0, $t0, 1			# move to the next BYTE in content array
		sb $t7, 0($t0)				# store the string version of Y value into content array
		addi $t0, $t0, 1			# move to the next BYTE in the content array
		sb $zero, 0($t0)			# put null terminator to mark end of string
		
		sw $t5, 0($t1)				# put the product of X and Y into the key array
		
		addi $t0, $t0, 1			# move to the next BYTE (should now be next element) of content array
		addi $t1, $t1, 4			# move to the next element in key array
		
		blt $t2, 8, InitializeArrays	# loop back to beginning until the arrays are filled with 16 elements

		jal UserInput