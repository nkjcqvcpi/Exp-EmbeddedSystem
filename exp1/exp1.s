DATA_ADDR EQU    0x40008000

		  AREA   Exp1,CODE,READONLY
		  ENTRY
		  CODE32

START     MOV    R0,#0            ; R0 is set to 0, Counter for data load times
	      LDR    R1,=DATA_ADDR    ; R1 is set to the address of the DATA_ADDR
	      LDR    R2,=DATA         ; R2 is set to the address of the DATA
	      B	     DATA_LOAD        ; Jump to the DATA_LOAD subroutine

DATA	  DCW    100,95,90,85,80,75,70,65,60,5,50,45,40,35,30,25,20,15,10,55

DATA_LOAD LDRH   R3,[R2],#2       ; 从R3中将一个16位的半字数据传送到R2 + 2中，同时将寄存器的高16位清零
		  STRH   R3,[R1],#2       ; 从R3中将一个低16位的半字数据传送到R1 + 2中

		  ADD    R0,R0,#1         ; Counter increasement
		  CMP    R0,#20           ; Compare counter with 20
		  BLS    DATA_LOAD        ; If R0 is less than 20, then jump to the DATA_LOAD subroutine, Stop data_load when counter == 20

		  MOV    R0,#0            ; R0 is set to 0, Counter1 for bubble sort outer loop

LOOP_1	  LDR    R1,=DATA_ADDR    ; R1 is set to the address of the DATA_ADDR
		  ADD    R2,R1,#2         ; R2 is set to the address of the DATA_ADDR + 2
		  MOV    R5,#0            ; R5 is set to 0, Counter2 for bubble sort inner loop

LOOP_2	  LDRH   R3,[R1]          ; 从R3中将一个16位的半字数据传送到R1中，同时将寄存器的高16位清零
		  LDRH   R4,[R2]          ; 从R4中将一个16位的半字数据传送到R2中，同时将寄存器的高16位清零
		  CMP    R3,R4            ; Compare R3 and R4, judge swap condition
		  STRHIH R3,[R2]          ; If R3 is greater than R4, then store R3 to R2
		  STRHIH R4,[R1]          ; If R3 is greater than R4, then store R4 to R1
		  ADD    R1,R1,#2         ; R1 is incremented by 2
		  ADD    R2,R2,#2         ; R2 is incremented by 2

		  ADD    R5,R5,#1         ; Counter2 increasement
		  CMP    R5,#20           ; If R5 is less than 20, then jump to the LOOP_2 subroutine
		  BNE    LOOP_2

		  ADD    R5,R5,#1         ; R5 is incremented by 1
		  CMP    R5,#20           ; If R5 is less than 20, then jump to the LOOP_1 subroutine
		  BNE    LOOP_1

		  MOV    R1,#6            ; Success when R1's value change to 6
		  END
