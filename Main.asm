INCLUDE Irvine32.inc

; Macros from Irvine

;------------------------------------------------------
mWriteString MACRO buffer:REQ
;
; Writes a string variable to standard output.
; Receives: string variable name.
;------------------------------------------------------
	push edx
	mov edx,OFFSET buffer
	call WriteString
	pop edx
ENDM


.data

; Stores CPU and Player moves
randomValue DWORD ?
playerOption DWORD ?

; Commands for the title page
consoleTitle BYTE "Procastacorp RPS",0
gameTitle BYTE "Rock Paper Scissors with a (sometimes) cheating computer",0
gameGreet BYTE "Enjoy :D",0

; Game loop strings
divider BYTE "===================================================", 0

gameStartPrompt BYTE "Rock Paper Scissors Shoot!", 0

playerActionPrompt BYTE "What will you play", 0
commandList BYTE "1 - Rock, 2 - Paper, 3 - Scissors: ", 0


; Game Actions

playerAction1 BYTE "You played rock", 0
playerAction2 BYTE "You played paper", 0
playerAction3 BYTE "You played scissors", 0

cpuAction1 BYTE "Robro played rock", 0
cpuAction2 BYTE "Robro played paper", 0
cpuAction3 BYTE "Robro played scissors", 0

; Robro cheating strings

cpuRockDrawCheat1 BYTE "Robro pulls out and even bigger rock and stares you down", 0
cpuRockDrawCheat2 BYTE "You humbly accept defeat", 0

cpuRockWinCheat1 BYTE "Robro beams you in the head with his rock", 0
cpuRockWinCheat2 BYTE "It hurts really bad and you forfeit from the migraine", 0

cpuPaperDrawCheat1 BYTE "Robro shouts 'look over there!' and quickly tears apart your paper", 0
cpuPaperDrawCheat2 BYTE "You are humiliated for falling for that", 0

cpuPaperWinCheat1 BYTE "Robro quickly covers his rock in hydrochloric acid", 0
cpuPaperWinCheat2 BYTE "Your puny paper melts before your eyes", 0

cpuScissorDrawCheat1 BYTE "Robro pullls out gardening shears and clicks them menacingly", 0
cpuScissorDrawCheat2 BYTE "You drop your safety scissors in terror", 0

cpuScissorWinCheat1 BYTE "Robro pulls out a stealth rock and smashes your scissors when you aren't looking", 0
cpuScissorWinCheat2 BYTE "You are dumbfounded at how some paper did that", 0

winMessage BYTE "You win! ",0
lossMessage BYTE "You lost :( ",0
drawMessage BYTE "A draw! ",0


inputReprompt BYTE "Hey wise guy pick a valid option", 0


playAgainMessage BYTE "Play again? y/n: ",0
loopCond BYTE "y",0

goodbyePrompt BYTE "Thanks For playing! ",0

.code
main proc

	; Code for the title page
	INVOKE SetConsoleTitle, ADDR consoleTitle
	call titlePageDisplay

	call clrscr
	call clrscr

	call Game



	exit

main endp

;------------------------------------
;titlePageDisplay
;Displays strings at specified location
;Ends with wait message
;------------------------------------
titlePageDisplay PROC

	mov dh,2
	mov dl,35
	call Gotoxy
	

	mWriteString gameTitle

	mov dh,4		
	mov dl,52
	call Gotoxy

	mWriteString gameGreet

	mov dh,10		;y coordinate
	mov dl,44		;x coordinate
	call Gotoxy
	call WaitMsg	;displays a message and waits for a key to be pressed

	ret
titlePageDisplay endp


;------------------------------------
;generateCpuChoice
;Generates a number between 1-3
; Stores it in randomValue variable
;------------------------------------
generateCpuChoice PROC
	
	push eax
	push ebx
	push edx
	rdtsc		; grab timestamp 
	mov ebx, 3	; signify range

	; Clear edx before division
	xor edx, edx
	mov eax, eax

	div ebx
	mov randomValue, edx
	inc randomValue
	pop edx
	pop ebx
	pop eax

	ret

generateCpuChoice endp


Game PROC

	mov al, loopCond

	;will continue looping if the user keeps choosing 'y'
	.while ( al == loopCond)

	gameStart:
		mWriteString gameStartPrompt
		call crlf

		; mWriteString playerActionPrompt
		call crlf
		mWriteString commandList
		call ReadInt		; Read user input into eax

		mWriteString divider
		call crlf


		call generateCpuChoice	

		; User prompts rock
		.if ( eax == 1)
			mov eax, yellow + (black * 16)
			call SetTextColor

			mWriteString playerAction1
			mov playerOption, 1
			call crlf
			
			; Rock vs Rock 
			.if (randomValue == 1)
				mWriteString cpuAction1
				call generateCpuChoice

				; CPU successfully cheats
				.if (randomValue == 1)
					call crlf
					mWriteString cpuRockDrawCheat1
					call crlf
					mWriteString cpuRockDrawCheat2
					jmp gameLoss
				.else			
					jmp gameDraw
				.endif
			; Rock vs Paper
			.elseif (randomValue == 2)
				mWriteString cpuAction2
				jmp gameLoss

			; Rock vs Scissor
			.else
				mWriteString cpuAction3
				call generateCpuChoice

				; CPU Successfully cheats
				.if (randomValue == 1)
					call crlf
					mWriteString cpuRockWinCheat1
					call crlf
					mWriteString cpuRockWinCheat2
					jmp gameLoss
				.else			
					jmp gameWin
				.endif
			.endif

		; User prompts paper
		.elseif (eax == 2)
			mov eax, yellow + (black * 16)
			call SetTextColor

			mWriteString playerAction2
			mov playerOption, 2
			call crlf

			.if (randomValue == 1)
				mWriteString cpuAction1
				
				call generateCpuChoice

				.if (randomValue == 1)
					call crlf
					mWriteString cpuPaperWinCheat1
					call crlf
					mWriteString cpuPaperWinCheat2
					jmp gameLoss
				.else			
					jmp gameWin
				.endif

			.elseif (randomValue == 2)
				mWriteString cpuAction2
				
				call generateCpuChoice

				.if (randomValue == 1)
					call crlf
					mWriteString cpuPaperDrawCheat1
					call crlf
					mWriteString cpuPaperDrawCheat2
					jmp gameLoss
				.else			
					jmp gameDraw
				.endif

			.else
				mWriteString cpuAction3
				jmp gameLoss
			.endif

		; User prompts Scissors
		.elseif (eax == 3)

			mov eax, yellow + (black * 16)
			call SetTextColor

			mWriteString playerAction3
			mov playerOption, 3
			call crlf
			
			; Scissors vs Rock
			.if (randomValue == 1)
				mWriteString cpuAction1
				jmp gameLoss
			; Scissors vs Paper
			.elseif (randomValue == 2)
				mWriteString cpuAction2
				call generateCpuChoice

				.if (randomValue == 1)
					call crlf
					mWriteString cpuScissorWinCheat1
					call crlf
					mWriteString cpuScissorWinCheat2
					jmp gameLoss
				.else			
					jmp gameWin
				.endif

			; Scissors vs Scissors
			.else

				mWriteString cpuAction3
				call generateCpuChoice

				.if (randomValue == 1)
					call crlf
					mWriteString cpuScissorDrawCheat1
					call crlf
					mWriteString cpuScissorDrawCheat2
					jmp gameLoss
				.else			
					jmp gameDraw
				.endif

			.endif
		.else
			mWriteString inputReprompt
			call crlf
			jmp gameStart
		.endif

		gameDraw:
			call crlf
			mov eax, blue + (black * 16)
			call SetTextColor
			mWriteString drawMessage
			call crlf
			jmp nextIteration

		gameLoss:
			call crlf
			mov eax, red + (black * 16)
			call SetTextColor
			mWriteString lossMessage 
			call crlf
			jmp nextIteration

		gameWin:
			call crlf
			mov eax, green + (black * 16)
			call SetTextColor
			mWriteString winMessage
			call crlf
			jmp nextIteration
		
		; Prompt for input to continue game loop
		nextIteration:
			mov eax, white + (black * 16)
			call SetTextColor
			mWriteString divider
			call crlf
			mWriteString playAgainMessage
			call ReadChar
			call crlf
			call crlf

	.endw
	
	call clrscr
	mWriteString goodbyePrompt
	call crlf

	ret
Game endp

end main

