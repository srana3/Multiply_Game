.data
	# creating the necessary space for each array to store 16 word elements
	contentArray: .space 64
	keyArray: .space 64
	randContentArray: .space 64
	randKeyArray: .space 64
	X: .word 5
	Y: .word 5
	prompt1: .asciiz "Enter 1st coordinate (A-D, 1-4): "
	prompt2: .asciiz "Enter 1st coordinate (A-D, 1-4): "
	not_match: .asciiz "Not a match!\n"
	match: .asciiz "It's a match!\n"
	invalid: .asciiz "Invalid coordinate. Reenter the coordinate (A-D, 1-4).\n"

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
		
	UserInput:
		# prompt user for the first coordinate
		li $v0, 4		# print string syscall
		la $a0, prompt1		# load 1st prompt message
		syscall
		
		li $v0, 12		# read character syscall (column)
		syscall
		move $t6, $v0		# move character into register $t6
		
		li $v0, 5		# read integer syscall (row)
		syscall
		move $t6, $v0		# move integer into register $t6
		
		# convert coordinate to index
		# A = 0, B = 1, C = 2, D = 3
		li $t7, 'A'
		sub $t7, $t5, $t7	# entered char - A ascii value
		
		# check if input is out of range
		blt $t7, 0, is_invalid	# column < 0
		bgt $t7, 3, is_invalid	# column > 3
		blt $t6, 1, is_invalid	# row < 1
		bgt $t6, 4, is_invalid	# row > 4
		
		# compute index
		sub $t6, $t6, 1		# starts the row indexes from 0
		mul $t6, $t6, 4		# row * 4
		add $t6, $t6, $t7	# add column to get final index
		
		# load 1st value in the content array
		la $t0, contentArray
		mul $t6, $t6, 4		# multiply index by 4 to get offset
		add $t7, $t0, $t6	# calculate address
		lw $t8, 0($t7)		# load value from contentArray at index $t6
		
		# prompt user for the 2nd coordinate (REPEATED PROCESS)
		li $v0, 4		# print string syscall
		la $a0, prompt2		# load prompt message for 2nd coordinate
		syscall

		li $v0, 12		# read character syscall (for column A-D)
		syscall
		move $t5, $v0		# store column character in $t5

		li $v0, 5		# read integer syscall (for row 1-4)
		syscall
		move $t6, $v0		# store row number in $t6

		# convert the second coordinate to index
		li $t7, 'A'
		sub $t7, $t5, $t7	

		# check if input is valid
		blt $t7, 0, is_invalid	
		bgt $t7, 3, is_invalid	
		blt $t6, 1, is_invalid	
		bgt $t6, 4, is_invalid	

		# compute index
		sub $t6, $t6, 1			
		mul $t6, $t6, 4			
		add $t6, $t6, $t7			

		# load the value of the content array at the 2nd coordinate
		la $t0, contentArray
		mul $t6, $t6, 4				
		add $t7, $t0, $t6			
		lw $t8, 0($t7)				

		# load 1st and 2nd coordinate and compare
		# $t3 has the first index, $t6 has the 2nd index
		
		# load key for 1st coordinate
		la $t0, keyArray	# load the base address of keyArray
		mul $t3, $t3, 4		# multiply the 1st index by 4 to get the offset
		add $t9, $t0, $t3	# calculate the address in keyArray
		lw $t9, 0($t9)		# load the key from keyArray at the 1st coordinate

		# load key for 2nd coordinate (using $t6, which holds the second index)
		la $t0, keyArray	# load the base address of keyArray
		mul $t6, $t6, 4		# multiply the 2nd index by 4 to get the offset
		add $t7, $t0, $t6	# calculate the address in keyArray
		lw $t7, 0($t7)		# load the key from keyArray at the 2nd coordinate

		# compare keys
		beq $t9, $t7, is_match	# if the keys match, jump to match
		j is_not_match		# if the keys don't match, jump to not_match

	is_match:
		li $v0, 4		# syscall to print a string
		la $a0, match		# load the address of the match message
		syscall			# print the match message
		j End			# jump to the end of the program

	is_not_match:
		li $v0, 4		# syscall to print a string
		la $a0, not_match	# load the address of the not a match message
		syscall			# print the not match message
		j End			# jump to the end of the program

	is_invalid:
		li $v0, 4		# syscall to print a string
		la $a0, invalid		# load the address of the invalid input message
		syscall			# print the invalid input message
		j UserInput		# go back to asking input

	End:
		li $v0, 10		# exit syscall
		syscall
