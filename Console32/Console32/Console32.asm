TITLE Console32 Assembly Library Source Code

.data
BUFFERSIZE = 200
substringBuffer BYTE BUFFERSIZE DUP(0),0
index DWORD 0;

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

;----------------------------------------
CharacterAt PROC,
	string:PTR BYTE,
	index:DWORD
;Return the character at the given index
;in the string in AL, or 0 if index is
;invalid
;---------------------------------------

	INVOKE StringLength, string
	CMP index, EAX
	JNL error

	MOV ESI, string
	ADD ESI, index
	MOV EAX, 0
	MOV AL, [ESI]
	JMP return
	LOOP

error:
	MOV AL, 0

return:
	RET
CharacterAt ENDP

;------------------------------------------------
IndexOf PROC,
	string:PTR BYTE,
	char:BYTE
;Return the index of a character in the
;string, or -1 if the string does not
;contain it.
;-----------------------------------------------
	
	INVOKE StringLength, string
	MOV ECX, EAX
	MOV ESI, string
	 
L1:
	MOV AL, [ESI]
	CMP AL, char
	JE returngood
	INC index
	INC ESI
	LOOP L1
	MOV EAX, -1
	JMP return
returngood:
	MOV EAX, index
return:
	RET

IndexOf ENDP


;============================================
;The following proceedures are copied from
;Kip Irvine's Irvine32 library. The sole
;purpose of these proceedures is to eliminate
;dependencies. These procedures are not to be
;used except by my proceedures.
;============================================

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

