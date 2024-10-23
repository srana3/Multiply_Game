.globl EndGame

# all data is stored in main to prevent misallocation
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
	.globl X
	X: .word 5
	.globl Y
	Y: .word 5
	.globl numMatches
	numMatches: .word 0
	.globl IntToString
	IntToString: .space 128		# bytes for the string version of contentArray
	.globl prompt1
	prompt1: .asciiz "\nEnter 1st coordinate (A-D, 1-4): "
	.globl prompt2
	prompt2: .asciiz "\nEnter 2nd coordinate (A-D, 1-4): "
	.globl not_match
	not_match: .asciiz "\nNot a match!"
	.globl match
	match: .asciiz "\nIt's a match!"
	.globl invalid
	invalid: .asciiz "\nInvalid coordinate. Reenter the coordinate (A-D, 1-4)."
	.globl value_message
	value_message: .asciiz "The value at this coordinate is: "
	.globl restart_message
	restart_message: .asciiz "Do you want to restart (Y/N)? "
	.globl match_count_message
	match_count_message: .asciiz "\nNumber of matches: "
	.globl newline
	newline: .asciiz "\n"
	
.text
	StartGame:
		li $t9, 0                   	# Reset match counter
    		sw $t9, numMatches           	# Store 0 in numMatches
    		
    		jal Start
    		
	#jal greet #PROBLEM WITH THIS PORTION
	
	EndGame:
    		jal EndSound
    		
    		# Ask the user if they want to restart
    		li $v0, 4
    		la $a0, newline              # Print a newline before asking
    		syscall

    		li $v0, 4
    		la $a0, restart_message
    		syscall

    		# Read user input
    		li $v0, 12                  # Read character syscall
    		syscall
    		move $t0, $v0               # Store user input

    		li $t1, 'Y'
    		beq $t0, $t1, StartGame      # If user inputs 'Y', restart the game

    		li $t1, 'N'
    		beq $t0, $t1, ExitGame       # If user inputs 'N', exit the game

   		 # If input is not Y or N, ask again (default loop)
    		j EndGame
    		
	ExitGame:
    		li $v0, 10                  # Exit syscall
    		syscall
