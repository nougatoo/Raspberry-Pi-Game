.section    .init
.globl     _start

_start:
    b       main
    
.section .text

main:
    mov     sp, #0x8000
	
	bl		EnableJTAG
	bl Initialize

	bl		InitFrameBuffer //TAKEN FROM TA

	// branch to the halt loop if there was an error initializing the framebuffer
	cmp		r0, #0
	ldr r1, =FrameBuff
	str r0, [r1]
	beq		haltLoop$

.globl StartingAgain
StartingAgain:	

	//Resets things that have been changed	
	bl reset	
		
	//Draws the game menu and does the logic for it
	bl drawMainMenu		

.globl startingGame
startingGame:

	//Resets anything thats been changed
	bl reset	

	//Draws the grid
	bl DrawGrid

	//Draws the Walls
	bl drawWall

	//Draws the string: "Number of moves remaing:"
	bl writeStaticStrings
	
	//Displays the number of keys left
	bl writeNumKeys

	//Writes the number of moves to the screen
	bl writeNumMoves

	//Draw the doors
	bl drawDoors

	//Draw the keys
	bl drawKeys

	//Draws initial player
	ldr r1, =0x0FF0
	mov r2, #1
	mov r3, #15
	
	//Updates the current square the player is on to 1,15
	ldr r4, =pCurrX
	str r2, [r4]
	ldr r4, =pCurrY
	str r3, [r4]
	bl colorSQ


.globl readLoop
readLoop:
	//Waits until no buttons are pressed and reads from SNES
	bl ReadingWait
	bl Reading
	
	//Checks to see if there are moves left
	bl checkMoves
	cmp r1, #1
	beq haltLoop$

	//if the win flag this will produce a message
	bl writeWL

	//Checks to see if the player is in a keySpot
	//If they are, we add a key
	bl checkKeySpot
	cmp r1, #1
	bleq changeNumKey

	//Waits until no buttons are pressed
	bl ReadingWait

	//Checks to see if the winLoseFlag has been changed
	ldr r10, =winLoseFlag
	ldr r1, [r10]
	cmp r1, #8
	bne readingAny
	
	b readLoop

.globl haltLoop$
haltLoop$:
	b		haltLoop$

