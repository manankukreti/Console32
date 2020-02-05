# Console32

### About Console32
Microsoft Assembly Library for x86 Processors based on Kip Irvine's Irvine32 Library

### Downloading and Installing Console32
Download the Console32 Installer.exe file and run it.
You can also download the repository as a ZIP file and unzip the files to a file such as ``` C:/Console32```, but that's a little harder.

### Using Console32
In Visual Studio, after setting up yout project, go into properties and:

Choose Linker -> General, Add C:/Console to Additional Library Directories. 
Choose Linker -> Input, click the down arrow and add console32.lib to the top box.
Choose Linker -> System, click the down arrow and select Console from the Subsystem menu.
Choose Microsoft Macro Assembler -> General and add C:/Console32 to Include Paths.

In your assembly source file (.asm), place the line
```INCLUDE Console32.lib``` before your .data directive.

### Procedre Use
You can use the procedures using the INVOKE directive.

## List of Procedure Prototypes
```
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

```
