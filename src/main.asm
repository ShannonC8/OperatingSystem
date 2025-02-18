;if you change this value won't make bios load as diff addy, tells assembler that should be 
;calc with offset 7c00
org 0x7C00 ;tells assembler where expect code to be loaded. Uses info to calc label addy
bits 16 ; tels assembler to emit 16/32/64-bit code. Always starts in 16 bit code, assembler emit 32 bit code
%define ENDL 0x0D, 0x0A
; Directive: give clue to assembler that will affect how prog compiler. Not translate to machine code
; Instruction: transted to a machine code instruction that CPU execute

start:
    jmp main

;prints a string to the screen
puts:
    ;saves registers we will modify
    push si
    push ax
    push bx

.loop:
    lodsb ; Load next character from [SI] into AL
    or al, al ; verify if next char is null
    jz .done ; jump zero
    
    mov ah, 0x0e ; BIOS teletype output function
    mov bh, 0   ; Page number (always 0)
    int 0x10 ; BIOS interrupt to print character in AL
    jmp .loop
    

.done:
    pop bx ; store popped item in bx (og bx)
    pop ax
    pop si
    ret

main:
    ; setup data segmentsi
    ; The segment registers (DS, ES) define memory regions for data access.
    ; Cannot modify DS or ES directly; load the value into AX first, then copy it to DS/ES.
    ; all memory addresses in our code will be relative to 0x0000:7C00.

    mov ax, 0 ; can't write to ds/es directly
    mov ds, ax
    mov es, ax
    
    ;setup stack
    mov ss, ax
    mov sp, 0x7C00 ; we need this at bottom of program start since it expands downward (no overwrite prog)

    mov si, msg_hello
    call puts

    hlt

.halt: ;halts processor
    jmp .halt
    
msg_hello: db "Hello world", ENDL, 0
    
;Bios needs signature where last two byets of first sector are AA55
; tells nasm by using DB (declare constant byte)
;flows up to 510 bytes
;$-$$ gives size of program so far in bytes
times 510-($-$$) db 0
;declare signature which is required for the os
dw 0AA55h

