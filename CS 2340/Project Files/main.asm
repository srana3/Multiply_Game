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
	prompt1: .asciiz "Enter 1st coordinate (A-D, 1-4): "
	.globl prompt2
	prompt2: .asciiz "Enter 2nd coordinate (A-D, 1-4): "
	.globl not_match
	not_match: .asciiz "\nNot a match!\n"
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
	.globl colNames
	colNames: .asciiz "\n    A     B    C    D   \n"
	.globl unknown
	unknown: .asciiz "|  ?  "
	.globl known
	known: .asciiz "|      "
	.globl endCap
	endCap: .asciiz "|\n"
	.globl partition
	partition: .asciiz "|"
	.globl startTime
	startTime:       .word 0                       # Memory location to store the start time
	.globl timerMins
	timerMins:         .word 0 
	.globl timerSec
	timerSec:         .word 0                      
	.globl elapsedMsg
	elapsedMsg:      .asciiz "\nElapsed Time: "
	.globl minutes
	minutes:      .asciiz " minute(s) and "
	.globl seconds
	seconds:      .asciiz " second(s)\n"
	
.text
	StartGame:
		li $t9, 0                   	# Reset match counter
    		sw $t9, numMatches           	# Store 0 in numMatches
    		
    		jal initialize_timer
    		jal Start
    		
	
	EndGame:
    		jal EndSound
    		
    		jal check_timer
    		
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

    		# Check for 'Y' or 'y' to restart the game
    		li $t1, 'Y'
    		li $t2, 'y'
    		beq $t0, $t1, StartGame         # If input is 'Y', restart the game
    		beq $t0, $t2, StartGame         # If input is 'y', restart the game

    		# Check for 'N' or 'n' to exit the game
    		li $t3, 'N'
    		li $t4, 'n'
    		beq $t0, $t3, ExitGame          # If input is 'N', exit the game
    		beq $t0, $t4, ExitGame          # If input is 'n', exit the game

    		# If input is not Y/y or N/n, ask again (default loop)
    		j EndGame
    		
	ExitGame:
    		
    		li $v0, 10                  # Exit syscall
    		syscall
