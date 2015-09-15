.section .text

.globl drawDoors
//Takes no input
// just draws the doors (brown)
drawDoors:
	push {fp,lr}

	//Checks to see if the door has been taken
	ldr r10, =doorsTaken
	ldrb r5, [r10]
	cmp r5, #1
	bne nextDoor1
	
	//Colors all the doors
	ldr r1, =0xFB00	
	mov r2, #8
	mov r3, #1
	bl colorSQ

nextDoor1:
	//Checks to see if the door has been taken
	ldr r10, =doorsTaken
	add r10, #1
	ldrb r5, [r10]
	cmp r5, #1
	bne nextDoor2

	ldr r1, =0xFB00	
	mov r2, #8
	mov r3, #4
	bl colorSQ

nextDoor2:

	//Checks to see if the door has been taken
	ldr r10, =doorsTaken
	add r10, #2
	ldrb r5, [r10]
	cmp r5, #1
	bne nextDoor3

	ldr r1, =0xFB00	
	mov r2, #7
	mov r3, #7
	bl colorSQ

nextDoor3:
	//Checks to see if the door has been taken
	ldr r10, =doorsTaken
	add r10, #3
	ldrb r5, [r10]
	cmp r5, #1
	bne nextDoor4

	ldr r1, =0xFB00	
	mov r2, #12
	mov r3, #9
	bl colorSQ

nextDoor4:
	ldr r1, =0xF000	
	mov r2, #14
	mov r3, #16
	bl colorSQ

	pop {fp,lr}
	bx lr


//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------

.globl DrawGrid
// Draw Pixel to a 1024x768x16bpp frame buffer
// Note: no bounds checking on the (X, Y) coordinate
//	r0 - frame buffer pointer
//	r1 - pixel X coord
//	r2 - pixel Y coord
//	r3 - colour (use low half-word)
//
// 	COULD PASS A VALUE AS TO WHERE THE PLAYER IS
DrawGrid:
	push	{r4,r6,r7,fp,lr}

	//Loads the Corner of the grid and color
	ldr r10, =FrameBuff
	str r0, [r10]
	mov		r1, #190
	mov		r2, #64
	ldr		r3,	=0xFFFF

	offset	.req	r4
	
	ldr r6, =846 //830 for grids +16 pixels for lines
	ldr r7, =704
	
loop:
	// offset = (y * 1024) + x = x + (y << 10)
	add		offset,	r1, r2, lsl #10
	// offset *= 2 (for 16 bits per pixel = 2 bytes per pixel)
	lsl		offset, #1

	// store the colour (half word) at framebuffer pointer + offset
	strh	r3,		[r0, offset]
	
	add r1, #1
	teq r1, r6
	bne loop
	
	mov r1, #190
	
	add r2, #1
	teq r2, r7
	bne loop

//Now Drawing Vertical black lines
	mov r1, #230
	mov r2, #64
	mov r3, #0x0000
loop2:
	add offset, r1, r2, lsl #10
	lsl offset, #1
	strh r3, [r0, offset]
	
	add r2, #1
	teq r2, r7
	bne loop2

	mov r2, #64
	
	add r1, #41
	cmp r1, r6
	bls loop2
	
//Now drawing horizontal black lines
	mov r1, #190
	mov r2, #104
loop3:
	add offset, r1, r2, lsl #10
	lsl offset, #1
	strh r3, [r0, offset]

	add r1, #1
	teq r1, r6
	bne loop3

	mov r1, #190

	add r2, #40
	cmp r2, r7
	bls loop3

	pop		{r4,r6,r7,fp,lr}
	bx		lr

//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------

.globl colorSQ
//This function colors a particular square on the grid
//	r1 - color
// 	r2 - x cord
//	r3 - y cor
colorSQ:
	
	push {r4-r10,lr}
	
	//Stores color in memory (argument 0)
	ldr r4, =Color
	str r1, [r4]
	
	//Stores xCor in memory (argument 1)
	ldr r4, =xCor
	str r2, [r4]
	
	//Stores yCor in memory (argument 2)
	ldr r4, =yCor
	str r3, [r4]	
	
	mov r1, #190 //x
	mov r2, #64 //y
	ldr r3, =Color //Sets the color
	ldr r3, [r3]
	
	//Loads values from the input that was given for x and y on grid
	ldr r5, =xCor
	ldr r5, [r5] 
	mov r6, #41 //r6 
	ldr r7, =yCor
	ldr r7, [r7]
	//mov r7, #9 //r7 = 14
test:	
	mul r5, r5, r6 //x offset  = 574
	mov r6, #40
	mul r10, r7, r6 //y offset  = 41

	add r1, r5 //top left of target square
	add r2, r10 //top left of targe square
	add r2, #1

	mov r9, r1 //saves r1 for later X
	mov r8, r2 //saves r2 for later Y

	//sets the boundries of the square
	add r5, r1, #41
	add r10, r2, #40

loopPix:
	//Draws a pixel to the screen
	add offset, r1, r2, lsl #10
	lsl offset, #1
	strh r3, [r0, offset]

	add r1, #1
	add r5, r9, #40
	//ldr r5, =271 //needs to be mapped to register added 40 to initial x
	teq r1, r5
	bne loopPix
	
	mov r1, r9

	add r2, #1
	add r5, r8, #39
	//ldr r5, =664 //needs to be mapped to register -- added 39 to intital 
	teq r2, r5
	bne loopPix
	
	pop {r4-r10,lr}
	bx lr

//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------

.globl drawKeys	
//Takes no inputs and draws the keys
drawKeys:
	push {r5, r10,fp,lr}

	//Checks to see if the key has been taken
	ldr r10, =key1
	ldrb r5, [r10]
	cmp r5, #1
	bne nextKey1
	
	//Colors key 1
	ldr r1, =0xFF00
	mov r2, #1
	mov r3, #9
	bl colorSQ	

nextKey1:
	//Checks to see if the key has been taken
	ldr r10, =key2
	ldrb r5, [r10]
	cmp r5, #1
	bne nextKey2

	//Colors key 2
	ldr r1, =0xFF00
	mov r2, #3
	mov r3, #3
	bl colorSQ

nextKey2:
	//Checks to see if the key has been taken
	ldr r10, =key3
	ldrb r5, [r10]
	cmp r5, #1
	bne keysDone
	
	//Draws key 3
	ldr r1, =0xFF00
	mov r2, #9
	mov r3, #15
	bl colorSQ

keysDone:		
	pop {r5, r10,fp,lr}
	bx lr
	
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------

.globl drawPlayer
//Draws the player and calls a function to update the number of moves
//Draw player takes two inputs
//	r1 - next player position X
//	r2 - next player position y
drawPlayer:
	push {r4,r5,r6,r7,fp,lr}

	ldr r5, =FrameBuff
	ldr r0, [r5]

	push {r1,r2,fp}
	//Resets the previous square to white
	ldr r1, =0xFFFF
	ldr r4, =pCurrX //Puts the current players x into r4
	ldr r2, [r4]

	ldr r4, =pCurrY //Puts the current players x into r4
	ldr r3, [r4]
	bl colorSQ
	
	pop {r1, r2, fp}

	//Updates the current square the player is on
	ldr r4, =pCurrX
	str r1, [r4]
	ldr r4, =pCurrY
	str r2, [r4]

	//Color the player and updates the previous square
	mov r3, r2
	mov r2, r1
	ldr r1, =0x0FF0
	bl colorSQ

	ldr r7, =removeMoves
	ldrb r6, [r7]
	cmp r6, #1
	bne donePlayer 
	//Decreases the number of moves and writes them to screen
	bl decreaseNumMoves
	bl writeNumMoves

donePlayer:	
	pop {r4,r5,r6,r7,fp,lr}
	bx lr	 


//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------


.globl drawPixel
//Takes two inputs
//	r1 - x cor
//	r2 - y cor
//	r3 - color
drawPixel:

	push {r4-r10, lr}

	//Draws a pixel to the screen
	ldr r10, =FrameBuff
	ldr r0, [r10]
	add offset, r1, r2, lsl #10
	lsl offset, #1
	strh r3, [r0, offset]

	pop {r4-r10, lr}
	bx lr
	
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------



.globl drawLetter
//Draws a character to the screen
//This function was taken from the TA
// 	Inputs: not sure
//	r1 - the letter to draw
//	r2 - x location
//	r3 - y location
//THIS FUNCTION WAS TAKEN FROM THE TA CODE
drawLetter:

	push {r4-r10, lr}

	mov r10, r2
	chAdr	.req	r4
	px		.req	r5
	py		.req	r6
	row		.req	r7
	mask	.req	r8

	ldr		chAdr,	=font		// load the address of the font map
	add		chAdr,	r1, lsl #4	// char address = font base + (char * 16)
break:
	mov		py, r3			// init the Y coordinate (pixel coordinate)

charLoop$:
	mov		px, r10			// init the X coordinate

	mov		mask,	#0x01		// set the bitmask to 1 in the LSB
	
	ldrb	row,	[chAdr], #1	// load the row byte, post increment chAdr

rowLoop$:
	tst		row,	mask		// test row byte against the bitmask
	beq		noPixel$

	mov		r1,		px
	mov		r2,		py
	ldr		r3,		=0xFFFF		// red
	bl		drawPixel			// draw red pixel at (px, py)

noPixel$:
	add		px,		#1			// increment x coordinate by 1
	lsl		mask,	#1			// shift bitmask left by 1

	tst		mask,	#0x100		// test if the bitmask has shifted 8 times (test 9th bit)
	beq		rowLoop$

	add		py,		#1			// increment y coordinate by 1

	tst		chAdr,	#0xF
	bne		charLoop$			// loop back to charLoop$, unless address evenly divisibly by 16 (ie: at the next char)

	.unreq	chAdr
	.unreq	px
	.unreq	py
	.unreq	row
	.unreq	mask

	pop {r4-r10, lr}	
	bx lr


//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------

.globl writeStaticStrings
//Takes no input and writes the characters that don't change
writeStaticStrings:

	push {r4-r10, lr}

	//This code writes the string "NUMBER OF MOVES LEFT:"
	mov r9, #0 //loop counter
	ldr r10, =stringNumMovesLeft
	mov r6, #250 //x offset
	mov r5, #30 //y offset - does not change
letterLoop1:
	
	mov r2, r6
	mov r3, r5	

	ldr r1, [r10]
	bl drawLetter

	add r10, #4
	add r6, #10
	add r9, #1

	cmp r9, #21
	bne letterLoop1
	
	//This code writes the string "KEYS:"
	mov r9, #0 //loop counter
	ldr r10, =stringKeys
	mov r6, #600 //x offset
	mov r5, #30 //y offset - does not change
letterLoop2:
	
	mov r2, r6
	mov r3, r5	

	ldr r1, [r10]
	bl drawLetter

	add r10, #4
	add r6, #10
	add r9, #1

	cmp r9, #5
	bne letterLoop2

	pop {r4-r10, lr}
	bx 	lr


//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------


.globl writeNumKeys
//This functions writes the number of keys left
//It calls writeBlackKey which writes a black square around where the key is
writeNumKeys:
	
	push {r4-r10, lr}
	
	//Clears the area where we write a key
	bl writeBlackKey
	
	//Puts the integer number of keys into r1
	ldr r10, =numKeys
	ldr r1, [r10]

	//Loades stringNumbers address into r10
	ldr r10, =stringNumbers

	//Makes an offset to get the correct number
	mov r9, #4
	mul r1, r9

	//Adds the offset to r10
	add r10, r1
	ldr r1, [r10]
	ldr r2, =0x28A
	mov r3, #30
	bl drawLetter

	pop {r4-r10, lr}
	bx 	lr

//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------

.globl writeBlackKey
//This function writes a black box aroud where the number of keys shows is
writeBlackKey:
	
	push {r4-r10, lr}

	//Loads x = 650, y = 30
	ldr r1, =0x28A
	mov r2, #30
	
	//660 in hex
	ldr r8, =0x294
	
	//Loads color to r3
	ldr r3, =0x0
	
xLine:
	bl drawPixel
	
	//Adds 1 to the x offset	
	add r1, #1

	cmp r1, r8
	bne xLine
	
	//Resets x to 650
	ldr r1, =0x28A
	
	add r2, #1
	cmp r2, #45

	bne xLine

	pop {r4-r10, lr}
	bx 	lr

//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------

.globl writeBlackMoves
//This function writes a black box aroud where the number of moves
writeBlackMoves:

	push {r4-r10, lr}

	//Loads x = 650, y = 30
	ldr r1, =0x1CC
	mov r2, #30
	
	//660 in hex
	ldr r8, =0x1EA
	
	//Loads color to r3
	ldr r3, =0x0
	
xLine2:
	bl drawPixel
	
	//Adds 1 to the x offset	
	add r1, #1

	cmp r1, r8
	bne xLine2
	
	//Resets x to 650
	ldr r1, =0x1CC
	
	add r2, #1
	cmp r2, #45

	bne xLine2

	pop {r4-r10, lr}
	bx 	lr

//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------

.globl writeNumMoves
//Writes the number of moves left to the screen
// takes inputs, relies of a function that decreases the number of moves
writeNumMoves:	

	push {r4-r10, lr}

	//Clears the area where we write the number of moves
	bl writeBlackMoves

//Writes the 100's number of moves	
	//Puts the integer number of (100) moves into r1
	ldr r10, =numMovesHundred
	ldr r1, [r10]

	//Loads stringNumbers address into r10
	ldr r10, =stringNumbers

	//Makes an offset to get the correct number
	mov r9, #4
	mul r1, r9

	//Adds the offset to r10
	add r10, r1
	ldr r1, [r10]
	ldr r2, =0x1CC
	mov r3, #30
	bl drawLetter

//Writes the 10's number of moves
	//Puts the integer number of (100) moves into r1
	ldr r10, =numMovesTen
	ldr r1, [r10]

	//Loads stringNumbers address into r10
	ldr r10, =stringNumbers

	//Makes an offset to get the correct number
	mov r9, #4
	mul r1, r9

	//Adds the offset to r10
	add r10, r1
	ldr r1, [r10]
	ldr r2, =0x1D6
	mov r3, #30
	bl drawLetter

//Wtires the 1's number of moves
	//Puts the integer number of (100) moves into r1
	ldr r10, =numMovesOne
	ldr r1, [r10]

	//Loads stringNumbers address into r10
	ldr r10, =stringNumbers

	//Makes an offset to get the correct number
	mov r9, #4
	mul r1, r9

	//Adds the offset to r10
	add r10, r1
	ldr r1, [r10]
	ldr r2, =0x1E0
	mov r3, #30
	bl drawLetter

	pop {r4-r10, lr}
	bx 	lr

//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------
.globl writeWL
//Writes that you won the game or loses the game
//  takes no input
writeWL:
	push {r4-r10, lr}
	
	//Checks to see if they won the game or lost the game
	ldr r10, =winLoseFlag
	ldr r1, [r10]

	cmp r1, #1
	bne nextTest

	//This code writes the YOU WIN string
	mov r9, #0 //loop counter
	ldr r10, =stringWinGame
	ldr r5, =0x15E //y offset
	ldr r6, =0x15E //x offset

	push {r4-r10}
	//Resets the screen to black
	ldr r0, =FrameBuff
	ldr r3, =0x0 //Loads the color
	mov r1, #0 //x start coor
	mov r2, #0 //y start coor
	ldr r10, =0x384//max x cor - 900
	ldr r9, =0x2FC //max y cor - 760
drawXs:
	bl drawPixel

	add r1, #1
	cmp r1, r10
	bne drawXs
	
	mov r1, #0

finishedDraw:
	add r2, #1
	cmp r2, r9
	bne drawXs

	pop {r4-r10}

letterLoop3:
	
	mov r2, r6
	mov r3, r5	

	ldr r1, [r10]
	bl drawLetter

	add r10, #4
	add r6, #10
	add r9, #1

	cmp r9, #41
	bne letterLoop3


	b writeWLDone

//This code writes the lose string
nextTest:
	cmp r1, #0
	bne writeWLDone
	
	mov r9, #0 //loop counter
	ldr r10, =stringLostGame
	ldr r5, =0x15E //y offset
	ldr r6, =0x15E //x offset

	push {r4-r10}
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
	bne drawXs

	pop {r4-r10}

letterLoop4:
	
	mov r2, r6
	mov r3, r5	

	ldr r1, [r10]
	bl drawLetter

	add r10, #4
	add r6, #10
	add r9, #1

	cmp r9, #41
	bne letterLoop4

lostGame:

writeWLDone:
	pop {r4-r10, lr}
	bx 	lr

//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------

.globl drawMenuBox
drawMenuBox:

	push {r4-r10,lr}

	//This code writes the horizontal lines
	ldr r10, =0x2BC //- x max cor - 700
	ldr r9, = 0x1F4 //- y max cor - 500
	ldr r3, =0xFFFF
	ldr r1, =0x172 //starting x corr - 370
	ldr r2, =0x96  //starting y corr - 150

loop5:
	//Draws a pixel	
	bl drawPixel
	
	add r1, #1
	cmp r1, r10
	bne loop5

	//Bottom Line
	ldr r1, =0x172 //starting x corr - 
	ldr r2, =0x1F4  //starting y corr - 

loop6:
	//Draws a pixel	
	bl drawPixel
	
	add r1, #1
	cmp r1, r10
	bne loop6

	//This code writes the veritcal lines
	ldr r1, =0x172 //starting x corr - 
	ldr r2, =0x96  //starting y corr - 
loop7:
	//Draws a pixel	
	bl drawPixel
	
	add r2, #1
	cmp r2, r9
	bne loop7

	//Right Line
	ldr r1, =0x2BC //starting x corr - 
	ldr r2, =0x96  //starting y corr - 

loop8:
	//Draws a pixel	
	bl drawPixel
	
	add r2, #1
	cmp r2, r9
	bne loop8

	pop {r4-r10, lr}
	bx	lr

//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------


.globl drawMenuSquare
drawMenuSquare:

	push {r4-r10,lr}

	ldr r10, =0x2BB //- x max cor - 699
	ldr r9, = 0x1F3 //- y max cor - 499
	ldr r3, =0x0821
	ldr r1, =0x175 //starting x corr - 371
	ldr r2, =0x97  //starting y corr - 151

squareLoop$:

	bl drawPixel

	add r1, #1		//Adds 1 to x cor
	cmp r1, r10		//Compares x to MAX x
	bne squareLoop$

	ldr r1, =0x175
	add r2, #1
	cmp r2, r9
	bne squareLoop$

	pop {r4-r10, lr}
	bx	lr

//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------

.globl drawWall
drawWall:

	push {r4-r10,lr}	
	
	ldr r10, =greys		//Addres of greys into r10
	mov r8, #0		//Initial x cor of grid
	mov r7, #0		//Initial y cor of grid

greyLoop1$:
	ldr r1, =0xC618		//Moves the color grey into r1
	mov r2, r8		//Loads the x cor
	mov r3, r7		//Loads the y cor

	ldrb r9, [r10]		//Whether or not a square should be grey in r1. 1 = grey
	cmp r9, #1		//Checks to see if we color the square grey
	bne notGrey

	bl colorSQ		//Calls draw square function @r2,r3
	
	add r10, #1		//Index of next grey
	add r8, #1		//Increase x cor

	cmp r8, #16		//Checks to see if we've reached the edge of the grid
	bne greyLoop1$
	//Now the first row has been drawn
check3:
	mov r8, #0
	add r7, #1

	cmp r7, #17
	bne greyLoop1$
	b doneWalls

//Handles what happens when a square is not grey
notGrey:	
	
	add r10, #1		//Index of next grey
	add r8, #1		//Increase x cor
	
	b greyLoop1$

doneWalls:

	pop {r4-r10,lr}
	bx lr

