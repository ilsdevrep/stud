n equ 1
kh equ 1
kl equ 5
dseg at 30h
	arr0: ds n*2
	arr1: ds n*2
	subsum: ds 2
xseg
	res: ds 2
cseg
	jmp start
	org 100h
	tab_num1: dw 1000
	tab_num2: dw -500
	
	start:
		call init
								   	
		clr c		;clear carry

		clr a

		mov r0, #arr0
		mov r1, #arr1

		mov r6,a		;clear sum L
		mov r7,a		;clear sum H

		mov r3,#n
	 get_sum:

; count sum

		mov b,@r0
		inc r0
		mov a,@r0
		inc r0

		clr c
		add a,r7
		mov r7,a
		mov a,b
		
		addc a,r6
		mov r6,a
;n6:
		
		mov b,@r1
		inc r1
		mov a,@r1
		inc r1

		clr c
		rlc a
		push acc

		mov a,b
		rlc a
		mov b,a
		pop acc


		clr c
		add a,r7
		mov r7,a
		mov a,b
		
		addc a,r6
		mov r6,a
		
		djnz r3,get_sum

;having sum make avg
; check +-
		mov a,r6
		mov c,acc.7
		
		jnc above
		mov a,r6
		cpl a
		mov r6,a
		mov a,r7
		dec a
		cpl a
		mov r7,a
	above:
		
		
		mov acc.7,c ;keep carry
		mov r3,a
		
;div 2
		clr c
		mov a,r6
		rrc a
		mov r6,a
		mov a,r7
		rrc a
		mov r7,a
		clr c
;div n

		mov r4,#0 ;L
		mov r5,#0  ;H
lp:
		clr c
		mov a,r7
		subb a,#n
		mov r7,a
		mov a,r6
		subb a,#0
		mov r6,a
		
		clr c
		mov a,r4
		add a,#1
		mov r4,a
		mov a,r5
		addc a,#0
		mov r5,a
	
		mov a,r6
		mov c,acc.7

	jnc lp
		clr c
		mov a,r4
		subb a,#1
		mov r4,a
		mov a,r5
		subb a,#0
		mov r5,a
				
;check +-

		mov a,r3
		mov c, acc.7

		jnc addk

		mov a,r4
		cpl a
		add a,#1
		mov r4,a
		mov a,r5
		cpl a
		addc a,#0
		mov a,r5
;add k
addk:
		clr c
		mov a,r4
		add a,#kl
		mov r4,a
		mov a,r5
		addc a,#kh
		mov r5,a
		



;exit

		nop
		jmp exit	
	
	init:
		mov r0, # arr0
		mov r1, # arr1

		mov a, r1
		subb a, r0 ; offset between arrays

		mov r7, a
		mov r2, a
		mov dptr, # tab_num1
;		mov r1 ,# tab_num1
;		mov r7, #tab_num2
	cp_arrs:
		clr a
		movc a,@a+dptr
		mov @r0,a
		mov a,r7
		movc a,@a+dptr
		mov @r1,a
		inc r0
		inc r1
		inc dptr
		djnz r2,cp_arrs

		ret
	exit:

		mov dptr,#res
		mov a,r4
		movx @dptr,a
		inc dptr
		mov a,r5
		movx @dptr,a
		end