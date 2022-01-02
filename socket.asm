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

_exit:
    call quit