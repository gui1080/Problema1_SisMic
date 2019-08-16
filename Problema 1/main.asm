;-------------------------------------------------------------------------------
; Aluno: Guilherme Braga Pinto
; 17/0162290
; LabSismic Turma D
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
NUM			.equ	2019          ; num a ser convertido

			mov 	#NUM, R5	; R5 = num a ser convertido
			mov 	#0x2400, R6	; R6 = ponteiro pra escrever resposta
			call 	#ALG_ROM	; chama subrotina
			jmp 	$			; trava execucao
			nop

ALG_ROM:



			.data

; RESP = 0x2400

RESP:		.byte	"RRRRRRRRRRRRRRRR", 0
                                            

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
