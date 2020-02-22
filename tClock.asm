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
0000| AJMP INIT
       
      ; Interrupts
      ORG 0003h
0003| AJMP ISRIE0
       
      ORG 000Bh
000B| AJMP ISRTF0
       
      ORG 0013h
0013| AJMP ISRIE1
       
      ORG 001Bh
001B| AJMP ISRTF1
       
      ORG 0100h
      INIT:
      	;Initializing all digits
0100| 	MOV secONE, #00h
0103| 	MOV secTEN, #10h
0106| 	MOV minONE, #20h
0109| 	MOV minTEN, #30h
010C| 	MOV tmsONE, #00h
010F| 	MOV tmsTEN, #10h
0112| 	MOV tseONE, #20h
0115| 	MOV tseTEN, #30h
      	;Setting up the pointers
0118| 	MOV R0, #secONE
011A| 	MOV R2, #0000h
      	;Setting up the timer and interrupt
011C| 	MOV TMOD, #11h ;Set Timers to be 2 8-bits
011F| 	SETB IT0 ;Set external interrupt 0 to be edge triggered
0121| 	MOV TH0, #0ECh 	
0124| 	MOV TL0, #081h
0127| 	MOV TH1, #0ECh 	
012A| 	MOV TL1, #081h
012D| 	SETB EA
012F| 	SETB ET0
0131| 	SETB ET1
0133| 	SETB EX0
0135| 	SETB TR0
0137| 	CLR 0000h ;Bit value to change mode
0139| 	AJMP WAIT
       
      ORG 0150h
      ; Will Wait here
      WAIT:
0150| 	JMP $
      	
      ; Time interrrupt ISR
      ORG 0155h
      ISRTF0: 
0155| 	CLR EA	
      	; Reset clock
0157| 	MOV TH0, #0ECh 	
015A| 	MOV TL0, #081h
015D| 	INC R2
015E| 	ACALL DISPLAY
0160| 	CJNE R2, #200, SKIP
0163| 	ACALL UPDATE
0165| 	MOV R2, #00h
      SKIP:
0167| 	SETB EA
0169| 	RETI
       
      ORG 0200h
      ISRTF1:
0200| 	CLR EA	
      	; Reset clock
0202| 	MOV TH1, #0ECh 	
0205| 	MOV TL1, #081h
0208| 	INC R3
0209| 	CJNE R3, #2, SKIP2
020C| 	ACALL UPDATESTP
020E| 	MOV R3, #00h
      SKIP2:
0210| 	SETB EA
0212| 	RETI
       
      ORG 0250h
      ISRIE0:
0250| 	CPL 0000h
0252| 	MOV R0, #tmsONE
0254| 	JB 0000h, modestp
0257| 	MOV R0, #secONE
      modestp:
0259| 	RETI
       
      ORG 0300h
      ISRIE1:
0300| 	RETI
       
       
      ORG 0500h
      DISPLAY:
0500| 	MOV P1, @R0
0502| 	INC R0
0503| 	JB 0000h, dispSTP
0506| 	CJNE R0, #0034h, ENDDISP
0509| 	MOV R0, #secONE
050B| 	AJMP ENDDISP
      dispSTP:
050D| 	CJNE R0, #0044h, ENDDISP
0510| 	MOV R0, #tmsONE
      ENDDISP:
0512| 	RET
       
      ORG 0550h
      ; Update the digits
      UPDATE:
0550| 	MOV R1, #secONE
      ; updating secONE
0552| 	MOV A, @R1
0553| 	CJNE A, #9h, INCC
0556| 	MOV A, #00h
0558| 	MOV @R1, A
0559| 	INC R1
      ; updateing secTEN
055A| 	MOV A, @R1
055B| 	CJNE A, #15h, INCC
055E| 	MOV A, #10h
0560| 	MOV @R1, A
0561| 	INC R1
      ; updating minONE
0562| 	MOV A, @R1
0563| 	CJNE A, #29h, INCC
0566| 	MOV A, #20h
0568| 	MOV @R1, A
0569| 	INC R1
      ; updating minTEN
056A| 	MOV A, @R1
056B| 	CJNE A, #35h, INCC
056E| 	MOV A, #30h
0570| 	MOV @R1, A
0571| 	INC R1	
      INCC:
0572| 	INC A
0573| 	MOV @R1, A
0574| 	RET
       
      ORG 600h
      UPDATESTP:
0600| RET
      END
