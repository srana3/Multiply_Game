    .globl UserInput

    .text
# User Input Section
UserInput:
    jal OptionDisplay

    # Prompt user for the 1st coordinate
    li $v0, 4                  # print string syscall
    la $a0, prompt1            # load 1st prompt message
    syscall

    # Read character for the column (case-insensitive)
    li $v0, 12                 # read character syscall (column)
    syscall
    move $t6, $v0              # store character (column) into $t6
    
    # Convert lowercase to uppercase if needed
    li $t9, 'a'                # load 'a'
    li $t0, 'z'                # load 'z'
    bge $t6, $t9, check_upper  # if $t6 >= 'a', check if it's <= 'z'
    j check_column_range       # skip conversion if not lowercase

check_upper:
    ble $t6, $t0, convert_to_upper  # if $t6 <= 'z', convert to uppercase

convert_to_upper:
    sub $t6, $t6, 32           # convert lowercase to uppercase

check_column_range:
    # Convert column character (A-D) to index 0-3
    li $t9, 'A'
    sub $t6, $t6, $t9

    # Check if column is within valid range
    blt $t6, 0, invalid_input   # column out of range
    bgt $t6, 3, invalid_input   # column out of range

    # Read integer for the row
    li $v0, 5                  # read integer syscall (row)
    syscall
    move $t7, $v0              # store integer (row) into $t7

    # Check if row is within valid range
    blt $t7, 1, invalid_input   # row out of range
    bgt $t7, 4, invalid_input   # row out of range

    # Convert row to zero-indexed and calculate final index
    sub $t7, $t7, 1            # row starts from 0
    mul $t7, $t7, 4            # row * 4 to get row index offset
    add $t7, $t7, $t6          # final index = row index + column index
    add $a1, $t7, $zero        # store the index for display code
    mul $t7, $t7, 4            # convert index to byte offset

    # Load value from key array at 1st coordinate
    la $t1, randKeyArray
    add $t1, $t1, $t7          # calculate address
    lw $t8, 0($t1)             # load value
    beq $t8, -1, invalid_input # check if value is valid

    jal SelectionDisplay1

    # Prompt user for the 2nd coordinate (repeat process)
    li $v0, 4                  # print string syscall
    la $a0, prompt2            # load 2nd prompt message
    syscall

    # Read character for the column (case-insensitive)
    li $v0, 12                 # read character syscall (column)
    syscall
    move $t6, $v0              # store character (column) into $t6
    
    # Convert lowercase to uppercase if needed
    li $t9, 'a'                # load 'a'
    li $t0, 'z'                # load 'z'
    bge $t6, $t9, check_upper2 # if $t6 >= 'a', check if it's <= 'z'
    j check_column_range2      # skip conversion if not lowercase

check_upper2:
    ble $t6, $t0, convert_to_upper2  # if $t6 <= 'z', convert to uppercase

convert_to_upper2:
    sub $t6, $t6, 32           # convert lowercase to uppercase

check_column_range2:
    # Convert column character (A-D) to index 0-3
    li $t9, 'A'
    sub $t6, $t6, $t9

    # Check if column is within valid range
    blt $t6, 0, invalid_input   # column out of range
    bgt $t6, 3, invalid_input   # column out of range

    # Read integer for the row
    li $v0, 5                  # read integer syscall (row)
    syscall
    move $t2, $v0              # store integer (row) into $t2

    # Check if row is within valid range
    blt $t2, 1, invalid_input   # row out of range
    bgt $t2, 4, invalid_input   # row out of range

    # Convert row to zero-indexed and calculate final index
    sub $t2, $t2, 1            # row starts from 0
    mul $t2, $t2, 4            # row * 4 to get row index offset
    add $t2, $t2, $t6          # final index = row index + column index
    add $a2, $t2, $zero        # store the index for display code
    mul $t2, $t2, 4            # convert index to byte offset

    # Load value from key array at 2nd coordinate
    la $t1, randKeyArray
    add $t1, $t1, $t2          # calculate address
    lw $t9, 0($t1)             # load value
    beq $t9, -1, invalid_input # check if value is valid

    jal SelectionDisplay2

    # Check if coordinates are identical (if so, ask for 2nd coordinate again)
    beq $a1, $a2, invalid_input  # Check if 1st and 2nd coordinates are the same
    
    # Check if the two coordinates match
    beq $t8, $t9, match_found
    li $v0, 4                  # print string syscall
    la $a0, not_match          # load "Not a match!" message
    syscall
    jal NoMatchSound           # play no match sound
    b UserInput                # repeat the input process

match_found:
    li $a3, -1
    la $t1, randKeyArray
    add $t1, $t1, $t7
    sw $a3, 0($t1)
    la $t1, randKeyArray
    add $t1, $t1, $t2
    sw $a3, 0($t1)
    li $v0, 4                  # print string syscall
    la $a0, match              # load "It's a match!" message
    syscall

    jal check_timer

    # Play match sound
    jal MatchSound

    lw $t0, numMatches         # Load the current match count
    addi $t0, $t0, 1           # Increment match counter
    sw $t0, numMatches         # Store updated match count

    # Print the number of matches found so far
    li $v0, 4                  # print string syscall
    la $a0, match_count_message # load "Number of matches: " message
    syscall

    li $v0, 1                  # print integer syscall
    move $a0, $t0              # move the match count to $a0
    syscall

    li $v0, 4                  # print string syscall for newline
    la $a0, newline            # load newline
    syscall

    # Check if 8 matches are found
    bne $t0, 8, UserInput      # If less than 8 matches, continue

    # If 8 matches are made, go to EndGame
    jal EndGame

invalid_input:
    li $v0, 4                  # print string syscall
    la $a0, invalid            # load invalid message
    syscall
    b UserInput                # ask for input again
