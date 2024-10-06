.globl UserInput

.data
	prompt1: .asciiz "\nEnter 1st coordinate (A-D, 1-4): "
	prompt2: .asciiz "\nEnter 2nd coordinate (A-D, 1-4): "
	not_match: .asciiz "\nNot a match!"
	match: .asciiz "\nIt's a match!"
	invalid: .asciiz "\nInvalid coordinate. Reenter the coordinate (A-D, 1-4)."
	value_message: .asciiz "The value at this coordinate is: "
	newline: .asciiz "\n"
	
.text
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
