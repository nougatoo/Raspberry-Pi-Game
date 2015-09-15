.section .data


.align 4
.globl	stringNumMovesLeft
stringNumMovesLeft:
	.word 'N','U','M','B','E','R',' ', 'O','F',' ','M','O','V','E','S',' ','L','E','F','T',':'

.align 4
.globl stringKeys
stringKeys:
	.word 'K','E','Y','S',':'

.align 4
.globl stringNumbers
stringNumbers:
	.word '0','1','2','3','4','5','6','7','8','9'

.align 4
.globl stringWinGame
stringWinGame:
	.word 'Y','O','U',' ','H','A','V','E',' ','W','O','N'
	.word ' ','P','R','E','S','S',' ','A','N','Y',' '
	.word 'B','U','T','T','O','N',' ','T','O',' ','C'
	.word 'O','N','T','I','N','U','E'
.align 4
.globl stringLostGame
stringLostGame:
	.word 'Y','O','U',' ','L','O','S','T','!','!','!','!'
	.word ' ','P','R','E','S','S',' ','A','N','Y',' '
	.word 'B','U','T','T','O','N',' ','T','O',' ','C'
	.word 'O','N','T','I','N','U','E'
.align 4
.globl stringGameName
stringGameName:
	.word 'L','O','C','K','S',' ','A','N','D',' ','B','L','O'
	.word 'C','K','S'
.align 4
.globl stringStartGame
stringStartGame:
	.word 'S','T','A','R','T',' ','G','A','M','E'
.align 4
.globl stringQuitGame
stringQuitGame:
	.word 'Q','U','I','T',' ','G','A','M','E'
.align 4
.globl stringCreater
stringCreater:
	.word 'C','R','E','A','T','E','D',' ','B','Y',' ','B','R','A'
	.word 'N','D','O','N',' ','B','R','I','E','N'
.align 4
.globl stringMenu
stringMenu:
	.word 'M','E','N','U'
.align 4
.globl stringQuit
stringQuit:
	.word 'Q','U','I','T'
.align 4
.globl stringRestartGame
stringRestartGame:
	.word 'R','E','S','T','A','R','T',' ','G','A','M','E'
.align 4
.globl winLoseFlag
winLoseFlag:
	.word 8

.align 4
.globl Color
Color:
	.word	0x0
.align 4
.globl xCor
xCor:
	.word	0x0

.align 4
.globl yCor
yCor:
	.word	0x0


.align 4
.globl FrameBuff
FrameBuff:
	.word 0x0

.align 4
.globl pCurrX
pCurrX:
	.word 0

.align 4
.globl pCurrY
pCurrY:
	.word 0

.align 4
.globl numMovesHundred
numMovesHundred:
	.word 1

.align 4
.globl numMovesTen
numMovesTen:
	.word 5

.align 4
.globl numMovesOne
numMovesOne:
	.word 0

.align 4
.globl numKeys
numKeys:
	.word 0

.align 1
.globl greys
greys:
	.byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	.byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
	.byte 1,0,1,1,1,0,1,0,1,1,1,1,1,1,0,1
	.byte 1,0,1,0,1,0,1,0,1,0,0,0,1,1,0,1
	.byte 1,0,1,0,1,0,1,0,0,0,1,0,1,1,0,1
	.byte 1,0,1,0,1,0,1,0,1,0,1,0,1,1,0,1
	.byte 1,0,1,0,1,0,1,0,1,0,1,0,1,1,0,1
	.byte 1,0,0,0,0,0,1,0,1,0,1,0,1,1,0,1
	.byte 1,1,1,1,1,1,1,0,1,0,1,0,1,1,0,1
	.byte 1,0,0,0,0,0,1,0,1,0,1,0,0,0,0,1
	.byte 1,1,1,1,1,0,1,0,1,0,1,0,1,1,1,1
	.byte 1,0,0,0,0,0,1,0,1,0,1,0,0,0,0,1
	.byte 1,0,1,1,1,1,1,0,1,0,1,1,1,1,0,1
	.byte 1,0,0,0,0,0,0,0,1,0,0,0,0,1,0,1
	.byte 1,1,1,1,1,1,1,0,1,1,1,1,0,1,0,1
	.byte 1,0,0,0,0,0,0,0,1,0,0,0,0,1,0,1
	.byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1

.align 1
.globl validMoves
validMoves:
	.byte 6,10,10,10,14,10,12,10,2,10,10,10,10,12
	.byte 5,0,0,0,5,0,5,0,0,0,0,0,0,5
	.byte 5,0,4,0,5,0,5,0,6,10,12,0,0,5
	.byte 5,0,5,0,5,0,5,10,13,0,5,0,0,5
	.byte 5,0,5,0,5,0,5,0,5,0,5,0,0,5
	.byte 5,0,5,0,5,0,5,0,5,0,5,0,0,5
	.byte 3,10,11,10,9,0,5,0,5,0,5,0,0,5
	.byte 0,0,0,0,0,0,4,0,5,0,5,0,0,5
	.byte 2,10,10,10,12,0,5,0,5,0,5,10,2,9
	.byte 0,0,0,0,5,0,5,0,5,0,5,0,0,0
	.byte 6,10,10,10,9,0,5,0,5,0,3,10,10,12
	.byte 5,0,0,0,0,0,5,0,5,0,0,0,0,5
	.byte 3,10,10,10,10,10,13,0,3,10,10,12,0,5
	.byte 0,0,0,0,0,0,5,0,0,0,0,5,0,5
	.byte 2,10,10,10,10,10,9,0,2,10,10,9,0,1

.align 1
.globl key1
key1:
	.byte 1

.align 1
.globl key2
key2:
	.byte 1

.align 1
.globl key3
key3:
	.byte 1

.align 1
.globl doorsTaken
doorsTaken:
	.byte 1,1,1,1


.align 1
.globl mainMenuSelection
mainMenuSelection:
	.byte 1

.align 1
.globl mainPauseSelection
mainPauseSelection:
	.byte 1

.align 1
.globl removeMoves
removeMoves:
	.byte 1

.align 4
.globl font
font:		.incbin	"font.bin"
