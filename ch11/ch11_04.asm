include \Irvine32\Irvine32.inc 
includelib \Irvine32\Irvine32.lib
includelib \Irvine32\Kernel32.lib
includelib \Irvine32\User32.lib 

ScreenSize = 80 * 25	; cols * rows

.code
main PROC

	call Clrscr
	call Randomize				; seed the random number generator

	mov ecx, ScreenSize			; counter (lines of text)
L1:	call ChooseColor
	call SetTextColor
	call ChooseCharacter
	call WriteChar				; display character
	loop L1

; Move to upper left corner, to prevent the screen
; from scrolling at the end
	mov dx,0
	call Gotoxy

	exit
main ENDP

;------------------------------------------------
ChooseColor PROC
;
; Selects a color with a 50% probability
; that the color of any character will be red.
; Receives: nothing
; Returns:  EAX = randomly selected color
;-----------------------------------------------

	mov eax, 32	; range of random numbers ( 0 - 31 )
	call RandomRange	; EAX = Random number
	.IF eax >= 16		; if number is 16-31 (50%)
	  mov eax, red		; choose red
	.ELSE
	  inc eax			; no color 0 (black)
	.ENDIF

	ret
ChooseColor ENDP

;------------------------------------------------
ChooseCharacter PROC
;
; Randomly selects an ASCII character
; Receives: nothing
; Returns:  AL = randomly selected character
;-----------------------------------------------

	mov eax, 0FFh - 1Fh	; range of characters ( 32 - 255 )
	call RandomRange	; AL = Random character
	add eax, 1Fh		; avoid control characters ( < 32 )

	ret
ChooseCharacter ENDP
END main