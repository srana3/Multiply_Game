.globl UserInput
	
.text
# User Input Section
	UserInput:
		jal OptionDisplay
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
		add $a1, $t7, $zero			# store the index number into a temp variable for use in the display code
		mul $t7, $t7, 4				# convert index to byte offset (word = 4 bytes)
		
		# Load the value from the key array at 1st coordinate
		la $t1, randKeyArray
		add $t1, $t1, $t7			# calculate address
		lw $t8, 0($t1)				# load value
		
		jal SelectionDisplay1
    
		# Prompt user for the 2nd coordinate (repeat process)
		li $v0, 4					# print string syscall
		la $a0, prompt2				# load 2nd prompt message
		syscall
		
		li $v0, 12					# read character syscall (column)
		syscall
		move $t6, $v0				# store character (column) into $t6
		
		li $v0, 5					# read integer syscall (row)
		syscall
		move $t2, $v0				# store integer (row) into $t7
		
		# Convert coordinates into an index
		li $t9, 'A'
		sub $t6, $t6, $t9			# convert char A-D to 0-3
		
		blt $t6, 0, invalid_input	# check for invalid input (column out of range)
		bgt $t6, 3, invalid_input	# check for invalid input (column out of range)
		blt $t2, 1, invalid_input	# check for invalid input (row out of range)
		bgt $t2, 4, invalid_input	# check for invalid input (row out of range)
		
		sub $t2, $t2, 1				# row starts from 0
		mul $t2, $t2, 4				# row * 4 to get row index offset
		add $t2, $t2, $t6			# final index = row index + column index
		add $a2, $t2, $zero			# store the index number into a temp variable for use in the display code
		mul $t2, $t2, 4				# convert index to byte offset (word = 4 bytes)
		
		# Load the value from the key array at 2nd coordinate
		la $t1, randKeyArray
		add $t1, $t1, $t2			# calculate address
		lw $t9, 0($t1)				# load value
		
		jal SelectionDisplay2
		
		# Check if the two coordinates match
		beq $t8, $t9, match_found
		li $v0, 4					# print string syscall
		la $a0, not_match			# load "Not a match!" message
		syscall
		jal NoMatchSound		# play no match sound
		b UserInput					# repeat the input process
		
	match_found:
		li $a3, -1
		la $t1, randKeyArray
		add $t1, $t1, $t7
		sw $a3, 0($t1)
		la $t1, randKeyArray
		add $t1, $t1, $t2
		sw $a3, 0($t1)
		li $v0, 4					# print string syscall
		la $a0, match				# load "It's a match!" message
		syscall
		
		jal check_timer
		
		# Play match sound
		jal MatchSound
    
		lw $t0, numMatches            # Load the current match count
		addi $t0, $t0, 1            	# Increment match counter
    		sw $t0, numMatches           	# Store updated match count
    		
    		# Print the number of matches found so far
		li $v0, 4					# print string syscall
		la $a0, match_count_message	# load "Number of matches: " message
		syscall
		
		li $v0, 1					# print integer syscall
		move $a0, $t0				# move the match count to $a0
		syscall
		
		li $v0, 4					# print string syscall for newline
		la $a0, newline				# load newline
		syscall
    		
    		# Check if 8 matches are found
    		bne $t0, 8, UserInput      # If less than 8 matches, continue

    		# If 8 matches are made, go to EndGame
    		jal EndGame

	invalid_input:
		li $v0, 4					# print string syscall
		la $a0, invalid				# load invalid message
		syscall
		b UserInput					# ask for input again
		
