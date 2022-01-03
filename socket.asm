%include 'functions.asm'

section .text
global _start

_start:
    xor eax, eax ; init 0
    xor ebx, ebx
    xor edi, edi
    xor esi, esi

_socket:
    push byte 6   ; IPPROTO_TCP
    push byte 1   ; SOCKET_STREAM
    push byte 2   ; PF_INET
    mov  ecx, esp ; move address of arguments into ecx
    mov  ebx, 1   ; invoke subroutine SOCKET (1)
    mov  eax, 102 ; invoke SYS_SOCKETCALL (kernel opcode 102)
    int  80h

    call iprintLF ; call our integer printing function (print the file descriptor in EAX or -1 on error)

_bind:

    mov     edi, eax            ; move return value of SYS_SOCKETCALL into edi (file descriptor for new socket, or -1 on error)
    push    dword 0x00000000    ; push 0 dec onto the stack IP ADDRESS (0.0.0.0)
    push    word 0x2923         ; push 9001 dec onto stack PORT (reverse byte order)
    push    word 2              ; push 2 dec onto stack AF_INET
    mov     ecx, esp            ; move address of stack pointer into ecx
    push    byte 16             ; push 16 dec onto stack (arguments length)
    push    ecx                 ; push the address of arguments onto stack
    push    edi                 ; push the file descriptor onto stack
    mov     ecx, esp            ; move address of arguments into ecx
    mov     ebx, 2              ; invoke subroutine BIND (2)
    mov     eax, 102            ; invoke SYS_SOCKETCALL (kernel opcode 102)
    int     80h                 ; call the kernel

_exit:
    call quit