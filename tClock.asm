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
	SETB IT0 ;Set external interrupt 0 to be edge triggered
	MOV TH0, #0ECh 	
	MOV TL0, #081h
	MOV TH1, #0ECh 	
	MOV TL1, #081h
	SETB EA
	SETB ET0
	SETB ET1
	SETB EX0
	SETB TR0
	CLR 0000h
	AJMP WAIT

ORG 0150h
; Will Wait here
WAIT:
	JMP $
	
; Time interrrupt ISR
ORG 0155h
ISRTF0: 
	CLR EA	
	; Reset clock
	MOV TH0, #0ECh 	
	MOV TL0, #081h
	INC R2
	ACALL DISPLAY
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
	MOV TH1, #0ECh 	
	MOV TL1, #081h
	INC R3
	CJNE R3, #2, SKIP2
	ACALL UPDATESTP
	MOV R3, #00h
SKIP2:
	SETB EA
	RETI

ORG 0250h
ISRIE0:
	CPL 0000h
	MOV R0, #tmsONE
	JB 0000h, modestp
	MOV R0, #secONE
modestp:
	RETI

ORG 0300h
ISRIE1:
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
RET
END


