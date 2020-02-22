; Clock Code by D2

; Declaration of variables
secONE EQU 0030h
secTEN EQU 0031h
minONE EQU 0032h
minTEN EQU 0033h

tmsONE EQU 0040h
tmsTEN EQU 0041h
tseONE EQU 0042h
tseTEN EQU 0043h

ORG 0000h
AJMP INIT

; Interrupts
ORG 0003h
AJMP ISRIE0

ORG 000Bh
AJMP ISRTF0

ORG 0013h
AJMP ISRIE1

ORG 001Bh
AJMP ISRTF1

ORG 0100h
INIT:
	;Initializing all digits
	MOV secONE, #00h
	MOV secTEN, #10h
	MOV minONE, #20h
	MOV minTEN, #30h
	MOV tmsONE, #00h
	MOV tmsTEN, #10h
	MOV tseONE, #20h
	MOV tseTEN, #30h
	;Setting up the pointers
	MOV R0, #secONE
	MOV R2, #0000h
	;Setting up the timer and interrupt
	MOV TMOD, #11h ;Set Timers to be 2 8-bits
	SETB IT0	;Set external interrupt 0 to be edge triggered
	SETB IT1	;Set external interrupt 1 to be edge triggered
	MOV TH0, #0ECh 	
	MOV TL0, #081h
	MOV TH1, #0D8h 	
	MOV TL1, #0F9h
	SETB EA		;Activate Global Interrupt
	SETB ET0	;Activate Timer0 Interrupt
	SETB ET1	;Activate Timer1 Interrupt
	SETB EX0	;Activate External Interrupt0
	SETB EX1	;Activate External Interrupt1
	SETB TR0	;Start running the timer0
	CLR 0000h	;Bit determining which mode
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
	;Counter for Clock
	INC R2
	CJNE R2, #200, SKIP
	ACALL UPDATE
	MOV R2, #00h
SKIP:
	SETB EA
	RETI

ORG 0200h
ISRTF1:
	CLR EA	
	; Reset clock
	MOV TH1, #0D8h 	
	MOV TL1, #0F9h
	ACALL UPDATESTP
	SETB EA
	RETI

ORG 0250h
ISRIE0:
	CPL 0000h
	MOV R0, #tmsONE
	JB 0000h, modeSTP
	MOV R0, #secONE
	MOV tmsONE, #00h
	MOV tmsTEN, #10h
	MOV tseONE, #20h
	MOV tseTEN, #30h
modeSTP:
	RETI

ORG 0300h
ISRIE1:
	JB 000h, STARTSTP
	AJMP endIE1
STARTSTP:
	CPL TR1
endIE1:
	RETI


ORG 0500h
DISPLAY:
	MOV P1, @R0
	INC R0
	JB 0000h, dispSTP
	CJNE R0, #0034h, ENDDISP
	MOV R0, #secONE
	AJMP ENDDISP
dispSTP:
	CJNE R0, #0044h, ENDDISP
	MOV R0, #tmsONE
ENDDISP:
	RET

ORG 0550h
; Update the digits
UPDATE:
	MOV R1, #secONE
; updating secONE
	MOV A, @R1
	CJNE A, #9h, INCC
	MOV A, #00h
	MOV @R1, A
	INC R1
; updateing secTEN
	MOV A, @R1
	CJNE A, #15h, INCC
	MOV A, #10h
	MOV @R1, A
	INC R1
; updating minONE
	MOV A, @R1
	CJNE A, #29h, INCC
	MOV A, #20h
	MOV @R1, A
	INC R1
; updating minTEN
	MOV A, @R1
	CJNE A, #35h, INCC
	MOV A, #30h
	MOV @R1, A
	INC R1	
INCC:
	INC A
	MOV @R1, A
	RET

ORG 600h
UPDATESTP:
MOV R1, #tmsONE
; updating secONE
	MOV A, @R1
	CJNE A, #9h, INCCSTP
	MOV A, #00h
	MOV @R1, A
	INC R1
; updateing secTEN
	MOV A, @R1
	CJNE A, #19h, INCCSTP
	MOV A, #10h
	MOV @R1, A
	INC R1
; updating minONE
	MOV A, @R1
	CJNE A, #29h, INCCSTP
	MOV A, #20h
	MOV @R1, A
	INC R1
; updating minTEN
	MOV A, @R1
	CJNE A, #35h, INCCSTP
	MOV A, #30h
	MOV @R1, A
	INC R1	
INCCSTP:
	INC A
	MOV @R1, A
	RET
RET
END


