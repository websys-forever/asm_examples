%include 'functions.asm'

section .data
filename db 'readme.txt', 0h
contents db 'Content was written!', 0Ah, 0h

section .text
global _start

_start:
    mov  ecx, 0777o
    mov  ebx, filename
    mov  eax, 8
    int  80h

    mov  edx, 21
    mov  ecx, contents
    mov  ebx, eax
    mov  eax, 4         ; invoke SYS_WRITE (kernel opcode 4)
    int  80h

    call quit