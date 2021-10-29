section .data
msg    db   "Hello", 0Ah

section .text
global  _start

_start:
    mov ebx, msg
    mov eax, ebx

nextchar:
    cmp byte [eax], 0
    jz  finished
    inc eax
    jmp nextchar

finished:
    sub eax, ebx

    mov edx, eax
    mov ecx, msg
    mov ebx, 1
    mov eax, 4
    int 80h

    mov ebx, 0
    mov eax, 1
    int 80h
