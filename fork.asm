%include 'functions.asm'

section .data
childMsg   db 'This is the child process', 0h
parentMsg  db 'This is the parent process', 0h

section .text
global  _start

_start:
    mov  eax, 2 ; invoke SYS_FORK (kernel opcode 2)
    int  80h

    cmp  eax, 0
    jz   child

parent:
    mov  eax, parentMsg
    call sprintLF

    call quit

child:
    mov  eax, childMsg
    call sprintLF

    call quit
