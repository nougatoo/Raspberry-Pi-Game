.section .text

.globl wait
//Takes an input in 
//	r1 for the amount of time to wait
wait:
	push {fp,lr}

	//Waits 6 micro seconds
	//COULD PUT THIS INTO A FUNCTION LATER
	ldr r0, =0x20003004
	ldr r1, [r0]
	add r1, r3
waitLoop2:
	ldr r2, [r0]
	cmp r1, r2
	bhi waitLoop2
	
	pop {fp,lr}
	bx lr

//------------------------------------------------------------------------
//------------------------------------------------------------------------
//------------------------------------------------------------------------

.globl Initialize

//Initializes the SNES controller
Initialize:

	push	{r5,r6,r7,r8,r9,r10,fp,lr}

	//Initialization

	//Sets pin 11 (CLK) to output
	//Loads bits of pins 10-19 to r1
	//Address of pins 10-19 in r0
	ldr r0, =0x20200004
	ldr r1, [r0]
	mov r2, #7
	lsl r2, #3 //Index of 1st bit, pin 11
	bic r1, r2 //Clears bits 3,4,5
	mov r3, #1 //Output Function code
	lsl r3, #3 //Align to correct pin
	orr r1, r3
	str r1, [r0]
	
	//Sets pin 10 (DATA) to input
	//Loads bits of pins 10-19 to r1
	//Address of pins 10-19 in r0
	ldr r0, =0x20200004
	ldr r1, [r0]
	mov r2, #7
	bic r1, r2 //Clears bits 3,4,5
	mov r3, #0 //Output Function code
	orr r1, r3
	str r1, [r0]
	
	//Sets pin 9 (LATCH) to output
	//Loads bits of pins 0-9 to r1
	//Address of pins 0-9 in r0
	ldr r0, =0x20200000
	ldr r1, [r0]
	mov r2, #7
	lsl r2, #27 //Index of 1st bit, pin 11
	bic r1, r2 //Clears bits 3,4,5
	mov r3, #1 //Output Function code
	lsl r3, #27 //Align to correct pin
	orr r1, r3
	str r1, [r0]

	pop	{r5,r6,r7,r8,r9,r10,fp,lr}
	bx 	lr

//------------------------------------------------------------------------
//------------------------------------------------------------------------
//------------------------------------------------------------------------

.globl writeLine
//Takes two inputs
// 	r0 is the pin number
// 	r1 is the value to write
writeLine:
	push {fp,lr}

	//Writes 1 to the clock line
	//mov r1, #1
	//mov r0, #11
	ldr r3, =0x20200000
	mov r2, #1
	lsl r2, r0
	teq r1, #0
	streq r2, [r3, #40]
	strne r2, [r3, #28]

	pop {fp,lr}	
	bx lr

//------------------------------------------------------------------------
//------------------------------------------------------------------------
//------------------------------------------------------------------------

.globl readLine
//Takes no input
// reads the SNES data line
readLine:
	push {fp,lr}

	//Reads data line
	mov r0, #10
	ldr r2, =0x20200000
	ldr r1, [r2, #52]
	mov r3, #1
	lsl r3, r0
	and r1, r3
	teq r1, #0
	moveq r4, #0 	//Puts data from data line into r4
	movne r4, #1

	pop {fp,lr}	
	bx lr

//------------------------------------------------------------------------
//------------------------------------------------------------------------
//------------------------------------------------------------------------

.globl reset
//Resets all the data thats been changed
reset:

	push {lr}
	//Resets the number of keys
	ldr r3, =numKeys
	mov r2, #0
	str r2, [r3]

	//NEW resets valid moves for row 8
	ldr r10, =validMoves
	add r10, #98
	add r10, #6
	mov r2, #4
	strb r2, [r10]

	//NEW resets valid moves for row 4
	ldr r10, =validMoves
	add r10, #42
	add r10, #6
	mov r2, #5
	strb r2, [r10]

	//NEW resets valid moves for row 1
	ldr r10, =validMoves
	add r10, #0
	add r10, #6
	mov r2, #12
	strb r2, [r10]

	//NEW resets valid moves for row 1
	ldr r10, =validMoves
	add r10, #0
	add r10, #8
	mov r2, #2
	strb r2, [r10]

	//Resets the valid moves for row 9
	ldr r10, =validMoves
	add r10, #112
	add r10, #10
	mov r2, #5
	strb r2, [r10]

	//NEW CODE
	ldr r10, =validMoves
	add r10, #112
	add r10, #12
	mov r2, #2
	strb r2, [r10]

	//Resets the valid key
	ldr r3, =key1
	mov r1, #1
	strb r1, [r3]

	//Resets the valid key
	ldr r3, =key2
	mov r1, #1
	strb r1, [r3]
	
	//Resets the valid key
	ldr r3, =key3
	mov r1, #1
	strb r1, [r3]

	//Resets the 100's moves to 1
	ldr r3, =numMovesHundred
	mov r1, #1
	str r1, [r3]

	//Resets the 10's moves to 5
	ldr r3, =numMovesTen
	mov r1, #5
	str r1, [r3]

	//Resets the 1's moves to 0
	ldr r3, =numMovesOne
	mov r1, #0
	str r1, [r3]

	//Resets the number of keys to 0
	ldr r3, =numKeys
	mov r1, #0
	str r1, [r3]

	//Resets the winLoseFlag boolean
	ldr r3, =winLoseFlag
	mov r1, #8
	str r1, [r3]

	//Resets the menu selction choice
	ldr r3, =mainMenuSelection
	mov r1, #1
	strb r1, [r3]

	//Resets the pause selction choice
	ldr r3, =mainPauseSelection
	mov r1, #1
	strb r1, [r3]


	//Resets door
	ldr r10, =doorsTaken
	add r10, #2
	mov r1, #1
	strb r1, [r10]

	//Resets door
	ldr r10, =doorsTaken
	add r10, #1
	mov r1, #1
	strb r1, [r10]

	//Resets door
	ldr r10, =doorsTaken
	add r10, #0
	mov r1, #1
	strb r1, [r10]

	//Resets door
	ldr r10, =doorsTaken
	add r10, #3
	mov r1, #1
	strb r1, [r10]

	//Clears the screen
	bl clearScreen


	pop {lr}
	bx	lr

//------------------------------------------------------------------------
//------------------------------------------------------------------------
//------------------------------------------------------------------------

.globl changeNumKey
//Changes the value of the key
//Takes 1 input
// 	r1 - 1 if we want to increase the key num by 1
//	     0 if we want to decrease key num by 1	

changeNumKey:
	push {r4,r5,r6,r7,r8,r9,r10,fp,lr}

	cmp r1, #1
	bne decreaseKey
testing:			
	ldr r10, =numKeys
	ldr r4, [r10]
	add r4, #1
	str r4, [r10]

	b finKeyChange
	
decreaseKey:
	
	ldr r10, =numKeys
	ldr r4, [r10]
	sub r4, #1
	str r4, [r10]

finKeyChange:
	
	//Writes the new number of keys to the screen
	bl writeNumKeys	
	
	pop {r4,r5,r6,r7,r8,r9,r10,fp,lr}
	bx lr

//------------------------------------------------------------------------
//------------------------------------------------------------------------
//------------------------------------------------------------------------

.globl checkKeySpot
//This function takes no inputs and returns 1 thing
// r1 return - 1 if the player is in a key spot
checkKeySpot:
	push {r4,r5,r6,r7,r8,r9,r10,fp,lr}
	
	//Loads the x coordinate to r1
	ldr r10, =pCurrX
	ldr r1, [r10]

	//Compares the x value with the 3 key locations x's
	cmp r1, #1
	bne check3
	ldr r10, =pCurrY
	ldr r1, [r10]
	cmp r1, #9
	beq isTaken1
	b check3

isTaken1:
	ldr r10, =key1
	ldrb r9, [r10]
	cmp r9, #1
	bne notKey
	
	mov r8, #0
	strb r8, [r10]
	
	b isKey

check3:
	cmp r1, #3
	bne check9
	ldr r10, =pCurrY
	ldr r1, [r10]
	cmp r1, #3
	beq isTaken2
	b check9

isTaken2:	
	ldr r10, =key2
	ldrb r9, [r10]
	cmp r9, #1
	bne notKey
	
	mov r8, #0
	strb r8, [r10]
	
	b isKey

check9:
	cmp r1, #9
	bne notKey
	ldr r10, =pCurrY
	ldr r1, [r10]
	cmp r1, #15
	beq isTaken3
	b notKey

isTaken3:
	ldr r10, =key3
	ldrb r9, [r10]
	cmp r9, #1
	bne notKey
	
	mov r8, #0
	strb r8, [r10]
	
	b isKey	
	
isKey:
	mov r1, #1
	b doneKeyCheck

notKey:
	mov r1, #0

doneKeyCheck:
	
	pop {r4,r5,r6,r7,r8,r9,r10,fp,lr}
	bx lr

//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------

.globl decreaseNumMoves
//Takes no input and decreases the number of moves left
decreaseNumMoves:
	
	push {r4-r10, lr}

	//Loads the number of 1's moves into r1
	ldr r10, =numMovesOne
	ldr r1, [r10]

	//If 1's digit is 0 we reduce the number of 10s
	cmp r1, #0
	beq lowerTens

	sub r1, #1
	str r1, [r10]
	b doneDecrease		

//Reduces the 10's number by one and changes 1's digit to 9
//If 10's digit is 0, we lower 100's num by 1 and change 10's and 1's to 9
lowerTens:

	//Loads the number of 10's into r2
	ldr r9, =numMovesTen
	ldr r2, [r9]

	//If 10's digit is 0 we need to lower the hundres
	cmp r2, #0
	beq lowerHundreds

	//From here we need to lower the 10's digit and make 
	// the 1's digit 9
	
	//Stores 9 into 1's digit
	mov r1, #9
	str r1, [r10]
	
	//Lowers the 10's digit by 1
	sub r2,#1
	str r2, [r9]
	b doneDecrease

lowerHundreds:

	//Loads the number of 100's into r3
	ldr r8, =numMovesHundred
	ldr r3, [r8]
	
	//Stores 0 back into numMovesHundred
	sub r3, #1
	str r3, [r8]

	//Stores 9 back into tens digit
	mov r2, #9
	str r2, [r9]

	//Stores 9 back into 1's digit
	mov r1, #9
	str r1, [r10]

doneDecrease:
	pop {r4-r10, lr}
	bx lr

//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------

.globl checkMoves
//This function checks too see if the player is out of moves
//	r1 - 1 if there are NO moves
checkMoves:

	push {r4-r10, lr}

	//Loads the number of 100's moves to r1
	ldr r10, =numMovesHundred
	ldr r1, [r10]

	//If its not 0 they still have moves
	cmp r1, #0
	bne hasMoves

	//Loads the nubmer of 10's moves into r1
	ldr r10, =numMovesTen
	ldr r1, [r10]

	//If it's not 0 they still have moves
	cmp r1, #0
	bne hasMoves

	//Loads the nubmer of 1's moves into r1
	ldr r10, =numMovesOne
	ldr r1, [r10]
		
	//If it's not 0 they still have moves
	cmp r1, #0
	bne hasMoves
	
	//Moves 1 into r1 to say that they have no moves left
	mov r1, #1

	//Since we've opened the final door, we now have to 
	// change the win flag in memory to 0 because we lost
	ldr r10, =winLoseFlag
	mov r1, #0
	str r1, [r10]

	b doneCheck	

hasMoves:
	mov r1, #0

doneCheck:

	pop {r4-r10, lr}
	bx lr

//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------

.globl clearScreen
clearScreen:

	push {r4-r10, lr}

	//Resets the screen to black
	ldr r0, =FrameBuff
	ldr r3, =0x0 //Loads the color
	mov r1, #0 //x start coor
	mov r2, #0 //y start coor
	ldr r10, =0x384//max x cor - 900
	ldr r9, =0x2FC //max y cor - 760
drawXs2:
	bl drawPixel

	add r1, #1
	cmp r1, r10
	bne drawXs2
	
	mov r1, #0

finishedDraw2:
	add r2, #1
	cmp r2, r9
	bne drawXs2


	pop {r4-r10, lr}
	bx lr


//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------

.globl Reading
//This function loops until it reads something from the SNES controller
//  Calls a function based on what was pressed
Reading:
	push	{r5,r6,r7,r8,r9,r10,fp,lr}
Reading2:
	//r9 is the butons register
	mov r9, #0 

	//Writes 1 to the clock line
	mov r1, #1
	mov r0, #11
	bl writeLine
	
	//Writes 1 to the latch line
	mov r1, #1
	mov r0, #9
	bl writeLine

	//Waits 12 micro secctons	
	mov r3, #12
	bl wait
	
	//Writes 0 to the latch line
	mov r1, #0 //CHANGED FROM 0 TO 1
	mov r0, #9
	bl writeLine

	//r10 = i
	mov r10, #0 
	
pulseLoop:	
	
	//Waits 6 micro secctons	
	mov r3, #6
	bl wait
	
	//Writes 0 to the clock line
	mov r1, #0 //CHANGED
	mov r0, #11
	bl writeLine

	//Waits 6 micro secctons	
	mov r3, #6
	bl wait

	//Reads data line
	bl readLine	

	//Organizes the amount of read buttons into 
	// a regsiter
	lsl r4, r10
	orr r9, r4

	//Writes 1 to the clock line
	mov r1, #1
	mov r0, #11
	bl writeLine

	//Increments the counter and 
	// compares it to 16
	add r10, #1
	cmp r10, #16
	bne pulseLoop

	//After this point me we have to determine what move was it
	//Check to see where we should branch too
	mov r1, r9
	
	//Braches to button logic 
	//Returns r1 if no buttons were hit
	bl buttonsLogic
	
	//If no buttons were read, we read again
	cmp r1, #1
	beq Reading2

	pop	{r5,r6,r7,r8,r9,r10,fp,lr}
	bx	lr
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------

.globl ReadingWait
//This function loops until no buttons are being 
// pressed on the SNES controller
ReadingWait:
	push	{r5,r6,r7,r8,r9,r10,fp,lr}
ReadingWait2:
	//r9 is the butons register
	mov r9, #0 

	//Writes 1 to the clock line
	mov r1, #1
	mov r0, #11
	bl writeLine
	
	//Writes 1 to the latch line
	mov r1, #1
	mov r0, #9
	bl writeLine

	//Waits 12 micro secctons	
	mov r3, #12
	bl wait
	
	//Writes 0 to the latch line
	mov r1, #0 //CHANGED FROM 0 TO 1
	mov r0, #9
	bl writeLine

	//r10 = i
	mov r10, #0 
	
pulseLoopW:	
	
	//Waits 6 micro secctons	
	mov r3, #6
	bl wait
	
	//Writes 0 to the clock line
	mov r1, #0 //CHANGED
	mov r0, #11
	bl writeLine

	//Waits 6 micro secctons	
	mov r3, #6
	bl wait

	//Reads data line
	bl readLine	

	//Organizes the amount of read buttons into 
	// a regsiter
	lsl r4, r10
	orr r9, r4

	//Writes 1 to the clock line
	mov r1, #1
	mov r0, #11
	bl writeLine

	//Increments the counter and 
	// compares it to 16
	add r10, #1
	cmp r10, #16
	bne pulseLoopW

	//Check to see where we should branch too
	ldr r8, =0xFFFF	//Waits no buttons are pressed
	cmp r9, r8
	bne ReadingWait2

	pop	{r5,r6,r7,r8,r9,r10,fp,lr}
	bx 	lr
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------

.globl readingAny
//This function reads the SNES controller until any button has been hit
//Then it will branch to the main menu screen
readingAny:

	push {r4-r10, lr}

ReadingWait3:
	//r9 is the butons register
	mov r9, #0 

	//Writes 1 to the clock line
	mov r1, #1
	mov r0, #11
	bl writeLine
	
	//Writes 1 to the latch line
	mov r1, #1
	mov r0, #9
	bl writeLine

	//Waits 12 micro secctons	
	mov r3, #12
	bl wait
	
	//Writes 0 to the latch line
	mov r1, #0 //CHANGED FROM 0 TO 1
	mov r0, #9
	bl writeLine

	//r10 = i
	mov r10, #0 
	
pulseLoopA:	
	
	//Waits 6 micro secctons	
	mov r3, #6
	bl wait
	
	//Writes 0 to the clock line
	mov r1, #0 //CHANGED
	mov r0, #11
	bl writeLine

	//Waits 6 micro secctons	
	mov r3, #6
	bl wait

	//Reads data line
	bl readLine	

	//Organizes the amount of read buttons into 
	// a regsiter
	lsl r4, r10
	orr r9, r4

	//Writes 1 to the clock line
	mov r1, #1
	mov r0, #11
	bl writeLine

	//Increments the counter and 
	// compares it to 16
	add r10, #1
	cmp r10, #16
	bne pulseLoopA

	//Check to see where we should branch too
	ldr r8, =0xFFFF	//Waits no buttons are pressed
	cmp r9, r8
	bne continuing
	b ReadingWait3


continuing:
	//Pops our values
	pop {r4-r10, lr}
	
	b StartingAgain
	
	pop {r4-r10, lr}
	bx 	lr
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------

.globl validRight
//Test to see if a right move is valid
// 	r1 - location of validmoves we're using
validRight:

	push {r5,r6,r7,r8,r9,r10,fp,lr}

	//After we've found out the y position, we need the x position
	ldr r5, =pCurrX
	ldr r4, [r5] //Players X corr is in r4
	
	//Now we need to offset from valid moves 15th row by x corr
	sub r4, #1
	add r1, r4 //Adds the x offset to validMoves address
	ldrb r3, [r1] //Similar to r7

	ldr r1, =0xFD // 1111 1101 because the 1th bit is what we need to check
	bic r3, r1
	mov r6, #2
	cmp r3, r6
	bne return0
	
	mov r1, #1
	b finValidRight

return0:
	mov r1, #0
	
	
finValidRight:
	
	pop {r5,r6,r7,r8,r9,r10,fp,lr}
	bx lr

//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------

.globl validUp
//Test to see if an up move is valid
// 	r1 - location of validmoves we're using
validUp:

	push {r5,r6,r7,r8,r9,r10,fp,lr}	

	//After we've found out the y position, we need the x position
	ldr r5, =pCurrX
	ldr r4, [r5] //Players X corr is in r4
	
	//Now we need to offset from valid moves 15th row by x corr
	sub r4, #1
	add r1, r4 //Adds the x offset to validMoves address
	ldrb r3, [r1] //Similar to r7

	ldr r1, =0xFE // 1111 1110 because the 1th bit is what we need to check
	bic r3, r1
	mov r6, #1
	cmp r3, r6
	bne return0U
	
	mov r1, #1
	b finValidUp
return0U:
	mov r1, #0
	
	
finValidUp:
	
	pop {r5,r6,r7,r8,r9,r10,fp,lr}
	bx lr


//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------



.globl validDown
//Test to see if a down move is valid
//	r1 - location of validmoves we're using
validDown:

	push {r5,r6,r7,r8,r9,r10,fp,lr}

	//After we've found out the y position, we need the x position
	ldr r5, =pCurrX
	ldr r4, [r5] //Players X corr is in r4
	
	//Now we need to offset from valid moves 15th row by x corr
	sub r4, #1
	add r1, r4 //Adds the x offset to validMoves address
	ldrb r3, [r1] //Similar to r7

	ldr r1, =0xFB // 1111 1011 because the 1th bit is what we need to check
	bic r3, r1
	mov r6, #4 //Needs to be changed when mapped to different button
	cmp r3, r6
	bne return0D
	
	mov r1, #1
	b finValidDown
return0D:
	mov r1, #0


	
finValidDown:
	
	pop {r5,r6,r7,r8,r9,r10,fp,lr}
	bx lr

//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------

.globl validLeft
//Test to see if a left move is valid
//	r1 - location of validmoves we're using
validLeft:

	push {r5,r6,r7,r8,r9,r10,fp,lr}

	//After we've found out the y position, we need the x position
	ldr r5, =pCurrX
	ldr r4, [r5] //Players X corr is in r4
	
	//Now we need to offset from valid moves 15th row by x corr
	sub r4, #1
	add r1, r4 //Adds the x offset to validMoves address
	ldrb r3, [r1] //Similar to r7

	ldr r1, =0xF7 // 1111 0111 because the 1th bit is what we need to check
	bic r3, r1
	mov r6, #8 //Needs to be changed when mapped to different button
	cmp r3, r6
	bne return0L
	
	mov r1, #1
	b finValidLeft
return0L:
	mov r1, #0
	
	
finValidLeft:
	
	pop {r5,r6,r7,r8,r9,r10,fp,lr}
	bx lr
