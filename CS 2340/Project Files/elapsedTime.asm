.text
    .globl initialize_timer
    .globl check_timer

# Subroutine to initialize and store the start time in memory
initialize_timer:
    li $v0, 30                             # syscall 30: Get current time in milliseconds
    syscall
    divu $a0, $a0, 1000                    # Convert milliseconds to seconds
    mflo $a0                               # Move the result to $a0
    sw $a0, startTime                      # Store the start time in memory location 'startTime'
    jr $ra                                 # Return to main

# Subroutine to check and calculate elapsed time in minutes and seconds
check_timer:
    # Save return address to a temporary register
    la $s7, ($ra)

    li $v0, 30                             # syscall 30: Get current time in milliseconds
    syscall
    divu $a0, $a0, 1000                    # Convert milliseconds to seconds
    mflo $a0                               # Move the result to $a0

    lw $t0, startTime                      # Load the stored start time from memory
    sub $t1, $a0, $t0                      # Calculate elapsed time in seconds

    # Calculate minutes and seconds
    li $t2, 60                             # Load 60 to divide by for minutes
    div $t1, $t2                           # Divide elapsed seconds by 60
    mflo $t3                               # Minutes result
    mfhi $t4                               # Seconds remainder

    # Store the calculated minutes and seconds in memory
    sw $t3, timerMins
    sw $t4, timerSec

    # Display total time message
    li $v0, 4
    la $a0, elapsedMsg
    syscall

    # Display minutes
    li $v0, 1
    lw $a0, timerMins                      # Load minutes into $a0
    syscall

    # Display " minute(s) and "
    li $v0, 4
    la $a0, minutes
    syscall

    # Display seconds
    li $v0, 1
    lw $a0, timerSec                       # Load seconds into $a0
    syscall

    # Display " second(s)"
    li $v0, 4
    la $a0, seconds
    syscall

    jr $s7                                 # Return to the saved address in main
