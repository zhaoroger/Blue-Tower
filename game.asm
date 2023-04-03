#####################################################################
#
# CSCB58 Winter 2023 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Name, Student Number, UTorID, official email
#
# Bitmap Display Configuration:
# - Unit width in pixels: 4 (update this as needed)
# - Unit height in pixels: 4 (update this as needed)
# - Display width in pixels: 256 (update this as needed)
# - Display height in pixels: 256 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3 (choose the one the applies)
#
# Which approved features have been implemented for milestone 3?
# (See the assignment handout for the list of additional features)
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# 3. (fill in the feature, if any)
# ... (add more if necessary)
#
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it!
#
# Are you OK with us sharing the video with people outside course staff?
# - yes / no / yes, and please share this project github link as well!
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################

.eqv    BASE_ADDRESS 0x10008000
.eqv 	SCREEN_WIDTH	64	# units
.eqv 	SCREEN_HEIGHT	64
.data
PLAYER_LOC:        .word 1, 2
str1:   .asciiz   "Here\n"
str2:   .asciiz   "\n"
.text	

.macro xy_coords
       la $s0, PLAYER_LOC
       lw $s1, 0($s0)
       lw $s2, 4($s0)
.end_macro

.macro char_address
       la $t6, BASE_ADDRESS   #t6 = address of framebuffer
       xy_coords
       sll $t8, $s1, 2        #t8 = 4x
       sll $t9, $s2, 8        #t9 = 4*64y
       add $t7, $t8, $t9      #t7 = offset from framebuffer
       add $t7, $t7, $t6      #t7 = player address
.end_macro       

.macro debug1
       li $v0, 4             #load command
       la $a0, str1          #save str1 for syscall
       syscall               #print str1
.end_macro

.macro debug2 (%reg)
       li $v0, 1
       add $a0, %reg, $zero
       syscall               #print do_addition return
       li $v0, 4             #load command
       la $a0, str2          #save str1 for syscall
       syscall               #print str1
.end_macro


.globl main

main:
       jal clear_screen
       li $t2, BASE_ADDRESS # $t0 stores the base address for display
       li $s4, 0xff0000 # $s0 stores the red colour code  
       li $t4, 0x000000
       char_address
       sw $s0, 0($t7) # paint the address om $t7 from char_address red
       li $t0, 0
       li $t1, 12000
loop:  
       beq $t1, $t0, END    #infinite loop
       jal update_player    
       char_address
       sw $s4, 0($t7) # paint the first (top-left) unit red.
       li $v0, 32
       li $a0, 40
       syscall
       j loop
END: 
       li $v0, 10
       syscall
       
clear_screen:
	li $t1, SCREEN_WIDTH
	mul $t1, $t1, SCREEN_HEIGHT
	sll $t1, $t1, 2
	li $t0, BASE_ADDRESS	# load start address into $t0
	addi $t1, $t1, BASE_ADDRESS	# load final address into $t1
clear_screen_loop:
	sw $zero, 0($t0)		# clear pixel
	addi $t0, $t0, 4
	ble $t0, $t1, clear_screen_loop
	jr $ra
update_player:
       li $t0, 0xffff0000
       lw $t1, 0($t0)
       bne $t1, 1, end_player_update
       lw $t0, 4($t0)
       xy_coords
       char_address
       beq $t0, 119, UP
       beq $t0, 97, LEFT
       beq $t0, 100, RIGHT
       beq $t0, 115, DOWN
       jr $ra
UP:    
       addi $s2, $s2, -2
       j update_char_array
LEFT:    
       addi $s1, $s1, -2
       j update_char_array     
RIGHT:    
       addi $s1, $s1, 2
       j update_char_array 
DOWN:    
       addi $s2, $s2, 2
update_char_array:
      blt $s1, 0, end_player_update
      bgt $s1, 63, end_player_update
      
      blt $s2, 0, end_player_update
      bgt $s2, 63, end_player_update
      
      
      sw $zero, 0($t7)
      sw $s1, 0($s0)
      sw $s2, 4($s0)
end_player_update:
      jr $ra
       
