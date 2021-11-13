%include 'functions.asm'

section .data
filename db 'readme.txt', 0h

section .text
global _start

_start:
    mov  ecx, 0777o
    mov  ebx, filename
    mov  eax, 8
    int  80h

    call quit