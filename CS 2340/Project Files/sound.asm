    .text
    .globl MatchSound
    .globl NoMatchSound
    .globl EndSound            
        
    MatchSound:
    	# F Note
    	li $v0, 31	# play sound syscall          
        li $a0, 65      # sound pitch     
        li $a1, 700    # sound duration in ms     
        li $a2, 0       # instrument     
        li $a3, 127     # volume     
        syscall
        
        li $v0, 33           
        syscall
        
        # Bb Note
        li $v0, 31           
        li $a0, 70           
        li $a1, 700         
        li $a2, 0            
        li $a3, 127          
        syscall
        
        li $v0, 33           
        syscall
        
        jr $ra
        
    NoMatchSound:
    	
    	# G note
    	li $v0, 31           
        li $a0, 55           
        li $a1, 100         
        li $a2, 104            
        li $a3, 127          
        syscall
        
        li $v0, 33           
        syscall
        
        # Gb note
        li $v0, 31
        li $a0, 54           
        li $a1, 100         
        li $a2, 104            
        li $a3, 127          
        syscall
        
        li $v0, 33           
        syscall
        
        jr $ra
        
    EndSound:
    	# C Note
    	li $v0, 31		          
        li $a0, 60      	   
        li $a1, 700    	 
        li $a2, 0       	 
        li $a3, 127     	 
        syscall
        
        
        # E Note
    	li $v0, 31		          
        li $a0, 64      	   
        li $a1, 700    	 
        li $a2, 0       	 
        li $a3, 127     	 
        syscall
        
        
        # G Note
    	li $v0, 31		          
        li $a0, 67      	   
        li $a1, 700    	 
        li $a2, 0       	 
        li $a3, 127     	 
        syscall
       
        
        # C2 Note
    	li $v0, 31		          
        li $a0, 72      	   
        li $a1, 800    	 
        li $a2, 0       	 
        li $a3, 127     	 
        syscall
        
        jr $ra
