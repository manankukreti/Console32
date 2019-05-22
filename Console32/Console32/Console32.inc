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

StringLength PROTO,
	pString:PTR BYTE