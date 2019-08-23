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

NUM			.equ	2019          			; num a ser convertido  2019 = 0x07E3

			mov 	#NUM, R5				; R5 = num a ser convertido
			mov 	#0x2400, R6				; R6 = ponteiro pra escrever resposta
			call 	#ALG_ROM				; chama subrotina
			jmp 	$						; trava execucao
			nop

;-------------------------------------------------------------------------------
; Guia- Numerais Romanos em ASCII
;
;
;-------------------------------------------------------------------------------

ALG_ROM:
			CMP		#0x0BB8, R5				; compara input com 3000
			IEQ		designa_MMM				; se a condição é satisfeita, chama subrotina
			JHS		designa_MMM
											; para o numero menor do que 3000, continua

			CMP		#0x07D0, R5				; compara input com 2000
			IEQ		designa_MM				; se a condição é satisfeita, chama subrotina
			JHS		designa_MM
											; para o numero menor do que 2000, continua

			CMP		#0x03E8, R5				; compara input com 1000
			IEQ		designa_M				; se a condição é satisfeita, chama subrotina
			JHS		designa_M
											; para o numero menor do que 1000, não ha o que ser convertido em relação aos milhares
			JMP		tratar_centenas			; vamos incondicionalmente para a etapa seguinte do algoritmo, sem executar operações

designa_MMM:

			MOV		#0x004D, @R6			; colocamos MMM na resposta, levando o ponteiro sempre a diante
			INC		R6
			MOV		#0x004D, @R6
			INC		R6
			MOV		#0x004D, @R6
			INC		R6

			SUB		#0x0BB8, R5				; subtraimos o que ja foi convertido do numero atual

			JMP		tratar_centenas			; vamos incondicionalmente para a etapa seguinte do algoritmo

designa_MM:

			MOV		#0x004D, @R6			; colocamos MM na resposta, levando o ponteiro sempre a diante
			INC		R6
			MOV		#0x004D, @R6
			INC		R6

			SUB		#0x07D0, R5				; subtraimos o que ja foi convertido do numero atual
			JMP		tratar_centenas			; vamos incondicionalmente para a etapa seguinte do algoritmo

designa_M:

			MOV		#0x03E8, @R6			; colocamos M na resposta, levando o ponteiro sempre a diante
			INC		R6

			SUB		#0x03E8, R5				; subtraimos o que ja foi convertido do numero atual
			JMP		tratar_centenas			; vamos incondicionalmente para a etapa seguinte do algoritmo

tratar_centenas:

			CMP		#0x01F4, R5				; comparamos com 500 e dividimos o problema em 2 grupos, numeros maiores e menores que 500
			IEQ		designa_D				; se igual a 500, designa 500
			JHS		maior_500				; se maior que 500, chamamos nova subrotina
			JL		menor_500				; se menor que 500, chamamos outra nova subrotina

maior_500:

			CMP		#0x0258, R5				; compara com 600
			IEQ		designa_DC				; se igual, designa 600
			JL		designa_D				; se menor que 600 e maior que 500, designa 500

			CMP		#0x02BC, R5				; compara com 700
			IEQ		designa_DCC				; se igual, designa 700
			JL		designa_DC				; se menor que 700 e maior que 600, designa 600

			CMP		#0x0320, R5				; compara com 800
			IEQ		designa_DCCC			; se igual, designa 800
			JL		designa_DCC				; se menor que 800 e maior que 700, designa 700

			CMP		#0x0384, R5				; compara com 900
			IEQ		designa_CM				; se igual, designa 900
			JHS		designa_CM				; se maior que 900, designa 900 por sabermos que o numero já é menor que 1000
			JL		designa_DCCC			; se menor que 900 e maior que 800, designa 800

			JMP		tratar_dezenas			; salto incondicional para nova parte do algoritmo

menor_500:



			JMP		tratar_dezenas			; salto incondicional para nova parte do algoritmo



designa_D:									; 500

			JMP		tratar_dezenas			; salto incondicional para nova parte do algoritmo

designa_DC:									; 600

			JMP		tratar_dezenas			; salto incondicional para nova parte do algoritmo

designa_DCC:								; 700

			JMP		tratar_dezenas			; salto incondicional para nova parte do algoritmo

designa_DCCC:								; 800

			JMP		tratar_dezenas			; salto incondicional para nova parte do algoritmo

designa_CM:									; 900

			JMP		tratar_dezenas			; salto incondicional para nova parte do algoritmo



tratar_dezenas:


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
            
