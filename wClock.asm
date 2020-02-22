; Clock Code by D2
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
;ORG 0003h
;AJMP ISRIE0

ORG 000Bh
AJMP ISRTF0

;ORG 0013h
;AJMP ISRIE1

;ORG 001Bh
;AJMP ISRTF1

ORG 0100h
INIT:
	MOV secONE, #00h
	MOV secTEN, #10h
	MOV minONE, #20h
	MOV minTEN, #30h
	MOV R0, #secONE
	MOV R2, #00h
	MOV TMOD, #11h
	MOV TH0, #0ECh 	
	MOV TL0, #081h
	SETB EA
	SETB TR0
	SETB ET0
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
	MOV P1, @R0
	INC R0
; insert here the code for counter
	INC R2
	CJNE R2, #200, VDIGIT 
	ACALL UPDATE
	MOV R2, #00h 
VDIGIT:
	CJNE R0, #0034h, SKIP
	MOV R0, #secONE
SKIP:
	SETB EA
	RETI

ORG 0200h
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
	
	
END


