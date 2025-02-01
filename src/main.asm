;if you change this value won't make bios load as diff addy, tells assembler that should be 
;calc with offset 7c00
org 0x7C00 ;tells assembler where expect code to be loaded. Uses info to calc label addy
bits 16 ; tels assembler to emit 16/32/64-bit code. Always starts in 16 bit code, assembler emit 32 bit code

; Directive: give clue to assembler that will affect how prog compiler. Not translate to machine code
; Instruction: transted to a machine code instruction that CPU execute

main:
    hlt

.halt: ;halts processor
    jmp .halt

;Bios needs signature where last two byets of first sector are AA55
; tells nasm by using DB (declare constant byte)
;flows up to 510 bytes
;$-$$ gives size of program so far in bytes
times 510-($-$$) db 0
;declaresignature
dw 0AA55h

