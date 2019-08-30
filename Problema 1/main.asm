;-------------------------------------------------------------------------------
; Aluno: Guilherme Braga Pinto (17/0162290) e Gabriel Matheus (17/0103498)
; LabSismic Turma D
; Link no Github: https://github.com/therealguib545/Problema1_SisMic
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

NUM			.equ	3518          			; num a ser convertido  2019 = 0x07E3

			mov 	#NUM, R5				; R5 = num a ser convertido
			mov 	#RESP, R6				; R6 = ponteiro pra escrever resposta
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
			JEQ		designa_MMM				; se a condição é satisfeita, chama subrotina
			JHS		designa_MMM
											; para o numero menor do que 3000, continua

			CMP		#0x07D0, R5				; compara input com 2000
			JEQ		designa_MM				; se a condição é satisfeita, chama subrotina
			JHS		designa_MM
											; para o numero menor do que 2000, continua

			CMP		#0x03E8, R5				; compara input com 1000
			JEQ		designa_M				; se a condição é satisfeita, chama subrotina
			JHS		designa_M
											; para o numero menor do que 1000, não ha o que ser convertido em relação aos milhares
			JMP		tratar_centenas			; vamos incondicionalmente para a etapa seguinte do algoritmo, sem executar operações

designa_MMM:

			MOV		#0x004D, 0(R6)			; colocamos MMM na resposta, levando o ponteiro sempre a diante
			MOV		#0x004D, 2(R6)
			MOV		#0x004D, 4(R6)
			ADD		#6, R6

			SUB		#0x0BB8, R5				; subtraimos o que ja foi convertido do numero atual

			JMP		tratar_centenas			; vamos incondicionalmente para a etapa seguinte do algoritmo

designa_MM:

			MOV		#0x004D, 0(R6)			; colocamos MM na resposta, levando o ponteiro sempre a diante
			MOV		#0x004D, 2(R6)
			ADD		#4, R6

			SUB		#0x07D0, R5				; subtraimos o que ja foi convertido do numero atual
			JMP		tratar_centenas			; vamos incondicionalmente para a etapa seguinte do algoritmo

designa_M:

			MOV		#0x004D, 0(R6)			; colocamos M na resposta, levando o ponteiro sempre a diante
			ADD		#2, R6

			SUB		#0x03E8, R5				; subtraimos o que ja foi convertido do numero atual
			JMP		tratar_centenas			; vamos incondicionalmente para a etapa seguinte do algoritmo

;-------------------------------------------------------------------------------

tratar_centenas:

			CMP		#0x01F4, R5				; comparamos com 500 e dividimos o problema em 2 grupos, numeros maiores e menores que 500
			JEQ		designa_D				; se igual a 500, atribuimos 500
			JHS		maior_500				; se maior que 500, chamamos nova subrotina
			JL		menor_500				; se menor que 500, chamamos outra nova subrotina

maior_500:

			CMP		#0x0258, R5				; compara com 600
			JEQ		designa_DC				; se igual, atribuimos 600
			JL		designa_D				; se menor que 600 e maior que 500, atribuimos 500

			CMP		#0x02BC, R5				; compara com 700
			JEQ		designa_DCC				; se igual, atribuimos 700
			JL		designa_DC				; se menor que 700 e maior que 600, atribuimos 600

			CMP		#0x0320, R5				; compara com 800
			JEQ		designa_DCCC			; se igual, atribuimos 800
			JL		designa_DCC				; se menor que 800 e maior que 700, atribuimos 700

			CMP		#0x0384, R5				; compara com 900
			JEQ		designa_CM				; se igual, atribuimos 900
			JHS		designa_CM				; se maior que 900, atribuimos 900 por sabermos que o numero já é menor que 1000
			JL		designa_DCCC			; se menor que 900 e maior que 800, atribuimos 800

											; se nenhuma condição foi satisfeita, logo não há centenas a serem convertidas
			JMP		tratar_dezenas			; salto incondicional para nova parte do algoritmo

menor_500:

			CMP 	#0x0190, R5				; compara com 400
			JEQ		designa_CD				; se igual, atribuimos 400
			JHS		designa_CD				; se maior que 400 e menor que 500, atribuimos 400
											; continuamos se o numero é menor que 400

			CMP		#0x012C, R5				; compara com 300
			JEQ		designa_CCC				; se igual, atribuimos 300
			JHS		designa_CCC				; se maior que 300 e menor que 400, atribuimos 300
											; continuamos se o numero é menor que 300

			CMP		#0x00C8, R5				; compara com 200
			JEQ		designa_CC				; se igual, atribuimos 200
			JHS		designa_CC				; se maior que 200 e menor que 300, atribuimos 200

			CMP 	#0x0064, R5				; compara com 100
			JEQ		designa_C				; se igual, atribuimos 100
			JHS		designa_C				; se maior que 100 e menor que 200, atribuimos 100

											; se nenhuma condição foi satisfeita, logo não há centenas a serem convertidas
			JMP 	tratar_dezenas			; salto incondicional para nova parte do algoritmo


designa_C:									; 100

			MOV		#0x0043, 0(R6)			; colocamos C na resposta, levando o ponteiro sempre a diante
			ADD		#2, R6

			SUB		#0x0064, R5				; subtraimos o que ja foi convertido do numero atual (100)

			JMP		tratar_dezenas			; salto incondicional para nova parte do algoritmo

designa_CC:									; 200

			MOV		#0x0043, 0(R6)			; colocamos CC na resposta, levando o ponteiro sempre a diante
			MOV		#0x0043, 2(R6)
			ADD		#4, R6

			SUB		#0x00C8, R5				; subtraimos o que ja foi convertido do numero atual (200)

			JMP		tratar_dezenas			; salto incondicional para nova parte do algoritmo

designa_CCC:								; 300

			MOV		#0x0043, 0(R6)				; colocamos CCC na resposta, levando o ponteiro sempre a diante
			MOV		#0x0043, 2(R6)
			MOV		#0x0043, 4(R6)
			ADD		#6, R6

			SUB		#0x012C, R5				; subtraimos o que ja foi convertido do numero atual (300)

			JMP		tratar_dezenas			; salto incondicional para nova parte do algoritmo

designa_CD:									; 400

			MOV		#0x0043, 0(R6)			; colocamos CD na resposta, levando o ponteiro sempre a diante
			MOV		#0x0044, 2(R6)
			ADD		#4, R6

			SUB		#0x0190, R5				; subtraimos o que ja foi convertido do numero atual (400)

			JMP		tratar_dezenas			; salto incondicional para nova parte do algoritmo

designa_D:									; 500

			MOV		#0x0044, 0(R6)			; colocamos D na resposta, levando o ponteiro sempre a diante
			ADD		#2, R6

			SUB		#0x01F4, R5				; subtraimos o que ja foi convertido do numero atual (500)

			JMP		tratar_dezenas			; salto incondicional para nova parte do algoritmo

designa_DC:									; 600

			MOV		#0x0044, 0(R6)			; colocamos DC na resposta, levando o ponteiro sempre a diante
			MOV		#0x0043, 2(R6)
			ADD		#4, R6

			SUB		#0x0258, R5				; subtraimos o que ja foi convertido do numero atual (600)

			JMP		tratar_dezenas			; salto incondicional para nova parte do algoritmo

designa_DCC:								; 700

			MOV		#0x0044, 0(R6)			; colocamos DCC na resposta, levando o ponteiro sempre a diante
			MOV		#0x0043, 2(R6)
			MOV		#0x0043, 4(R6)
			ADD		#6, R6

			SUB		#0x02BC, R5				; subtraimos o que ja foi convertido do numero atual (700)

			JMP		tratar_dezenas			; salto incondicional para nova parte do algoritmo

designa_DCCC:								; 800

			MOV		#0x0044, 0(R6)			; colocamos DCC na resposta, levando o ponteiro sempre a diante
			MOV		#0x0043, 2(R6)
			MOV		#0x0043, 4(R6)
			MOV		#0x0043, 6(R6)
			ADD		#8, R6

			SUB		#0x0320, R5				; subtraimos o que ja foi convertido do numero atual (800)

			JMP		tratar_dezenas			; salto incondicional para nova parte do algoritmo

designa_CM:									; 900

			MOV		#0x0043, 0(R6)				; colocamos CM na resposta, levando o ponteiro sempre a diante
			MOV		#0x004D, 2(R6)
			ADD		#4, R6

			SUB		#0x0384, R5				; subtraimos o que ja foi convertido do numero atual (900)

			JMP		tratar_dezenas			; salto incondicional para nova parte do algoritmo

;-------------------------------------------------------------------------------

tratar_dezenas:

			CMP		#0x01F4, R5				; comparamos com 50 e dividimos o problema em 2 grupos, numeros maiores e menores que 50
			JEQ		designa_L				; se igual a 50, atribuimos 50
			JHS		maior_50				; se maior que 50, chamamos nova subrotina
			JL		menor_50				; se menor que 50, chamamos outra nova subrotina

menor_50:

			CMP 	#0x0028, R5				; compara com 40
			JEQ		designa_XL				; se igual, atribuimos 40
			JHS		designa_XL				; se maior que 40 e menor que 50, atribuimos 40
											; continuamos se o numero é menor que 40

			CMP		#0x001E, R5				; compara com 30
			JEQ		designa_XXX				; se igual, atribuimos 30
			JHS		designa_XXX				; se maior que 300 e menor que 40, atribuimos 30
											; continuamos se o numero é menor que 30

			CMP		#0x0014, R5				; compara com 20
			JEQ		designa_XX				; se igual, atribuimos 20
			JHS		designa_XX				; se maior que 20 e menor que 30, atribuimos 20

			CMP 	#0x000A, R5				; compara com 10
			JEQ		designa_X				; se igual, atribuimos 10
			JHS		designa_X				; se maior que 100 e menor que 20, atribuimos 10

											; se nenhuma condição foi satisfeita, logo não há dezenas a serem convertidas
			JMP 	tratar_unidades			; salto incondicional para nova parte do algoritmo

maior_50:

			CMP		#0x0258, R5				; compara com 60
			JEQ		designa_LX				; se igual, atribuimos 60
			JL		designa_L				; se menor que 600 e maior que 50, atribuimos 50

			CMP		#0x02BC, R5				; compara com 70
			JEQ		designa_LXX				; se igual, atribuimos 70
			JL		designa_LX				; se menor que 70 e maior que 60, atribuimos 60

			CMP		#0x0320, R5				; compara com 80
			JEQ		designa_LXXX			; se igual, atribuimos 80
			JL		designa_LXX				; se menor que 80 e maior que 70, atribuimos 70

			CMP		#0x0384, R5				; compara com 90
			JEQ		designa_XC				; se igual, atribuimos 90
			JHS		designa_XC				; se maior que 90, atribuimos 90 por sabermos que o numero já é menor que 100
			JL		designa_LXXX			; se menor que 90 e maior que 80, atribuimos 80

											; se nenhuma condição foi satisfeita, logo não há centenas a serem convertidas
			JMP		tratar_dezenas			; salto incondicional para nova parte do algoritmo


designa_X:

			MOV		#0x0058, 0(R6)			; colocamos X na resposta, levando o ponteiro sempre a diante
			ADD		#2, R6

			SUB		#0x000A, R5				; subtraimos o que ja foi convertido do numero atual (10)


			JMP		tratar_unidades

designa_XX:

			MOV		#0x0058, 0(R6)			; colocamos XX na resposta, levando o ponteiro sempre a diante
			MOV		#0x0058, 2(R6)
			ADD		#4, R6

			SUB		#0x0014, R5				; subtraimos o que ja foi convertido do numero atual (20)

			JMP		tratar_unidades

designa_XXX:

			MOV		#0x0058, 0(R6)			; colocamos XXX na resposta, levando o ponteiro sempre a diante
			MOV		#0x0058, 2(R6)
			MOV		#0x0058, 4(R6)
			ADD		#6, R6

			SUB		#0x001E, R5				; subtraimos o que ja foi convertido do numero atual (30)

			JMP		tratar_unidades

designa_XL:

			MOV		#0x0058, 0(R6)			; colocamos XL na resposta, levando o ponteiro sempre a diante
			MOV		#0x004C, 2(R6)
			ADD		#4, R6

			SUB		#0x0028, R5				; subtraimos o que ja foi convertido do numero atual (40)

			JMP		tratar_unidades

designa_L:

			MOV		#0x004C, 0(R6)			; colocamos L na resposta, levando o ponteiro sempre a diante
			ADD		#2, R6

			SUB		#0x0032, R5				; subtraimos o que ja foi convertido do numero atual (50)

			JMP		tratar_unidades

designa_LX:

			MOV		#0x004C, 0(R6)			; colocamos LX na resposta, levando o ponteiro sempre a diante
			MOV		#0x0058, 2(R6)
			ADD		#4, R6

			SUB		#0x003C, R5				; subtraimos o que ja foi convertido do numero atual (60)


			JMP		tratar_unidades

designa_LXX:

			MOV		#0x004C, 0(R6)			; colocamos LXX na resposta, levando o ponteiro sempre a diante
			MOV		#0x0058, 2(R6)
			MOV		#0x0058, 4(R6)
			ADD		#6, R6

			SUB		#0x0046, R5				; subtraimos o que ja foi convertido do numero atual (70)

			JMP		tratar_unidades

designa_LXXX:

			MOV		#0x004C, 0(R6)			; colocamos LXXX na resposta, levando o ponteiro sempre a diante
			MOV		#0x0058, 2(R6)
			MOV		#0x0058, 4(R6)
			MOV		#0x0058, 6(R6)
			ADD		#8, R6

			SUB		#0x0050, R5				; subtraimos o que ja foi convertido do numero atual (80)

			JMP		tratar_unidades

designa_XC:

			MOV		#0x0058, 0(R6)			; colocamos LX na resposta, levando o ponteiro sempre a diante
			MOV		#0x0043, 2(R6)
			ADD		#4, R6

			SUB		#0x003C, R5				; subtraimos o que ja foi convertido do numero atual (90)

			JMP		tratar_unidades

;-------------------------------------------------------------------------------

tratar_unidades:


			CMP		#0x0009, R5				; Comparamos com 9 e terminamos o algoritmo
			JEQ		designa_IX

			CMP		#0x0008, R5				; Comparamos com 8 e terminamos o algoritmo
			JEQ		designa_VIII

			CMP		#0x0007, R5				; Comparamos com 7 e terminamos o algoritmo
			JEQ		designa_VII

			CMP		#0x0006, R5				; Comparamos com 6 e terminamos o algoritmo
			JEQ		designa_VI

			CMP		#0x0005, R5				; Comparamos com 5 e terminamos o algoritmo
			JEQ		designa_V

			CMP		#0x0004, R5				; Comparamos com 4 e terminamos o algoritmo
			JEQ		designa_IV

			CMP		#0x0003, R5				; Comparamos com 3 e terminamos o algoritmo
			JEQ		designa_III

			CMP		#0x0002, R5				; Comparamos com 2 e terminamos o algoritmo
			JEQ		designa_II

			CMP		#0x0001, R5				; Comparamos com 1 e terminamos o algoritmo
			JEQ		designa_I

			CMP		#0x0000, R5				; Comparamos com 0 e terminamos o algoritmo
			JEQ		designa_fim


designa_IX:

			MOV		#0x0049, 0(R6)			; atribuimos XI na resposta
			MOV		#0x0058, 2(R6)
			ADD		#4, R6

			SUB		#0x0009, R5				; subtraimos o que ja foi convertido do numero atual (9)


			JMP 	designa_fim

designa_VIII:

			MOV		#0x0056, 0(R6)			; atribuimos VIII na resposta
			MOV		#0x0049, 2(R6)
			MOV		#0x0049, 4(R6)
			MOV		#0x0049, 6(R6)
			ADD		#8, R6

			SUB		#0x0008, R5				; subtraimos o que ja foi convertido do numero atual (8)

			JMP 	designa_fim

designa_VII:

			MOV		#0x0056, 0(R6)			; atribuimos VII na resposta
			MOV		#0x0049, 2(R6)
			MOV		#0x0049, 4(R6)
			ADD		#6, R6

			SUB		#0x0007, R5				; subtraimos o que ja foi convertido do numero atual (7)

			JMP 	designa_fim

designa_VI:

			MOV		#0x0056, 0(R6)			; atribuimos VI na resposta
			MOV		#0x0049, 2(R6)
			ADD		#4, R6

			SUB		#0x0006, R5				; subtraimos o que ja foi convertido do numero atual (6)

			JMP 	designa_fim

designa_V:

			MOV		#0x0056, 0(R6)			; atribuimos V na resposta
			ADD		#2, R6

			SUB		#0x0005, R5				; subtraimos o que ja foi convertido do numero atual (5)

			JMP 	designa_fim

designa_IV:

			MOV		#0x0049, 0(R6)			; atribuimos IV na resposta
			MOV		#0x0056, 2(R6)
			ADD		#4, R6

			SUB		#0x0004, R5				; subtraimos o que ja foi convertido do numero atual (4)

			JMP 	designa_fim

designa_III:

			MOV		#0x0049, 0(R6)			; atribuimos III na resposta
			MOV		#0x0049, 2(R6)
			MOV		#0x0049, 4(R6)
			ADD		#6, R6

			SUB		#0x0003, R5				; subtraimos o que ja foi convertido do numero atual (3)

			JMP 	designa_fim

designa_II:

			MOV		#0x0049, 0(R6)			; atribuimos II na resposta
			MOV		#0x0049, 2(R6)
			ADD		#4, R6

			SUB		#0x0002, R5				; subtraimos o que ja foi convertido do numero atual (2)

			JMP 	designa_fim

designa_I:

			MOV		#0x0049, 0(R6)			; atribuimos I na resposta
			ADD		#2, R6

			SUB		#0x0001, R5				; subtraimos o que ja foi convertido do numero atual (1)

			JMP 	designa_fim

designa_fim:

			MOV		#0x0000, 0(R6)			; final da respota
			ret								; retornamos da função

;-------------------------------------------------------------------------------

			.data

; RESP = 0x2000

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
            
