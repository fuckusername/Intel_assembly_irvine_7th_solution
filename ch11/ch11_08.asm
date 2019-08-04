include \Irvine32\Irvine32.inc 
includelib \Irvine32\Irvine32.lib
includelib \Irvine32\Kernel32.lib
includelib \Irvine32\User32.lib 

DrawSquare PROTO,
	colorPtr:PTR WORD

SquareWidth = 10
SquareHeight = 5

.data
xyPosition COORD <30,7>
color WORD SquareWidth DUP(0Fh)
blank WORD SquareWidth DUP(0)

.code
main PROC

	call Clrscr
	call Randomize	; seed the random number generator
	call ChooseColor

; The specifications don't provide for a way to stop
; the program, so we will arbitrarily put in a loop
; count of 50.
	mov ecx,50	; loop 50 times

L1:	INVOKE DrawSquare,
	  ADDR color

	call DelayNextMove
	INVOKE DrawSquare,
	  ADDR blank

	call MoveSquare
	call ChooseColor
	loop L1	; infinite loop

	exit
main ENDP

;------------------------------------------------------
DrawSquare PROC USES eax ecx edx,
	colorPtr:PTR WORD
;
; Draws a small square on the screen using several
; blocks (ASCII code DBh) in color. xyPosition holds
; the Coordinates of the upper left corner.
; Receives: pointer to array with color attributes.
; Returns:  nothing
;------------------------------------------------------
.data
square BYTE SquareWidth DUP(0DBh)
outputHandle DWORD 0
bytesWritten DWORD 0
pCount DWORD 0
.code

	; Get the console ouput handle:
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov outputHandle, eax	; save console handle

	mov  dx, xyPosition.Y	; save position
	push edx	; save y pos
	mov  ecx, SquareHeight	; number of lines in body

L1:	push ecx	; save counter

	;write color attribute
	INVOKE WriteConsoleOutputAttribute,
	   outputHandle,	; console output handle
	   colorPtr,	; pointer to the square
	   SquareWidth,	; width of square
	   xyPosition,	; coordinates of first char
	   ADDR pCount	; output count

	;write block characters
	INVOKE WriteConsoleOutputCharacter,
	   outputHandle,	; console output handle
	   ADDR square,	; pointer to the square
	   SquareWidth,	; width of square
	   xyPosition,	; coordinates of first char
	   ADDR pCount	; output count

	inc xyPosition.Y	; next line
	pop ecx	; restore counter
	loop L1
	pop edx	; restore y position
	mov xyPosition.Y, dx	; restore position

	ret
DrawSquare ENDP

;------------------------------------------------
ChooseColor PROC USES eax ecx esi
;
; Selects a color between 1 and 16
; Receives: nothing
; Returns: color chosen in the array color
;-----------------------------------------------

	mov eax, 16	; range of random numbers ( 0 - 15 )
	call RandomRange	; EAX = Random number
	inc eax	; no color 0 (black)
	mov esi, OFFSET color	; pointer to color array
	mov ecx, SquareWidth	; length of the array

L1:	mov [esi], ax	; save color
	add esi, 2	; next word in array
	loop L1

	ret
ChooseColor ENDP

;------------------------------------------------------
MoveSquare PROC USES eax
;
; Move the square around the screen in randomly-
; generated directions.Updates the xyPosition variable.
; Receives: nothing
; Returns: nothing
;-------------------------------------------------------

	mov eax, 40	; Range of random numbers (0-39)
	call RandomRange	; EAX = Random number
	.IF eax < 10
	  inc xyPosition.X	; move right
	.ELSEIF eax < 20
	  dec xyPosition.X	; move left
	.ELSEIF eax < 30
	  dec xyPosition.Y	; move up
	.ELSE	; EAX < 40
	  inc xyPosition.Y	; move down
	.ENDIF

	ret
MoveSquare ENDP

;------------------------------------------------
DelayNextMove PROC USES eax
;
; Randomly delays the program's execution for
; a period between 10 ms and 100 ms.
; Receives: nothing
; Returns:  nothing
;-----------------------------------------------

	mov eax, 91	; range of random numbers ( 0 - 90 )
	call RandomRange	; EAX = Random number
	add eax, 10	; range ( 10 - 100 ms )
	call Delay

	ret
DelayNextMove ENDP
END main