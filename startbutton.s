.section .text

.globl startButton
//This function handles the start button 
// being pressed 
//	r1  - 1 if we need to restart
//	r1  - 0 if we need to quit
//	r1  - 2 if we need to continue
startButton:

	push {r4-r10, lr}

	bl clearScreen

	//Draws menuBox
	bl drawMenuBox

	//Draws menu square
	bl drawMenuSquare

	//This code writes the game menu
	mov r9, #0 //loop counter
	ldr r10, =stringMenu
	ldr r5, =0xC8 //y offset - 200
	ldr r6, =0x1c2 //x offset - 450
	add r6, #25
letterLoop:
	
	mov r2, r6
	mov r3, r5	

	ldr r1, [r10]
	bl drawLetter

	add r10, #4
	add r6, #10
	add r9, #1

	cmp r9, #4
	bne letterLoop

	//This code writes the restart game string
	mov r9, #0 //loop counter
	ldr r10, =stringRestartGame
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

	cmp r9, #12
	bne letterLoop2

	//This code writes the quit string
	mov r9, #0 //loop counter
	ldr r10, =stringQuit
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

	cmp r9, #4
	bne letterLoop3


	//Initializes the red box
	mov r1, #1
	bl selectMenu

//---------------------------------
read:

	bl readingMenu

	//If the up arrow was hit, move the red box
	ldr r10, =0xFFEF
	cmp r1, r10
	bne nextCheck1

	//Argument for select menu
	mov r1, #1

	//Updates which menu selection we're on
	// 1 - restart game
	// 0 - quit 
	ldr r5, =mainPauseSelection
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
	// 1 - restart game
	// 0 - quit
	ldr r5, =mainPauseSelection
	strb r1, [r5]

	bl selectMenu

	b read

	//If the 'a' button was hit
nextCheck2:
	ldr r10, =0xFEFF 	
	cmp r1, r10
	bne nextCheck3
	
	ldr r8, =mainPauseSelection
	ldrb r5, [r8]
	cmp r5, #1
	bne quitGame
	
	//moves 1 to r1 to say that we need to restart
	mov r1, #1 
	b done

quitGame:
	//If we make it here, it has to call reset and then branch to haltLoop
	//pop {r4-r10, lr}
	mov r1, #0
	b done

//Checks if the start button was pressed
nextCheck3:
	ldr r10, =0xFFF7	
	cmp r1, r10
	bne read //Bracnh back to read if no appropriate buttons were hit

	mov r1, #2
	b done

done:
	pop {r4-r10, lr}
	bx 	lr

