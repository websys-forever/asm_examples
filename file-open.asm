%include 'functions.asm'

section .data
filename db "readme.txt", 0h
contents db "This is file's content", 0h

section .text
global _start

_start:
    mov  ecx, 0777o
    mov  ebx, filename
    mov  eax, 8
    int  80h

    mov  edx, 22
    mov  ecx, contents
    mov  ebx, eax
    mov  eax, 4
    int  80h

    mov  ecx, 0
    mov  ebx, filename
    mov  eax, 5
    int  80h

    call iprintLF
    call quit