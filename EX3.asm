; STANDARD HEADER FILE
	PROCESSOR 16F876A
; --- REGISTER FILES 선언 ---
; BANK 0
INDF	EQU	00H
TMR0	EQU	01H
PCL	EQU	02H
STATUS	EQU	03H
FSR	EQU	04H
PORTA	EQU	05H
PORTB	EQU	06H
PORTC	EQU	07H
PCLATH	EQU	0AH
INTCON	EQU	0BH
; BANK 1
OPTIONR	EQU	81H
TRISA	EQU	85H
TRISB	EQU	86H
TRISC	EQU	87H
ADCON1	EQU	9FH
; --- STATUS BITS선언 ---
IRP	EQU	7
RP1	EQU	6
RP0	EQU	5
NOT_TO	EQU	4
NOT_PD	EQU	3
ZF	EQU	2	;ZERO FLAG BIT
DC	EQU	1	;DIGIT CARRY/BORROW BIT
CF	EQU	0	;CARRY/BORROW FLAG BIT
; --INTCON BITS 선언 ---
;다음에 채우기 
; --OPTION BITS 선언 ---

W	EQU	B'0'	;W 변수를 0으로 선언
F	EQU	.1	;F 변수를 1로 선언

;사용자 정의 변수
DISP1	EQU	21H
DISP2	EQU	22H
DISP3	EQU	23H
DISP4	EQU	24H
DBUF1 EQU	25H
DBUF2	EQU	26H
KEY_DATA	EQU	27H
KEY_T	EQU	28H
; MAIN PROGRAM
	ORG 0000
	BSF	STATUS,RP0	;BANK를 1로 변경함
	MOVLW	B'00000111'	;PORTA를 DIGITAL I/O로사용
	MOVWF	ADCON1
	MOVLW	B'00001111'	;
	MOVWF	TRISA
	MOVLW	B'00000000'
	MOVWF	TRISC
	BCF	STATUS,RP0	;BANK를 0으로 변경
;
KEY_IN
LP	MOVLW	0FH
	MOVWF	KEY_DATA
LP2	MOVLW	B'11110111'
	MOVWF	PORTC
	CLRF	KEY_T
;
LP1	CALL	READ_KEY
	INCF	KEY_T,F
	RRF	PORTC,F
	BTFSC	STATUS,CF
	GOTO	LP1
;
	MOVF	KEY_DATA,W
	SUBLW	0
	BTFSS	STATUS,ZF
	GOTO	LP3
;
	BSF	PORTA,4
	;CALL	DELAY
LP3	BCF	PORTA,4
	GOTO	LP

READ_KEY
	MOVF	PORTA,W
	ANDLW	B'00000111'
	SUBLW	B'00000111'
	BTFSC	STATUS,ZF
	RETURN

;
	MOVF	PORTA,W
	MOVWF	KEY_DATA
	RLF	KEY_DATA,F
	RLF	KEY_DATA,W
	ANDLW	B'00011100'
	IORWF	KEY_T,W
	;ANDLW	B'00011111'
	CALL	KEY_TABLE
	MOVWF	KEY_DATA
	RETURN
;
KEY_TABLE
	ADDWF	PCL,F
	RETLW	0FH;000 00
	RETLW	0FH;000 01
	RETLW	0FH;000 10
	RETLW	0FH;000 11
	RETLW	0FH;001 00
	RETLW	0FH;001 01
	RETLW	0FH;001 10
	RETLW	0FH;001 11
	RETLW	0FH;010 00
	RETLW	0FH;010 01
	RETLW	0FH;010 10
	RETLW	0FH;010 11
	RETLW	01H;011 00
	RETLW	04H;011 01
	RETLW	07H;011 10
	RETLW	10H;011 11 --'*'
;
	RETLW	0FH;100 00
	RETLW	0FH;100 01
	RETLW	0FH;100 10
	RETLW	0FH;100 11
	RETLW	02H;101 00
	RETLW	05H;101 01
	RETLW	08H;101 10
	RETLW	00H;101 11
	RETLW	03H;110 00
	RETLW	06H;110 01
	RETLW	09H;110 10
	RETLW	11H;110 11 --'#'
	RETLW	0FH;111 00
	RETLW	0FH;111 01
	RETLW	0FH;111 10
	RETLW	0FH;111 11
	
	; SUBROUTINE
DELAY
	MOVLW .125
	MOVWF	DBUF1
DLP1	MOVLW	.200
	MOVWF	DBUF2
DLP2	NOP
	DECFSZ	DBUF2,F
	GOTO	DLP2
	DECFSZ	DBUF1,F
	GOTO	DLP1
	RETURN
	
	END