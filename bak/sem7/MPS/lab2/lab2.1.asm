E EQU 	p1.0
CSEG AT 8000h
JMP START

WRITE_COMMAND:
	CALL	WAIT_BF
	PUSH	acc
	PUSH	b

	MOV		b,a
	ANL		a,#11110000b
	MOV		p1,a
	
	SETB	E
	NOP
	CLR		E

	MOV		a,b
	SWAP	a
	ANL		a,#11110000b
	MOV		p1,a
	
	SETB	E
	NOP
	CLR		E

	MOV		p1,#11110000b
	POP		b
	POP		acc
RET

WRITE_DATA:
	PUSH	acc
	PUSH	b
	CALL	WAIT_BF
	
	MOV		b,a
	ANL		a,#11110000b
	ORL		a,#00000010b
	MOV		p1,a

	SETB	E
	NOP
	CLR 	E
	
	MOV		a,b
	SWAP	          a
	ANL		a,#11110000b
	ORL		a,#00000010b
	MOV		p1,a

	SETB	E
	NOP
	CLR		E

	MOV		p1,#11110000b
	POP		b
	POP		acc
RET

INIT:					
	CLR		E

	MOV		a,#28h			 
	CALL	WRITE_COMMAND

  MOV		a,#0Eh			
	CALL	WRITE_COMMAND

	MOV		a,#06h			
	CALL	WRITE_COMMAND

	MOV		a,#01h			
	CALL	WRITE_COMMAND

RET

;--

WAIT_BF:
	PUSH	acc
WAIT_LL:
   	MOV		p1,#11110100b
   	SETB	E
   	MOV		a,p1
   	CLR		E
   	MOV		b,a
   	SETB	E
   	MOV		a,p1
   	CLR		E
   	MOV		a,b
   	JB		acc.7,wait_ll
   	POP		acc
RET

;--

START:
	CALL	INIT

	PUSH	acc
	PUSH	b
		
	MOV R7, #07H;
	MOV DPTR, #text1;
	MET1:
	clr a
	movc a,@a+dptr
	inc dptr 
	call WRITE_DATA
	djnz r7,MET1
	

	mov  a,#0c0h				
	call write_command

	mov r7,#0aH
	mov dptr,#text2

m2:	clr a
	movc a, @a+dptr
	inc dptr 
	call WRITE_DATA
	djnz r7,m2		
	
    text1: db 'KUTUZOV' 
    org 8100h

    text2: db 'POZDNYAKOV' 
    org 8200h
		
m1:
	JMP m1
end
