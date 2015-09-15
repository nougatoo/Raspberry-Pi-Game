.section .text

.globl drawMainMenu
//This function takes no input and draws the main menu
drawMainMenu:


	push {r4-r10, lr}
	
	//This code writes the game name string
	mov r9, #0 //loop counter
	ldr r10, =stringGameName
	ldr r5, =0xC8 //y offset - 200
	ldr r6, =0x1c2 //x offset - 450
letterLoop:
	
	mov r2, r6
	mov r3, r5	

	ldr r1, [r10]
	bl drawLetter

	add r10, #4
	add r6, #10
	add r9, #1

	cmp r9, #16
	bne letterLoop

	//This code writes the game start string
	mov r9, #0 //loop counter
	ldr r10, =stringStartGame
	ldr r5, =0x12c //y offset - 300
	ldr r6, =0x1F4 //x offset - 500
letterLoop2:
	
	mov r2, r6
	mov r3, r5	

	ldr r1, [r10]
	bl drawLetter

	add r10, #4
	add r6, #10
	add r9, #1

	cmp r9, #10
	bne letterLoop2


	//This code writes the game QUIT string
	mov r9, #0 //loop counter
	ldr r10, =stringQuitGame
	ldr r5, =0x14F //y offset - 335
	ldr r6, =0x1F4 //x offset
letterLoop3:
	
	mov r2, r6
	mov r3, r5	

	ldr r1, [r10]
	bl drawLetter

	add r10, #4
	add r6, #10
	add r9, #1

	cmp r9, #9
	bne letterLoop3

	//This code writes the game creater string
	mov r9, #0 //loop counter
	ldr r10, =stringCreater
	ldr r5, =0x1BC //y offset
	ldr r6, =0x19A //x offset
letterLoop4:
	
	mov r2, r6
	mov r3, r5	

	ldr r1, [r10]
	bl drawLetter

	add r10, #4
	add r6, #10
	add r9, #1

	cmp r9, #24
	bne letterLoop4

	//This code writes the horizontal lines
	ldr r10, =0x2BC //- x max cor - 700
	ldr r9, = 0x1F4 //- y max cor - 500
	ldr r3, =0xffff
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

	//-----------
	//Initializes the red box
	mov r1, #1
	bl selectMenu

read:
	//Now we need to get input from the controller
	//Character hit is in r1

	bl readingMenu

	//If r1 corresponds to up arrow, we draw a red square at start game
	//	and a black square beside quit game
	// if r1 corresponds to down arrow, we draw a red square at quit game
	//	and a black square at start game

	//If the up arrow was hit, move the red box
	ldr r10, =0xFFEF
	cmp r1, r10
	bne nextCheck1

	//Argument for select menu
	mov r1, #1

	//Updates which menu selection we're on
	// 1 - start game
	// 0 - quit game
	ldr r5, =mainMenuSelection
	strb r1, [r5]

	//Draws the red box
	bl selectMenu
	
	b read
	
	//If the down arrow was hit, move the red box
nextCheck1:
	ldr r10, =0xFFDF
	cmp r1, r10
	bne nextCheck2

	mov r1, #0

	//Updates which menu selection we're on
	// 1 - start game
	// 0 - quit game
	ldr r5, =mainMenuSelection
	strb r1, [r5]

	bl selectMenu

	b read

	//If the 'a' button was hit
nextCheck2:
	ldr r10, =0xFEFF 	
	cmp r1, r10
	bne read
	
	ldr r8, =mainMenuSelection
	ldrb r5, [r8]
	cmp r5, #1
	bne quitGame
testingMenu:
	pop {r4-r10, lr}
	b startingGame

quitGame:
	
	//If we make it here, it has to call reset and then branch to haltLoop
	pop {r4-r10, lr}
	bl reset
	b haltLoop$
	
mainMenuDone:
	pop {r4-r10, lr}
	bx 	lr


//------------------------------------------------------------------------
//------------------------------------------------------------------------
//------------------------------------------------------------------------

.globl readingMenu
//This function loops until a button is read and then returns it
//	r1 - returned which button was hit
readingMenu:
	push	{r4,r5,r6,r7,r8,r9,r10,fp,lr}
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
	
	
	//If no buttons were read, we read again
	ldr r2, =0xFFFF
	cmp r1, r2
	beq Reading2

ihatethis:
	pop	{r4,r5,r6,r7,r8,r9,r10,fp,lr}
	bx	lr


//------------------------------------------------------------------------
//------------------------------------------------------------------------
//------------------------------------------------------------------------


.globl selectMenu
//This function moves the red square up and down based on buttons hit
//	r1 - 1 if we want to move it up
// 	r0 - 0 if we want to move it down
selectMenu:

	push {r4-r10, lr}
	
	cmp r1, #1
	bne moveDown

	ldr r6, =0xF000
	ldr r5, =0x0
	
	b drawIt
	
moveDown:	
	
	ldr r6, =0x0
	ldr r5, =0xF000

drawIt:

	//Sets the color
	mov r3, r6
	//This code draws the red selection box, initalized to beside start	
	ldr r1, =0x1C2 //x offset - 450
	ldr r2, =0x12C //y offset - 300
	ldr r10, =0x1D2 // X max 466
	ldr r9, =0x13C // y max 316

loop9:
	bl drawPixel
	add r1, #1
	cmp r1, r10
	bne loop9
	
	//Resets x back to 450
	ldr r1, =0x1C2	
	
	add r2, #1
	cmp r2, r9
	bne loop9

	//This code draws the red selection box, initalized to beside quit game
	mov r3, r5
	ldr r1, =0x1C2 //x offset - 450 - wont change
	ldr r2, =0x14F //y offset - 335
	ldr r10, =0x1D2 // X max 466 - wont change
	ldr r9, =0x15F // y max 351

loop10:
	bl drawPixel
	add r1, #1
	cmp r1, r10
	bne loop10
	
	//Resets x back to 450
	ldr r1, =0x1C2	
	
	add r2, #1
	cmp r2, r9
	bne loop10

finished1234:

	pop {r4-r10, lr}
	bx	lr

