.MODEL FLAT, STDCALL
.STACK

Substring PROTO,
	string:PTR BYTE,
	index:DWORD

SubstringFromTo PROTO,
	string:PTR BYTE,
	from:DWORD,
	to:DWORD

CharacterAt PROTO,
	string:PTR BYTE,
	index:DWORD

IndexOf PROTO,
	string:PTR BYTE,
	char:BYTE

LastIndexOf PROTO,
	string:PTR BYTE,
	char:BYTE

NthIndexOf PROTO,
	string:PTR BYTE,
	char:BYTE,
	n:DWORD

StringBuilderInsertAt PROTO,
	string:PTR BYTE,
	index:DWORD

StringBuilderDelete PROTO,
	start:DWORD, 
	endI:DWORD
	
StringBuilderAppend PROTO, 
	string:PTR BYTE

StringBuilderDeleteCharAt PROTO, 
	index:DWORD

StringBuilderReverse PROTO

GetStringBuilder PROTO

EmptyStringBuilder PROTO


InitializeTokenizer PROTO,
	string:PTR BYTE

TokenizerSetDelimeter PROTO,
	newDelim:BYTE

TokenizerNextToken PROTO

EmptyTokenizer PROTO

GetToken PROTO

StringLength PROTO,
	pString:PTR BYTE