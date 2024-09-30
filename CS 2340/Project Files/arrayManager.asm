.data
	# creating the necessary space for each array to store 16 word elements
	contentArray: .space 64
	keyArray: .space 64
	randContentArray: .space 64
	randKeyArray: .space 64
	X: .word 5
	Y: .word 5

.text
	Start:
		la $t0, contentArray		# load base address of contentArray into $t0
		la $t1, keyArray			# load the base address of keyArray into $t1
		li $t2, 0					# set $t2 to be our index and start it at 0
		li $s0, 1					# the constant 1
		
		
	InitizalizeArrays:
		li $v0, 41					# get ready to generate a random number within range
		li $a0, 0					
		syscall					# generate random int
		
		rem $a0, $a0, 5			# turn random number into int from 0 to 4
		add $a0, $a0, $s0			# increase rand int by 1 so now it goes from 1 to 5
		bgtz $a0, setX			# confirming that the random int was a positive number
		sub $a0, $zero, $a0		# if random int is negative, perform 0-randomInt to make it positive
		
		setX:
			sw $a0, X			# store random int into X
			lw $t3, X				# load content of X into $t3
		
		
		li $v0, 41					# get ready to generate a random number within range
		li $a0, 0					
		syscall					# generate random int
		
		rem $a0, $a0, 5			# turn random number into int from 0 to 4
		add $a0, $a0, $s0			# increase rand int by 1 so now it goes from 1 to 5
		bgtz $a0, setY 			# confirming that the random int was a positive number
		sub $a0, $zero, $a0		# if random int is negative, perform 0-randomInt to make it positive
		
		setY:
			sw $a0, Y			# store random int into Y
			lw $t4, Y				# load content of Y into $t4
			
			
		li $v0, 1
		lw $a0, X
		syscall
		
		li $v0, 1
		lw $a0, Y
		syscall
