%include 'functions.asm'

section .bss
buffer resb 255,

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

_listen:

    push    byte 1              ; move 1 onto stack (max queue length argument)
    push    edi                 ; push the file descriptor onto stack
    mov     ecx, esp            ; move address of arguments into ecx
    mov     ebx, 4              ; invoke subroutine LISTEN (4)
    mov     eax, 102            ; invoke SYS_SOCKETCALL (kernel opcode 102)
    int     80h                 ; call the kernel

_accept:

    push    byte 0              ; push 0 dec onto stack (address length argument)
    push    byte 0              ; push 0 dec onto stack (address argument)
    push    edi                 ; push the file descriptor onto stack
    mov     ecx, esp            ; move address of arguments into ecx
    mov     ebx, 5              ; invoke subroutine ACCEPT (5)
    mov     eax, 102            ; invoke SYS_SOCKETCALL (kernel opcode 102)
    int     80h                 ; call the kernel

_fork:

    mov     esi, eax            ; move return value of SYS_SOCKETCALL into esi (file descriptor for accepted socket, or -1 on error)
    mov     eax, 2              ; invoke SYS_FORK (kernel opcode 2)
    int     80h                 ; call the kernel

    cmp     eax, 0              ; if return value of SYS_FORK in eax is zero we are in the child process
    jz      _read               ; jmp in child process to _read

    jmp     _accept             ; jmp in parent process to _accept

_read:

    mov     edx, 255            ; number of bytes to read (we will only read the first 255 bytes for simplicity)
    mov     ecx, buffer         ; move the memory address of our buffer variable into ecx
    mov     ebx, esi            ; move esi into ebx (accepted socket file descriptor)
    mov     eax, 3              ; invoke SYS_READ (kernel opcode 3)
    int     80h                 ; call the kernel

    mov     eax, buffer         ; move the memory address of our buffer variable into eax for printing
    call    sprintLF            ; call our string printing function

_exit:
    call quit