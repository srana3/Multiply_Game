.data
hello:      .asciiz "Hello, World!"

.text
main:
    # Print the "Hello, World!" string
    li $v0, 4           # Load the syscall for print string
    la $a0, hello       # Load the address of the string to print
    syscall             # Make the syscall

    # Exit the program
    li $v0, 10          # Load the syscall for exit
    syscall             # Make the syscall
