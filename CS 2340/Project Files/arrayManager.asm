.data
	# creating the necessary space for each array to store 16 word elements
	contentArray: .space 64
	keyArray: .space 64
	randContentArray: .space 64
	randKeyArray: .space 64
	X: .word 5
	Y: .word 5
	prompt1: .asciiz "\nEnter 1st coordinate (A-D, 1-4): "
	prompt2: .asciiz "\nEnter 2nd coordinate (A-D, 1-4): "
	not_match: .asciiz "\nNot a match!"
	match: .asciiz "\nIt's a match!"
	invalid: .asciiz "\nInvalid coordinate. Reenter the coordinate (A-D, 1-4)."
	value_message: .asciiz "The value at this coordinate is: "
	newline: .asciiz "\n"

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

	# User Input Section
	UserInput:
		# Prompt user for the 1st coordinate
		li $v0, 4					# print string syscall
		la $a0, prompt1				# load 1st prompt message
		syscall
		
		li $v0, 12					# read character syscall (column)
		syscall
		move $t6, $v0				# store character (column) into $t6
		
		li $v0, 5					# read integer syscall (row)
		syscall
		move $t7, $v0				# store integer (row) into $t7
		
		# Convert coordinates into an index
		li $t9, 'A'
		sub $t6, $t6, $t9			# convert char A-D to 0-3
		
		blt $t6, 0, invalid_input	# check for invalid input (column out of range)
		bgt $t6, 3, invalid_input	# check for invalid input (column out of range)
		blt $t7, 1, invalid_input	# check for invalid input (row out of range)
		bgt $t7, 4, invalid_input	# check for invalid input (row out of range)
		
		sub $t7, $t7, 1				# row starts from 0
		mul $t7, $t7, 4				# row * 4 to get row index offset
		add $t7, $t7, $t6			# final index = row index + column index
		mul $t7, $t7, 4				# convert index to byte offset (word = 4 bytes)
		
		# Load the value from the key array at 1st coordinate
		la $t1, keyArray
		add $t1, $t1, $t7			# calculate address
		lw $t8, 0($t1)				# load value
		
		# Load and print the value from the content array at 1st coordinate
    		la $t1, contentArray
    		add $t1, $t1, $t7            # Calculate address
    		lw $a1, 0($t1)               # Load content value
   		li $v0, 4                     # print string syscall
    		la $a0, value_message         # load "The value at this coordinate is: "
    		syscall
    
    		li $v0, 1                     # print integer syscall
    		move $a0, $t8                 # move the value to $a0
    		syscall
    
    		li $v0, 4                     # print string syscall for newline
    		la $a0, newline               # load newline
    		syscall
    
		# Prompt user for the 2nd coordinate (repeat process)
		li $v0, 4					# print string syscall
		la $a0, prompt2				# load 2nd prompt message
		syscall
		
		li $v0, 12					# read character syscall (column)
		syscall
		move $t6, $v0				# store character (column) into $t6
		
		li $v0, 5					# read integer syscall (row)
		syscall
		move $t7, $v0				# store integer (row) into $t7
		
		# Convert coordinates into an index
		li $t9, 'A'
		sub $t6, $t6, $t9			# convert char A-D to 0-3
		
		blt $t6, 0, invalid_input	# check for invalid input (column out of range)
		bgt $t6, 3, invalid_input	# check for invalid input (column out of range)
		blt $t7, 1, invalid_input	# check for invalid input (row out of range)
		bgt $t7, 4, invalid_input	# check for invalid input (row out of range)
		
		sub $t7, $t7, 1				# row starts from 0
		mul $t7, $t7, 4				# row * 4 to get row index offset
		add $t7, $t7, $t6			# final index = row index + column index
		mul $t7, $t7, 4				# convert index to byte offset (word = 4 bytes)
		
		# Load the value from the key array at 2nd coordinate
		la $t1, keyArray
		add $t1, $t1, $t7			# calculate address
		lw $t9, 0($t1)				# load value
		
		# Load and print the value from the content array at 2nd coordinate
    		la $t1, contentArray
    		add $t1, $t1, $t7             # Calculate address
    		lw $a2, 0($t1)                # Load content value
    		li $v0, 4                     # print string syscall
    		la $a0, value_message         # load "The value at this coordinate is: "
    		syscall
    
    		li $v0, 1                     # print integer syscall
    		move $a0, $a2                 # move the value to $a0
    		syscall
    
    		li $v0, 4                     # print string syscall for newline
    		la $a0, newline               # load newline
    		syscall
		
		# Check if the two coordinates match
		beq $t8, $t9, match_found
		li $v0, 4					# print string syscall
		la $a0, not_match			# load "Not a match!" message
		syscall
		b UserInput					# repeat the input process
		
	match_found:
		li $v0, 4					# print string syscall
		la $a0, match				# load "It's a match!" message
		syscall
		b End						# terminate program

	invalid_input:
		li $v0, 4					# print string syscall
		la $a0, invalid				# load invalid message
		syscall
		b UserInput					# ask for input again

	End:
		li $v0, 10					# exit program
		syscall
