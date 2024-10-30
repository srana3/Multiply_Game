.globl OptionDisplay
.globl SelectionDisplay1
.globl SelectionDisplay2

.text
	OptionDisplay:
		li $t0, 0						# counter for the number of lines we have printed
		li $t1, 0						# counter for the number of cells we have printed
		la $t4, randKeyArray
		Print:
			bgtz $t0, StartCell			# if it's not the first line, print the cells
			
			li $v0, 4
			la $a0, colNames				# print out the label for the columns
			syscall

			add $t0, $t0, 1				# increment lines printed by 1
		
		StartCell:
			li $v0, 1
			add $a0, $t0, $zero
			syscall
		
		PrintCells:
			li $v0, 4
			lw $t5, ($t4)
			bltz $t5, PrintKnown
			
			la $a0, unknown		
			syscall
			j NextCell
			
			PrintKnown:
				la $a0, known
				syscall
			
			NextCell:
			add $t1, $t1, 1			# increment cells count by 1
			add $t4, $t4, 4
			blt $t1, 4, PrintCells		# if we haven't printed 4 cells in a row yet, print another cell
			
			li $t1, 0
			la $a0, endCap
			syscall
			
			add $t0, $t0, 1
			
			beq $t0, 5, End
			
			j Print
		
	SelectionDisplay1:
		li $t0, 0						# counter for the number of lines we have printed
		li $t1, 0						# counter for the number of cells we have printed
		la $t4, randKeyArray
		
		Print2:
			bgtz $t0, StartCell2			# if it's not the first line, print the cells
			
			li $v0, 4
			la $a0, colNames				# print out the label for the columns
			syscall

			add $t0, $t0, 1				# increment lines printed by 1
		
		StartCell2:
			li $v0, 1
			add $a0, $t0, $zero
			syscall
		
		PrintCell2:
			li $v0, 4
			
			Check:
				bne $t1, $a1, Unselected
				la $a0, partition
				syscall
				la $t6, randContentArray
				add $t6, $t6, $t7
				la $a0, 0($t6)
				syscall
				j NextCell2
			 	
			 Unselected:
			 	lw $t5, ($t4)
				bltz $t5, PrintKnown2
			
				la $a0, unknown		
				syscall
				j NextCell2
			
				PrintKnown2:
					la $a0, known
					syscall
		NextCell2:
			add $t1, $t1, 1			# increment cells count by 1
			rem $a3, $t1, 4
			add $t4, $t4, 4
			bnez $a3, PrintCell2		# if we haven't printed 4 cells in a row yet, print another cell
			la $a0, endCap
			syscall
			
			add $t0, $t0, 1
			
			beq $t0, 5, End
			
			j Print2
	
	SelectionDisplay2:
		li $t0, 0						# counter for the number of lines we have printed
		li $t1, 0						# counter for the number of cells we have printed
		la $t4, randKeyArray
		
		Print3:
			bgtz $t0, StartCell3			# if it's not the first line, print the cells
			
			li $v0, 4
			la $a0, colNames				# print out the label for the columns
			syscall

			add $t0, $t0, 1				# increment lines printed by 1
		
		StartCell3:
			li $v0, 1
			add $a0, $t0, $zero
			syscall
		
		PrintCell3:
			li $v0, 4
			
			CheckFirst:
				bne $t1, $a1, CheckSecond
				la $a0, partition
				syscall
				la $t6, randContentArray
				add $t6, $t6, $t7
				la $a0, 0($t6)
				syscall
				j NextCell3
				
			 CheckSecond:
			 	bne $t1, $a2, Unselected2
			 	la $a0, partition
				syscall
			 	la $t6, randContentArray
				add $t6, $t6, $t2
				la $a0, 0($t6)
				syscall
				j NextCell3
			 	
			 Unselected2:
			 	lw $t5, ($t4)
				bltz $t5, PrintKnown3
			
				la $a0, unknown		
				syscall
				j NextCell3
			
				PrintKnown3:
					la $a0, known
					syscall
		NextCell3:
			add $t1, $t1, 1			# increment cells count by 1
			rem $a3, $t1, 4
			add $t4, $t4, 4
			bnez $a3, PrintCell3		# if we haven't printed 4 cells in a row yet, print another cell
			la $a0, endCap
			syscall
			
			add $t0, $t0, 1
			
			beq $t0, 5, End
			
			j Print3
			
	End:
		jr $ra
