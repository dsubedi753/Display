; Clock Code by D2

; Declaration of variables
plcONE EQU 0030h
plcTEN EQU 0031h
plcHUN EQU 0032h
plcTHS EQU 0033h
plcQQQ EQU 0040h

ORG 0000h
AJMP INIT

; Interrupts
ORG 0003h
AJMP ISRIE0

ORG 000Bh
AJMP ISRTF0

ORG 0100h
INIT:
	;Initializing all digits
	MOV plcONE, #00h
	MOV plcTEN, #10h
	MOV plcHUN, #20h
	MOV plcTHS, #30h
	;Setting up the pointers
	MOV R0, #plcONE
	MOV R2, #0000h
	;Setting up the timer and interrupt
	MOV TMOD, #11h ;Set Timers to be 2 8-bits
	SETB IT0	;Set external interrupt 0 to be edge triggered
	SETB IT1	;Set external interrupt 1 to be edge triggered
	MOV TH0, #0ECh 	
	MOV TL0, #081h
	SETB EA		;Activate Global Interrupt
	SETB ET0	;Activate Timer0 Interrupt
	SETB EX0	;Activate External Interrupt0
	SETB TR0	;Start running the timer0
	SETB TR1	;Start running the timer1
	AJMP WAIT

ORG 0150h
; Will Wait here
WAIT:
	JMP $
	
; Timer0 interrrupt ISR
ORG 0155h
ISRTF0: 
	CLR EA	
	; Reset clock
	MOV TH0, #0ECh 	
	MOV TL0, #081h
	;Call for Display
	ACALL DISPLAY
	SETB EA
	RETI

ORG 0250h
ISRIE0:
	ACALL UPDATE
	RETI

ORG 0500h
DISPLAY:
	MOV P1, @R0
	INC R0
	CJNE R0, #0034h, ENDDISP
	MOV R0, #plcONE
ENDDISP:
	RET

ORG 0550h
; Update the digits
UPDATE:
	MOV A, TL1
	MOV B, #0Ah
	DIV AB
	MOV plcONE, B
	MOV B, #0Ah
	DIV AB
	MOV A, B
	ADD A, #10h
	MOV plcTEN, A

	MOV A, TH1
	MOV B, #0Ah
	DIV AB
	MOV plcQQQ, A
	MOV A, B
	ADD A, #20h
	MOV plcHUN, A
	MOV A, plcQQQ
	MOV B, #0Ah
	DIV AB
	MOV A, B
	ADD A, #30h
	MOV plcTHS, A
RET

END


