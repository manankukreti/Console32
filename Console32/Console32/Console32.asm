TITLE Console32 Assembly Library Source Code
INCLUDE Console32.inc

.data
BUFFERSIZE = 200
substringBuffer BYTE BUFFERSIZE DUP(0),0
index DWORD 0
counter DWORD 0

stringBuilderBuffer BYTE BUFFERSIZE DUP(0),0
tempBuffer BYTE BUFFERSIZE DUP(0),0
emptyBuffer BYTE BUFFERSIZE DUP(0),0

tokenizerBuffer BYTE BUFFERSIZE DUP(0),0
tokenBuffer BYTE BUFFERSIZE DUP(0),0
currentI DWORD 0
delim BYTE ' '

.code
Name1 PROC

Name1 ENDP

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
	cindex:DWORD
;Return the character at the given index
;in the string in AL, or 0 if index is
;invalid
;---------------------------------------

	PUSH ESI

	INVOKE StringLength, string
	CMP cindex, EAX
	JNL error

	MOV ESI, string
	ADD ESI, cindex
	MOV EAX, 0
	MOV AL, [ESI]
	JMP return

error:
	MOV AL, 0

return:
	POP ESI
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
	PUSH ECX
	PUSH ESI

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

	COMMENT!

	!
	MOV EAX, -1
	JMP return
returngood:
	MOV EAX, index
return:
	POP ESI
	POP ECX
	RET

IndexOf ENDP

;----------------------------------------------
LastIndexOf PROC,
	string:PTR BYTE,
	char:BYTE
;Returns the last index of a character in a
;string or -1 if it doesn't exist
;------------------------------------------------
	PUSH EBX
	PUSH ECX
	PUSH EDX
	PUSH EDI

MOV index, -1
	INVOKE StringLength, string
	MOV ECX, EAX
	MOV EDX, EAX
	MOV ESI, string
	 
L1:
	MOV AL, [ESI]
	CMP AL, char
	JE change
	JMP continue
change:
MOV EBX, EDX
SUB EBX, ECX
	MOV index, EBX
continue:
	INC ESI
	LOOP L1
	MOV EAX, index

	POP EDI
	POP EDX
	POP ECX
	POP EBX
	RET
LastIndexOf ENDP

;------------------------------------------
NthIndexOf PROC,
	string:PTR BYTE,
	char:BYTE,
	n:DWORD
;returns the nth index of a characer in a
;string, the n-1th index if the nth doesn't
;exist, or -1 if the character isn't in the
;string
;------------------------------------------

	PUSH EBX
	PUSH ECX
	PUSH EDX
	PUSH ESI
	PUSH EDI

	MOV counter, 0
	MOV EDI, n
	MOV index, -1
	INVOKE StringLength, string
	MOV ECX, EAX
	MOV EDX, EAX
	MOV ESI, string
	 
L1:
	MOV AL, [ESI]
	CMP AL, char
	JE change
	JMP continue
change:
MOV EBX, EDX
SUB EBX, ECX
	MOV index, EBX
	INC counter
	CMP counter, EDI
	JE endL
continue:
	INC ESI
	LOOP L1
endL:
	MOV EAX, index

	POP EDI
	POP ESI
	POP EDX
	POP ECX
	POP EBX
	RET
NthIndexOf ENDP

;--------------------------------------------
StringBuilderInsertAt PROC,
	string:PTR BYTE,
	i:DWORD
;inserts a string into a stringbuilder at index i
;--------------------------------------------
	PUSHAD

	INVOKE StringLength, string
	MOV EBX, EAX
	INVOKE StringLength, OFFSET stringBuilderBuffer
	
	CLD

	CMP EAX, 0
	JNE insert

	MOV ESI, string
	MOV EDI, OFFSET stringBuilderBuffer
	MOV ECX, EBX
	REP MOVSB

	JMP return
	
insert:
	
	MOV ESI, OFFSET stringBuilderBuffer
	MOV EDI, OFFSET tempBuffer
	MOV ECX, i
	REP MOVSB

	MOV ESI, string
	MOV ECX, EBX
	REP MOVSB

	MOV ESI, OFFSET stringBuilderBuffer
	MOV EDI, OFFSET tempBuffer
	ADD ESI, i
	ADD EDI, i
	ADD EDI, EBX
	MOV ECX, BUFFERSIZE
	SUB ECX, i
	SUB ECX, EBX
	REP MOVSB

	MOV ESI, OFFSET tempBuffer
	MOV EDI, OFFSET stringBuilderBuffer
	MOV ECX, BUFFERSIZE
	REP MOVSB

	MOV ESI, OFFSET emptyBuffer
	MOV EDI, OFFSET tempBuffer
	MOV ECX, BUFFERSIZE
	REP MOVSB

return:
	POPAD
	RET
StringBuilderInsertAt ENDP

;------------------------------------------------------
StringBuilderAppend PROC,
	string:PTR BYTE
;Appends a string to the end of a string builder
;-----------------------------------------------------

	PUSH EAX
	INVOKE StringLength, OFFSET stringBuilderBuffer
	INVOKE StringBuilderInsertAt, string, EAX
	POP EAX
	RET
StringBuilderAppend ENDP

;-----------------------------------------------------
StringBuilderDelete PROC,
	start:DWORD,
	endI: DWORD
;deletes all characters starting from index "start" and
;ending on index "endI"
;--------------------------------------------------------

	PUSHAD
	PUSHFD

	INVOKE StringLength, OFFSET StringBuilderBuffer

	CLD

	MOV ESI, OFFSET stringBuilderBuffer
	MOV EDI, OFFSET tempBuffer
	
	CMP start, 0
	JE fix

	MOV ECX, start
	REP MOVSB

	ADD ESI, endI
	SUB ESI, start
	MOV ECX, EAX
	SUB ECX, endI
	REP MOVSB
	
	JMP return
fix:
	ADD ESI, endI
	MOV ECX, EAX
	SUB ECX, endI
	REP MOVSB
return:
	MOV ESI, OFFSET emptyBuffer
	MOV EDI, OFFSET stringBuilderBuffer
	MOV ECX, BUFFERSIZE
	REP MOVSB

	MOV ESI, OFFSET tempBuffer
	MOV EDI, OFFSET stringBuilderBuffer
	MOV ECX, BUFFERSIZE
	REP MOVSB

	MOV ESI, OFFSET emptyBuffer
	MOV EDI, OFFSET tempBuffer
	MOV ECX, BUFFERSIZE
	REP MOVSB
	POPFD
	POPAD

	RET
StringBuilderDelete ENDP

;--------------------------------------------------
StringBuilderDeleteCharAt PROC,
	i:DWORD
;Removes a given character from the stringbuilder-
;--------------------------------------------------
	PUSHAD
	MOV EAX, i
	MOV EBX, EAX
	INC EBX
	INVOKE StringBuilderDelete, EAX, EBX

	POPAD
	RET
StringBuilderDeleteCharAt ENDP

;----------------------------------------------------------
StringBuilderReverse PROC
;Reverses the string
;----------------------------------------------------------
	PUSHAD

	INVOKE StringLength, OFFSET stringBuilderBuffer

	MOV EDX, 0
	MOV ECX, EAX
	MOV ESI, OFFSET stringBuilderBuffer
	ADD ESI, EAX
	DEC ESI

	MOV EDI, OFFSET tempBuffer
L1:
	MOV EBX, EAX
	SUB EBX, ECX

	MOV DH, [ESI]
	MOV [EDI],DH
	INC EDI
	DEC ESI
	LOOP L1

	CLD

	MOV ESI, OFFSET tempBuffer
	MOV EDI, OFFSET stringBuilderBuffer
	MOV ECX, EAX
	REP MOVSB

	MOV ESI, OFFSET emptyBuffer
	MOV EDI, OFFSET tempBuffer
	MOV ECX, BUFFERSIZE
	REP MOVSB

	POPAD
	RET
StringBuilderReverse ENDP


;------------------------------------------
GetStringBuilder PROC
;Returns the address of the string in EDX
;------------------------------------------
	MOV EDX, OFFSET stringBuilderBuffer
	RET
GetStringBuilder ENDP

;-----------------------------------------------
EmptyStringBuilder PROC USES ECX ESI EDI
;Empties the StringBuilder
;-----------------------------------------------
	MOV ECX, BUFFERSIZE
	MOV EDI, OFFSET stringBuilderBuffer
	MOV ESI, OFFSET emptyBuffer
	REP MOVSB
	RET
EmptyStringBuilder ENDP

;-----------------------------------------------
InitializeTokenizer PROC,
	string:PTR BYTE
;Initializes the StringTokenizer with a string
;-----------------------------------------------
	PUSH ESI
	PUSH EDI
	PUSH ECX
	PUSH EAX

	CLD
	INVOKE StringLength, string
	MOV ECX, EAX

	MOV ESI, string
	MOV EDI,  OFFSET tokenizerBuffer
	REP MOVSB


	MOV currentI, 0
	POP EAX
	POP ECX
	POP EDI
	POP ESI
	RET
InitializeTokenizer ENDP

;---------------------------------------------
TokenizerNextToken PROC USES ESI EDI ECX EAX EBX
;Finds the next token in the tokenizer
;---------------------------------------------	
	MOV ECX, BUFFERSIZE
	MOV EDI, OFFSET tokenBuffer
	MOV ESI, OFFSET emptyBuffer
	REP MOVSB
	
	INVOKE StringLength, OFFSET tokenizerBuffer
	
	MOV EBX, 0
	MOV BL, delim
	
	MOV ESI, OFFSET tokenizerBuffer
	MOV EDI, OFFSET tokenBuffer
	
	ADD ESI, currentI
	MOV ECX, EAX

L1:
	CMP [ESI], BL
	JE done
	CMP [ESI], BH
	JE nothingtodo
	MOVSB
	INC currentI
	LOOP L1
done:
	INC currentI
nothingtodo:
	RET
TokenizerNextToken ENDP


;-----------------------------------------------
EmptyTokenizer PROC USES ECX ESI EDI
;Empties the tokenizer
;-----------------------------------------------
	MOV ECX, BUFFERSIZE
	MOV EDI, OFFSET tokenizerBuffer
	MOV ESI, OFFSET emptyBuffer
	REP MOVSB
	RET
EmptyTokenizer ENDP


;-------------------------------------------------
GetToken PROC
;Returns the next token in EDX
;------------------------------------------------
	MOV EDX, OFFSET tokenBuffer
	RET
GetToken ENDP

;----------------------------------
TokenizerSetDelimeter PROC,
	newDelim:BYTE
;Sets the delimeter of the tokenizer
;------------------------------------
	
	MOVZX EAX, newDelim
	MOV delim, AL
	RET
TokenizerSetDelimeter ENDP

;=========================================================
;This procedure was copied from Kip Irvine's Irvine32
;library. It is not oficially part of the Console32 
;library. It is only here to eliminate dependencies.
;=========================================================
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


END Name1