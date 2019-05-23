# Console32

### About Console32
Microsoft Assembly Library for x86 Processors based on Kip Irvine's Irvine32 Library

### Downloading and Installing Console32
Simply download the repository as a ZIP file.

To install, unzip the files to a file such as ``` C:/Console32```

### Using Console32
In Visual Studio, after setting up yout project, go into properties, choose Linker -> General
Add C:/Console to Additional Library Directories. Choose Linker -> Input, click the down arrow 
and add console32.lib to the top box. Choose Microsoft Macro Assembler -> General and add
C:/Console32 to Include Paths.

In your assembly source file (.asm), place the line
```INCLUDE Console32.lib``` before your .data directive.

### Procedre Use
You can use the procedures using the INVOKE directive.

##List of Procedure Prototypes
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

```
