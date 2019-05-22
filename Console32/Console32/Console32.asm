TITLE Console32 Assembly Library Source Code

.data

iFlag DWORD 0
error1   BYTE "StringIndexOutOfBoundsException: The Index ",0
error2	BYTE " is invalid.",0
new			BYTE 0Dh,0Ah,0

HANDLE TEXTEQU <DWORD>
bytesWritten DWORD ?
consoleOutHandle HANDLE ?
consoleInHandle HANDLE ?

BUFFERSIZE = 200
substringBuffer BYTE BUFFERSIZE DUP(0),0

.code
;============================================
;The following proceedures are those that
;I have created. These are the library
;proceedures.
;============================================

;--------------------------------------------
Substring PROC,
	string:PTR BYTE,
	sIndex:DWORD
;Return a substring of source in EDX
;--------------------------------------------
	PUSH EAX
	PUSH ECX
	PUSH ESI
	PUSH EDI

	INVOKE StringLength, string
	MOV ECX, EAX
	SUB ECX, sIndex
	CMP sIndex, EAX
	JNL error

	MOV ESI, string
	MOV EDI, OFFSET substringBuffer
	MOV ECX, EAX
	SUB ECX, sIndex
	DEC ESI
	INC ECX
	CLD
	ADD ESI, sIndex
	REP MOVSB

	POP EDI
	POP ESI
	POP ECX
	POP EAX
error:
	MOV EDX, OFFSET substringBuffer
	RET
Substring ENDP

;---------------------------------------------
SubstringFromTo PROC,
	string:PTR BYTE,
	from:DWORD,
	to:DWORD
;Returns a substring os source from index
;"from" to index "to" in EDX
;---------------------------------------------
	PUSH EAX
	PUSH ECX
	PUSH ESI
	PUSH EDI

	INVOKE StringLength, string
	MOV ECX, EAX
	SUB ECX, from
	CMP from, EAX
	JNL error
	CMP to, EAX
	JNL error

	MOV ESI, string
	MOV EDI, OFFSET substringBuffer
	MOV ECX, to
	SUB ECX, from
	CLD
	ADD ESI, from
	DEC ECX
	REP MOVSB

	POP EDI
	POP ESI
	POP ECX
	POP EAX
error:
	MOV EDX, OFFSET substringBuffer
	RET
SubstringFromTo ENDP


;============================================
;The following proceedures are copied from
;Kip Irvine's Irvine32 library. The sole
;purpose of these proceedures is to eliminate
;dependencies. These procedures are not to be
;used except by my proceedures.
;============================================

;-------------------------------------------------------------
IsInitialized MACRO		;CheckInit
;
; Helper macro
; Check to see if the console handles have been initialized
; If not, initialize them now.
;-------------------------------------------------------------
LOCAL exit
	cmp iFlag,0
	jne exit
	call Initializer
exit:
	ENDM

;---------------------------------------------------------
StringLength PROC USES edi,		;Str_Length
	pString:PTR BYTE	; pointer to string
;
; Return the length of a null-terminated string.
; Receives: pString - pointer to a string
; Returns: EAX = string length
;---------------------------------------------------------
	mov edi,pString
	mov eax,0     	                ; character count
L1:
	cmp BYTE PTR [edi],0	      ; end of string?
	je  L2	                     ; yes: quit
	inc edi	                     ; no: point to next
	inc eax	                     ; add 1 to count
	jmp L1
L2: ret
StringLength ENDP

;--------------------------------------------------------
Write PROC		;WriteString
;
; Writes a null-terminated string to standard
; output. Input parameter: EDX points to the
; string.
; Last update: 9/7/01
;--------------------------------------------------------
	pushad

	IsInitialized

	INVOKE StringLength,edx   	; return length of string in EAX
	cld	; must do this before WriteConsole

	INVOKE WriteConsole,
	    consoleOutHandle,     	; console output handle
	    edx,	; points to string
	    eax,	; string length
	    OFFSET bytesWritten,  	; returns number of bytes written
	    0

	popad
	ret
Write ENDP

;-----------------------------------------------------
WriteNum PROC		;WriteInt
;
; Writes a 32-bit signed binary integer to the console window
; in ASCII decimal.
; Receives: EAX = the integer
; Returns:  nothing
; Comments: Displays a leading sign, no leading zeros.
; Last update: 7/11/01
;-----------------------------------------------------
WI_Bufsize = 12
true  =   1
false =   0
.data
buffer_B  BYTE  WI_Bufsize DUP(0),0  ; buffer to hold digits
neg_flag  BYTE  ?

.code
	pushad
	IsInitialized

	mov   neg_flag,false    ; assume neg_flag is false
	or    eax,eax             ; is AX positive?
	jns   WIS1              ; yes: jump to B1
	neg   eax                ; no: make it positive
	mov   neg_flag,true     ; set neg_flag to true

WIS1:
	mov   ecx,0              ; digit count = 0
	mov   edi,OFFSET buffer_B
	add   edi,(WI_Bufsize-1)
	mov   ebx,10             ; will divide by 10

WIS2:
	mov   edx,0              ; set dividend to 0
	div   ebx                ; divide AX by 10
	or    dl,30h            ; convert remainder to ASCII
	dec   edi                ; reverse through the buffer
	mov   [edi],dl           ; store ASCII digit
	inc   ecx                ; increment digit count
	or    eax,eax             ; quotient > 0?
	jnz   WIS2              ; yes: divide again

	; Insert the sign.

	dec   edi	; back up in the buffer
	inc   ecx               	; increment counter
	mov   BYTE PTR [edi],'+' 	; insert plus sign
	cmp   neg_flag,false    	; was the number positive?
	jz    WIS3              	; yes
	mov   BYTE PTR [edi],'-' 	; no: insert negative sign

WIS3:	; Display the number
	mov  edx,edi
	call Write

	popad
	ret
WriteNum ENDP

;----------------------------------------------------
Initializer PROC private	;Initialize
;
; Get the standard console handles for input and output,
; and set a flag indicating that it has been done.
; Updated 03/17/2003
;----------------------------------------------------
	pushad

	INVOKE GetStdHandle, STD_INPUT_HANDLE
	mov [consoleInHandle],eax

	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov [consoleOutHandle],eax

	mov iFlag,1

	popad
	ret
Initializer ENDP

NewLine PROC USES EDX	;CrLf Clone
	MOV EDX, OFFSET new
	CALL Write
	RET
NewLine ENDP