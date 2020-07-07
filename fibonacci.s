### Recursive fibonacci function in MIPS
	.data
	.align 2

msg:    .asciiz "Enter a number>\n"
comma:  .asciiz ","
errmsg:	.asciiz "Error - must enter a positive integer\n"
eol:	.asciiz "\n"
	
    .text
main:
###Step1: read user input	
# Print hint message: system service code 4 
INPUT:
# Print message: system service code 4 
    la $a0,msg     
	li $v0,4		 
    syscall			
# Read input N: system service code 5
    li $v0,5		 
    syscall			 

###Step2: validation    
	addi $a0,$v0,0	
	bgtz $a0,JFIB   # If N>0, goto next step, else get input again
	
###Step3: invalid input: ask user to input parameter again	
# Print error message: system service code 4 
    la $a0,errmsg	 
    li $v0,4		
    syscall			
# Get input again
	j INPUT			

###Step4: valid input: start Fibonacci function

JFIB:

	addi $a1,$a0,0 #saving result from being overwritten into a1
	li $t1, 0 #Index
	li $t9, 4 # used for adjusting heap and getting to correct pos in heap

	###Allocate space in heap
	
    li $v0, 9
    mul $a0,$t9,$a1
    syscall
    move $s1, $v0 # s1 Address of array
    move $a2, $s1
	

Loop:   

    beq $t1, $a1 EXIT #checks if the index is equal to input
    jal FIB
    
    move $a0, $t7
    li $v0, 1  #Print the result from t7 
    syscall
    
    la $a0, eol
    li $v0, 4 #just to print out a new line
    syscall
    
    addi $t1, $t1 1

    j Loop

###Step6: end the program
EXIT:
   
	li 	$v0,10		 
        syscall

### Function modules
FIB: 

   addi $sp,    $sp -8 #Need to store previous states
   sw   $ra,  0($sp)#Address
   sw   $t1,  4($sp)#Index

   addi $t0,$t1,0 #store index in t0
	
# if N==0: Fib(1) = 0
   beqz $t0,zero

# if N=1 jump to FIB2
   li $t6, 1
   beq  $t0, $t6 FIB2
    
   mul  $t2,   $t1, $t9 # t2 address of num for heap 
   add  $a2,   $t2, $s1 # get to end of array
   
   lw   $t7,  ($a2)     #load whatevers at the end
   
   bgt  $t7, $zero, jumpBack # to check if num is in heap already 
   
   lw   $t0,    4($sp)
   addi $t1,    $t0, -1  #adjust the index to do fib(n-1 memo)
   jal  FIB
   
   move $s2,    $t7    # Drop result of n-1 into s1
   
   lw   $t0,  4($sp) # Fib(n-2)
   addi $t1,    $t0, -2
   jal  FIB

   add  $t7,   $s2, $t7 # Add the 2 results
 
   lw   $t1, 4($sp) # go to original index in t1
 
   mul  $t2,   $t1, $t9 # t2 address of num for heap 
   add  $a2,   $t2, $s1 # get to end of array
   sw   $t7, ($a2) # add the 2 fibs and store in recent position in array
 
   j jumpBack
   
   
zero:
    li $t7,  0
	j jumpBack

FIB2: # Fib(2) = 1
    li $t7,  1
	j jumpBack
   
    
jumpBack:
    lw   $ra,  0($sp) #preserve the state
     lw   $t1,  4($sp)
     addi $sp,    $sp 8
      jr $ra