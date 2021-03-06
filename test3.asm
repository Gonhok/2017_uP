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
PORTD	EQU	08H
PORTE	EQU	09H
PCLATH	EQU	0AH
INTCON	EQU	0BH
; BANK 1
OPTINOR	EQU	81H
TRISA	EQU	85H
TRISB	EQU	86H
TRISC	EQU	87H
TRISD	EQU	88H
TRISE	EQU	89H
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
; --OPTION BITS 선언 ---

W	EQU	B'0'	;W 변수를 0으로 선언
F	EQU	.1	;F 변수를 1로 선언

LED1	EQU	21H
DBUF1	EQU	22H
DBUF2	EQU	23H
LED2	EQU	24H
; MAIN PROGRAM
	ORG 0000
	BSF	STATUS,RP0	;BANK를 1로 변경함
	MOVLW	B'00000111'	;PORTA를 DIGITAL I/O로사용
	MOVWF	ADCON1
	MOVLW	B'00000000'	;
	MOVWF	TRISA
	MOVLW	B'00000000'
	MOVWF	TRISC
	BCF	STATUS,RP0	;BANK를 0으로 변경
;
MAIN	;CALL	DELAY
	CLRF 	PORTA
	MOVLW	01
	ADDLW	00	;CF를 0으로 만듬
	MOVWF	LED1	;초기값 01를 넣음
;	MOVLW 00
;	MOVWF LED2
LOOP
	MOVF	LED1,W
	;XORLW	B'11111111'	;NOT 시킴
	MOVWF	PORTC	;W 을 PORTC에 출력
;	MOVF	LED2,W
;	MOVWF PORTA
	RLF	LED1,F	;ROTATE 시킴
;	RLF	LED2,F
;	BTFSC	LED2,4
;	GOTO	MAIN
	CALL	DELAY
	GOTO	LOOP
	
; SUBROUTINE
DELAY
	MOVLW .125
	MOVWF	DBUF1
LP1	MOVLW	.200
	MOVWF	DBUF2
LP2	NOP
	DECFSZ	DBUF2,F
	GOTO	LP2
	DECFSZ	DBUF1,F
	GOTO	LP1
	RETURN
	
	END