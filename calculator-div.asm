%include 'functions.asm'

section .data
msg1    db  ' remainder '

section .text
global _start

_start:
    mov  eax, 90
    mov  ebx, 9
    div  ebx
    call iprint
    mov  eax, msg1
    call sprint
    mov  eax, edx
    call iprintLF

    call quit