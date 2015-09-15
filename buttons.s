.section .text

.globl buttonsLogic
//This function handles the button logic and determines if one was pressed
//	returns: r1 - 0 if no buttons were pressed
buttonsLogic:

	push	{r5,r6,r7,r8,r9,r10,fp,lr}
	
	mov r9, r1

	//Checks which button was pressed	
	ldr r8, =0xFFEF //Up button
	cmp r9, r8
	bne Next1

	//Testing
	ldr r0, =FrameBuff
	ldr r1, =0x0
	mov r2, #7
	mov r3, #7
	bl colorSQ

	//Loads the current player x
	ldr r5, =pCurrX
	ldr r1, [r5]
	
	//Loads the current player y and subs 1 (move up)
	ldr r5,=pCurrY
	ldr r2, [r5]
	sub r2, #1


	//Makes sure nothing gets stomped on
	push {r1,r2,r3,r4,r5,r6,r7,r8}

	//Loads the first byte in valid moves
	ldr r5, =pCurrY
	ldr r4, [r5] //Players Y corr is in r4

	//Determines if a move is valid
	mov r8, r4	//The row number is in r8
	sub r8, #1 	//Subs 1 from row to get correct alignment

	mov r6, #14
	mul r8, r6	//Correct offset is now in r8, must add to validMoves
	ldr r7, =validMoves
	add r7, r8
	mov r1, r7
	b rowFoundU


	//Now that we found a row, we can check to see if the move is valid
rowFoundU:

	bl validUp	
	//If r1 is returned as 1,then the move is valid	
	cmp r1, #1
	bne notValid2U
	
	//A valid move as been found! so we move the player to there
validFoundU:

	pop {r1,r2,r3,r4,r5,r6,r7,r8}
	bl drawPlayer
	b readingDone

	//No valid move was found, so we pop variables and branch away
notValid2U:

	pop {r1,r2,r3,r4,r5,r6,r7,r8}
	b readingDone




//Now we have to do the same for the down button that we did 
//for the right move
Next1:
	ldr r8, =0xFFDF //Down button
	cmp r9, r8
	bne Next2

	//Loads the current player x
	ldr r5, =pCurrX
	ldr r1, [r5]
	
	//Loads the current player y and adds1 (move down)
	ldr r5,=pCurrY
	ldr r2, [r5]
	add r2, #1

	//Makes sure nothing gets stomped on
	push {r1,r2,r3,r4,r5,r6,r7,r8}

	//Loads the first byte in valid moves
	ldr r5, =pCurrY
	ldr r4, [r5] //Players Y corr is in r4


	//Determines if a move is valid
	mov r8, r4	//The row number is in r8
	sub r8, #1 	//Subs 1 from row to get correct alignment

	mov r6, #14
	mul r8, r6	//Correct offset is now in r8, must add to validMoves
	ldr r7, =validMoves
	add r7, r8
	mov r1, r7
	b rowFoundD

	//Now that we found a row, we can check to see if the move is valid
rowFoundD:

	bl validDown	
	//If r1 is returned as 1,then the move is valid	
	cmp r1, #1
	bne notValid2D
	
	//A valid move as been found! so we move the player to there
validFoundD:

	pop {r1,r2,r3,r4,r5,r6,r7,r8}
	bl drawPlayer
	b readingDone

	//No valid move was found, so we pop variables and branch away
notValid2D:

	pop {r1,r2,r3,r4,r5,r6,r7,r8}
	b readingDone


//Does the logic for the right button
Next2:
	ldr r8, =0xFF7F //Right button
	cmp r9, r8
	bne Next3

	//Loads the current player x and adds 1
	ldr r5, =pCurrX
	ldr r1, [r5]
	add r1, #1
	
	//Loads the current player y
	ldr r5,=pCurrY
	ldr r2, [r5]

	//Makes sure nothing gets stomped on
	push {r1,r2,r3,r4,r5,r6,r7,r8}

	//Loads the first byte in valid moves
	ldr r5, =pCurrY
	ldr r4, [r5] //Players Y corr is in r4
	
	//Determines if a move is valid	
	mov r8, r4	//The row number is in r8
	sub r8, #1 	//Subs 1 from row to get correct alignment

	mov r6, #14
	mul r8, r6	//Correct offset is now in r8, must add to validMoves
	ldr r7, =validMoves
	add r7, r8
	mov r1, r7
	b rowFound

	//Now that we found a row, we can check to see if the move is valid
rowFound:

	//mov r7, r1
	//ldr r2, =0xfd
	//mov r3, #2

	bl validRight	
	//If r1 is returned as 1,then the move is valid	
	cmp r1, #1
	bne notValid2
	
	//A valid move as been found! so we move the player to there
validFound:

	pop {r1,r2,r3,r4,r5,r6,r7,r8}
	bl drawPlayer
	b readingDone

	//No valid move was found, so we pop variables and branch away
notValid2:

	pop {r1,r2,r3,r4,r5,r6,r7,r8}
	b readingDone

//Now we have to do the same for the left button that we did 
//for the right move
Next3:
	ldr r8, =0xFFBF //Down button
	cmp r9, r8
	bne Next4

	//Loads the current player x, subs 1 from x to move it to the left
	ldr r5, =pCurrX
	ldr r1, [r5]
	sub r1, #1
	
	//Loads the current player y
	ldr r5,=pCurrY
	ldr r2, [r5]

	//Makes sure nothing gets stomped on
	push {r1,r2,r3,r4,r5,r6,r7,r8}

	//Loads the first byte in valid moves
	ldr r5, =pCurrY
	ldr r4, [r5] //Players Y corr is in r4
testingLeft:	

	//Determines if a move is valid
	mov r8, r4	//The row number is in r8
	sub r8, #1 	//Subs 1 from row to get correct alignment

	mov r6, #14
	mul r8, r6	//Correct offset is now in r8, must add to validMoves
	ldr r7, =validMoves
	add r7, r8
	mov r1, r7
	b rowFoundL

	//Now that we found a row, we can check to see if the move is valid
rowFoundL:

	bl validLeft	
	//If r1 is returned as 1,then the move is valid	
	cmp r1, #1
	bne notValid2L
	
	//A valid move as been found! so we move the player to there
validFoundL:

	pop {r1,r2,r3,r4,r5,r6,r7,r8}
	bl drawPlayer
	b readingDone

	//No valid move was found, so we pop variables and branch away
notValid2L:

	pop {r1,r2,r3,r4,r5,r6,r7,r8}
	b readingDone

//---------
//This is where the logic for the 'a' button press
Next4:
	ldr r8, =0xFEFF //the a button
	cmp r9, r8
	bne Next5 //This is for the last button, will be changed
	//DO SOMETHING TO REACT TO 'a' press

	bl aPressed
	b readingDone


//This is the logic for the start button
Next5:

	ldr r8, =0xFFF7 //the a button
	cmp r9, r8
	bne noButtonHit

	//Returns with what we need to do
	// r1 - 1 restart
	// r1 - 0 quit
	// r2 - 2 continue, carry on
	bl startButton	

	cmp r1, #1
	bne testZero
	
	//Pops all the things that we have on the stack and restarts the game
	pop	{r5,r6,r7,r8,r9,r10,fp,lr}
	pop	{r5,r6,r7,r8,r9,r10,fp,lr}
	b startingGame

testZero:
	cmp r1, #0
	bne testTwo

	//Pops all the things that we have on the stack and restarts the game
	pop	{r5,r6,r7,r8,r9,r10,fp,lr}
	pop	{r5,r6,r7,r8,r9,r10,fp,lr}
	b StartingAgain

testTwo:
	cmp r1, #2
	bne readingDone

	//From where, we have to redraw all the game board, with the correct
	//  keys missing, and doors missing

	//Clears the screen
	bl clearScreen

	//Draws the Grid
	ldr r10, =FrameBuff
	str r0, [r10]
	mov		r1, #190
	mov		r2, #64
	ldr		r3,	=0xFFFF
	bl DrawGrid
	
	//Draws the walls
	//bl drawWalls
	bl drawWall

	//Draws the remaing Keys
	bl drawKeys

	//Draws the player
	ldr r10, =pCurrX
	ldr r1, [r10]
	ldr r10, =pCurrY
	ldr r2, [r10]
	
	ldr r10, =removeMoves
	mov r9, #0
	strb r9, [r10]
	bl drawPlayer

	ldr r10, =removeMoves
	mov r9, #1
	strb r9, [r10]

	//Draws the string: "Number of moves remaing:"
	bl writeStaticStrings

	//Displays the number of keys left
	bl writeNumKeys

	//Writes the number of moves to the screen
	bl writeNumMoves

	//Draws the doors
	bl drawDoors

	pop	{r5,r6,r7,r8,r9,r10,fp,lr}
	pop	{r5,r6,r7,r8,r9,r10,fp,lr}
	b readLoop
	
	b haltLoop$
	
	
	mov r1, #0
	b readingDone

noButtonHit:
	
	mov r1, #1
	
readingDone:
	pop	{r5,r6,r7,r8,r9,r10,fp,lr}
	bx 	lr


//------------------------------------------------------------------------
//------------------------------------------------------------------------
//------------------------------------------------------------------------


.globl aPressed
//This function is for the logic of when a button a is pressed
aPressed:
	push {r4,r5,r6,r7,r8,r9,r10,fp,lr}
wait2:

	ldr r10, =numKeys
	ldr r4, [r10]
	//Loads the x coordinate to r1
	ldr r10, =pCurrX
	ldr r1, [r10]


//Checks all the doors adjacent in the 7th column
	cmp r1, #7
	bne NextDoor1

	//Puts the y coor into r1
	ldr r10, =pCurrY
	ldr r1, [r10]

	cmp r1, #8
	bne NextDoor7Y
	
	//Checks to see if we have enough keys to open the door	
	ldr r10, =numKeys
	ldr r1, [r10]
	cmp r1, #0
	beq NoKeys //If we have no keys we leave the function
	
	mov r1, #0
	bl changeNumKey
	
	//Now we need to color the the 7,8 square white and
	//  then add the valid move to the list of moves for this square
	//

	
	//FROM HERE I NEED TO UPDATE THE VALID MOVES FOR SQUARE
	// FOR 7,8
	//Changes the color of the square that the door was on
	ldr r10, =FrameBuff
	ldr r0, [r10]
	ldr r1, =0xFFFF
	mov r2, #7
	mov r3, #7
	bl colorSQ

	//Updates the fact that this door has been opened
	ldr r10, =doorsTaken
	add r10, #2
	mov r9, #0
	strb r9, [r10]

	//Loads the valid moves for the square before the door at 7,7
	ldr r10, =validMoves
	add r10, #98
	add r10, #6
	mov r2, #5
	strb r2, [r10]
	b NoKeys
	


//Handles the logic for door at 8,4
NextDoor7Y:

	cmp r1, #4
	bne NextDoor7Y2

	//Checks to see if we have enough keys to open the door	
	ldr r10, =numKeys
	ldr r1, [r10]
	cmp r1, #0
	beq NoKeys //If we have no keys we leave the function
	
	//Removes 1 key
	mov r1, #0
	bl changeNumKey
	
	//Changes the color of the square that the door was on
	ldr r10, =FrameBuff
	ldr r0, [r10]
	ldr r1, =0xFFFF
	mov r2, #8
	mov r3, #4
	bl colorSQ

	//Updates the fact that this door has been opened
	ldr r10, =doorsTaken
	add r10, #1
	mov r9, #0
	strb r9, [r10]

	//Loads the valid moves for the square before the door at 8,4
	ldr r10, =validMoves
	add r10, #42
	add r10, #6
	mov r2, #7
	strb r2, [r10]

//Handles the logic for the door at 8,1
NextDoor7Y2:

	cmp r1, #1
	bne NextDoor1

	//Checks to see if we have enough keys to open the door	
	ldr r10, =numKeys
	ldr r1, [r10]
	cmp r1, #0
	beq NoKeys //If we have no keys we leave the function

	//Removes 1 key
	mov r1, #0
	bl changeNumKey

	//Changes the color of the square that the door was on
	ldr r10, =FrameBuff
	ldr r0, [r10]
	ldr r1, =0xFFFF
	mov r2, #8
	mov r3, #1
	bl colorSQ


	//Updates the fact that this door has been opened
	ldr r10, =doorsTaken
	mov r9, #0
	strb r9, [r10]


	//Loads the valid moves for the square before the door at 8,1
	ldr r10, =validMoves
	add r10, #0
	add r10, #6
	mov r2, #14
	strb r2, [r10]

	ldr r10, =validMoves
	add r10, #0
	add r10, #8
	mov r2, #10
	strb r2, [r10]

	b NoKeys //Leave this because we used our key

NextDoor1: //For doors not in the 7th column

	//Loads the x coordinate to r1
	ldr r10, =pCurrX
	ldr r1, [r10]
	
	cmp r1, #13
	bne checkOtherSide

	//Puts the y coor into r1
	ldr r10, =pCurrY
	ldr r1, [r10]

	cmp r1, #9
	bne checkFinal

doubleDoor:
	//Checks to see if we have enough keys to open the door	
	ldr r10, =numKeys
	ldr r1, [r10]
	cmp r1, #0
	beq NoKeys //If we have no keys we leave the function

	//Removes 1 key
	mov r1, #0
	bl changeNumKey

	//Changes the color of the square that the door was on
	ldr r10, =FrameBuff
	ldr r0, [r10]
	ldr r1, =0xFFFF
	mov r2, #12
	mov r3, #9
	bl colorSQ

	//Updates the fact that this door has been opened
	ldr r10, =doorsTaken
	add r10, #3
	mov r9, #0
	strb r9, [r10]

	//Loads the valid moves for the square before the door at 12,9
	ldr r10, =validMoves
	add r10, #112
	add r10, #10
	mov r2, #7
	strb r2, [r10]

	//Loads the valid moves for the square before the door at 12,9
	ldr r10, =validMoves
	add r10, #112
	add r10, #12
	mov r2, #10
	strb r2, [r10]

checkOtherSide:	

	cmp r1, #11
	bne checkFinal

	//Puts the y coor into r1
	ldr r10, =pCurrY
	ldr r1, [r10]

	cmp r1, #9
	bne checkFinal
	b doubleDoor

//Implements the logic for the final door
checkFinal:

	//Loads the x coordinate to r1
	ldr r10, =pCurrX
	ldr r1, [r10]

	cmp r1, #14
	bne NoKeys

	//Loads the x coordinate to r1
	ldr r10, =pCurrY
	ldr r1, [r10]
finalcheck:
	cmp r1, #15
	bne NoKeys

	//Checks to see if we have enough keys to open the door	
	ldr r10, =numKeys
	ldr r1, [r10]
	cmp r1, #0
	beq NoKeys //If we have no keys we leave the function

	mov r1, #0
	bl changeNumKey

	//Changes the color of the square that the door was on
	ldr r10, =FrameBuff
	ldr r0, [r10]
	ldr r1, =0xFFFF
	mov r2, #14
	mov r3, #16
	bl colorSQ

	//Since we've opened the final door, we now have to 
	// change the win flag in memory to 1
	ldr r10, =winLoseFlag
	mov r1, #1
	str r1, [r10]

	b NoKeys //Leave this because we used our key

NoKeys: //Leaves the loop because we cant open a door with no keys


	pop {r4,r5,r6,r7,r8,r9,r10,fp,lr}
	bx lr


