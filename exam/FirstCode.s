Address		EQU		0x40008000	; 定义一个变量，地址为0x40005000	
			
			AREA	Example,CODE,READONLY	; 声明代码段Example 
			ENTRY							; 标识程序入口
			CODE32							; 声明32位ARM指令
START		LDR		R1,=Address				; R1 <- Address
			MOV		R0,#10					; R0 <- 10 
			STR		R0,[R1]					; [R1] <- R0
			MOV		R2,#8
			MOV 	R3,#10
			MOV		R4,#15
			MOV		R13,#0x0f0
			STMFD	SP!,{R2-R4}
			LDMFD	SP!,{R5-R7}

			LDR		R5,=MyData3
			LDR		R4,=MyData2
			LDR		R3,=MyData1
			
			SUB		R5,R5,#1
			
LOOP		LDRB	R6,[R5,#1]!
			LDRB	R7,[R5,#1]!			
			
			LDRH	R8,[R4],#2
			LDRH	R9,[R4],#2						
	   			
			LDR		R1,[R3],#4
			LDR		R2,[R3],#4

			CMP		R1,R2			; R1与R2比较
			STRHI	R2,[R3]
			STRLS	R1,[R3]
	
			BL		LOOP
			
MyData1     DCD 10,20,30,40,50,60,70,80,90	;第1组数据
MyData2     DCW 10,20,30,40,50,60,70,80,90	;第2组数据
MyData3     DCB 10,20,30,40,50,60,70,80,90	;第3组数据
						
			END