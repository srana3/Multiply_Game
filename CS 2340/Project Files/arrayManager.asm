.globl Start

.text
	Start:
		la $s0, contentArray			# load base address of contentArray into $s0
		la $s1, keyArray			# load the base address of keyArray into $s1
		li $s2, 0				# set $s2 to be our index and start it at 0
		li $s3, 1				# the constant 1
		li $s4, 120
		li $s7, '0'

	InitializeArrays:
		addi $s2, $s2, 1			# increment index
		li $v0, 41				# get ready to generate a random number within range
		li $a0, 0					
		syscall					# generate random int
		
		rem $a0, $a0, 5				# turn random number into int from 0 to 4
		add $a0, $a0, $s3			# increase rand int by 1 so now it goes from 1 to 5
		bgtz $a0, setX				# confirming that the random int was a positive number
		sub $a0, $zero, $a0			# if random int is negative, perform 0-randomInt to make it positive
		
		setX:
			sw $a0, X			# store random int into X
			lw $t0, X			# load content of X into $t0
		
		li $v0, 41				# get ready to generate a random number within range
		li $a0, 0					
		syscall					# generate random int
		
		rem $a0, $a0, 5				# turn random number into int from 0 to 4
		add $a0, $a0, $s3			# increase rand int by 1 so now it goes from 1 to 5
		bgtz $a0, setY 				# confirming that the random int was a positive number
		sub $a0, $zero, $a0			# if random int is negative, perform 0-randomInt to make it positive
		
		setY:
			sw $a0, Y			# store random int into Y
			lw $t1, Y			# load content of Y into $t1
		
		mul $t2, $t0, $t1			# multiply X and Y, then store the value in $t2
		bgt $t2, 9, ConvertDoubleDigits
		j ConvertSingleDigits
		
		ConvertDoubleDigits:
			div $t4, $t2, 10		# perform integer division by 10, should leave us with just the 10s digit stored in $t4
			rem $t3, $t2, 10		# perform product modulus 10, should leave us with just the 1s digit stored in $t3
			addi $t3, $t3, 48			# get the ascii value of the 1s digit
			addi $t4, $t4, 48			# get the ascii value of the 10s digit
			sb $s7, 0($s0)
			addi $s0, $s0, 1
			sb $t4, 0($s0)		# store the 1s digit into content array
			addi $s0, $s0, 1			# move to the next byte address of the content array
			sb $t3, 0($s0)		# store the 10s digit in the conent array
			addi $s0, $s0, 2			# move to the next byte address of the content array
			j StoreValues
			
		ConvertSingleDigits:
			addi $t3, $t2, 48		# get the ascii value of the product
			sb $s7, 0($s0)
			addi $s0, $s0, 1
			sb $s7, 0($s0)
			addi $s0, $s0, 1
			sb $t3, 0($s0)		# store the ascii version in the content array
			addi $s0, $s0, 2		# move to the next address
		
		StoreValues:
			sw $t2, 0($s1)				# put the product of X and Y into the key array
			addi $s1, $s1, 4			# move to the location of the next element in the key array
		
			addi $t0, $t0, 48			# add 48 to value of X to get its ASCII value
			addi $t1, $t1, 48			# add 48 to value of Y to get its ASCII value
			
			sb $t0, 0($s0)				# store the string version of X value into content array
			addi $s0, $s0, 1			# move to the next BYTE in content array
			sb $s4, 0($s0)				# store the "x" into content array
			addi $s0, $s0, 1			# move to the next BYTE in content array
			sb $t1, 0($s0)				# store the string version of Y value into content array
			addi $s0, $s0, 1			# move to the next BYTE in the content array
			sb $zero, 0($s0)			# put null terminator to mark end of string
		
			sw $t2, 0($s1)				# put the product of X and Y into the key array
		
			addi $s0, $s0, 1			# move to the next BYTE (should now be next element) of content array
			addi $s1, $s1, 4			# move to the next element in key array

			blt $s2, 8, InitializeArrays		# loop back to beginning until the arrays are filled with 16 elements
		
			li $s2, 0					# set the index back to 0
			la $s0, contentArray		# load base address of content array to $s0
			la $s1, keyArray			# load base address of key array to $s1
			la $s5, randContentArray	# load base address of random content array to $s5
			la $s6, randKeyArray		# load base address of random key array to $s6
			li $t5, 15					# set max index number (16-1)
			
		Randomize:
		beqz $t5, SetLastElement
		
		GetRandomNumber:
			li $v0, 41					# get ready to generate a random number within range
			li $a0, 0					
			syscall					# generate random int
			
			rem $t6, $a0, $t5			# set random number to a value from 0 to max index
			bgtz $t6, getAddress		# confirming that the random int was a positive number
			sub $t6, $zero, $t6		# if random int is negative, perform 0-randomInt to make it positive
		
		getAddress:
			sll $t6, $t6, 2				# multiply by 4 to get array offset
			add $t7, $t6, $s0			# get memory address of content array at index $t6 then store it in $t7
			add $t8, $t6, $s1			# get memory address of key array at index $t6 then store it in $t8
			
			lw $t9, ($t7)				# get content at contentArray index $t6 and store it in $t9
			sw $t9, 0($s5)			# store content of $t9 into the random content array
			
			lw $t9, ($t8)				# get conent at keyArray index $t6 and store it in $t9
			sw $t9, 0($s6)			# store content of $t9 into the random key array
			
			addi $t0, $s0, 64			# get memory address of final element in content array
			add $t1, $t7, $zero			# get a copy of memory address for content array at index
			
		RemoveFromContent:
			addi $t2, $t1, 4			# get address of "index + 1"
			bge $t2, $t0, FinishedWithContent	# break if "index +1" is out of bounds
			lw $t3, ($t2)				# get content at contentArray "index + 1" and store it in $t3
			sw $t3, ($t1)				# store content from "index + 1" into "index"
			
			addi $t1, $t1, 4			# move to the address of the next element in the array
			j RemoveFromContent
		
		FinishedWithContent:
			addi $t0, $s1, 64
			add $t1, $t8, $zero
			
		RemoveFromKey:
			addi $t2, $t1, 4			# get address of "index + 1"
			bge $t2, $t0, LoopCheck	# break if "index +1" is out of bounds
			lw $t3, ($t2)				# get content at contentArray "index + 1" and store it in $t3
			sw $t3, ($t1)				# store content from "index + 1" into "index"
			
			addi $t1, $t1, 4			# move to the address of the next element in the array
			j RemoveFromKey
			
		j LoopCheck
		
		SetLastElement:
			lw $t9, ($s0)				# get contentArray index 0 and store it in $t9
			sw $t9, 0($s5)			# store contents of $t9 into random content array
			
			lw $t9, ($s1)				# get keyArray index 0 and store it in $t9
			sw $t9, 0($s6)			# store contents of $t9 into random key array
		
		
		LoopCheck:
			addi $t5, $t5, -1			# decrement the max index number by 1
			addi $s2, $s2, 1			# increment the index counrt by 1
			addi $s5, $s5, 4			# move to the location of the next element in random content array
			addi $s6, $s6, 4			# move to the location of the next element in the random key array
			
			blt $s2, 16, Randomize 	#loop to beginning of randomize until all 16 elements have been randomized
			
			jal UserInput

