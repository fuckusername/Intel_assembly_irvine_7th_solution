include \Irvine32\Irvine32.inc 
includelib \Irvine32\Irvine32.lib
includelib \Irvine32\Kernel32.lib
includelib \Irvine32\User32.lib 

.code
main PROC
	call ClearScreen				; call the procedure

main ENDP

;-------------------------------------------------------
ClearScreen PROC
;
; Clear the screen by writing blanks to all positions
; Receives: Nothing
; Returns: Nothing
;-------------------------------------------------------
.data
blanks BYTE (80 * 25) DUP(' ')
blankSize = ($ - blanks)
upperLeft COORD <0,0>
consoleOutHandle DWORD 0
bytesWritten DWORD 0

.code
	pushad

; Get the console ouput handle
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov consoleOutHandle, eax		; save console handle

; Set cursor to upper left corner of screen
	INVOKE SetConsoleCursorPosition,
	  consoleOutHandle,
	  upperLeft

; Write blanks to the screen
	INVOKE WriteConsole,
	    consoleOutHandle,			; console output handle
	    offset blanks,				; string pointer
	    blankSize,					; string length
	    offset bytesWritten,		; returns number of bytes written
	    0

	INVOKE SetConsoleCursorPosition,
	  consoleOutHandle,
	  upperLeft

	popad
	ret
ClearScreen ENDP
END main