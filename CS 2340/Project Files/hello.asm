.data
hello:      .asciiz "Hello, World!\n"
hello2: .asciiz "Hello again"

.text
main:
    # Print the "Hello, World!" string
    li $v0, 4           # Load the syscall for print string
    la $a0, hello       # Load the address of the string to print
    syscall             # Make the syscall
    
    # Print the "Hello again" string
    li $v0, 4			# get ready to print a string
    la $a0, hello2		# set address of $a0 to hello2
    syscall			# print string contained in hello2

    # Exit the program
    li $v0, 10          # Load the syscall for exit
    syscall             # Make the syscall
