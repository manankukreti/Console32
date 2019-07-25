@ECHO OFF
cls

REM Assemble the source code.
ML -c -coff Console32.asm
if errorlevel 1 goto terminate

LIB /SUBSYSTEM:CONSOLE Console32.obj
if errorlevel 1 goto terminate

:terminate
pause