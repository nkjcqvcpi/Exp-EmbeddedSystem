Address1 EQU  0x40008000	         ; 定义一个变量，地址为0x40008000
Address2 EQU  0x40008014	         ; 定义一个变量，地址为0x40008014

N        EQU  10
         AREA Example,CODE,READONLY  ; 声明代码段Example
         ENTRY						 ; 标识程序入口
         CODE32						 ; 声明32位ARM指令

START    LDR  R1,=Address1			 ; R1 <- Address
         LDR  R2,=MyData2            ; R2 <-MyData2 Address
         MOV  R7,#20                 ; 定义存储数据次数
         LDR  R0,=Address1           ; 保存地址


LdDa     LDRH R5,[R2],#2             ; 加载MyData2数据到R5
         STRH R5,[R1],#2             ; 将MyData2的数据通过R5存入以0x40008000位地址的空间中
         SUBS R7,R7,#1
         CMP  R7,#0
         BNE  LdDa

         MOV  R7,#0                  ; 执行完存储地址任务清零
         MOV  R8,#0                  ; 给与中间量地址


START2   LDR  R0,=Address1           ; 保存地址
         MOV  R1,#0                	 ; 外循环计数器
         MOV  R2,#0                	 ; 内循环计数器

LOOPI    ADD  R3,R0,R1,LSL #1        ; 外循环首地址放入 R3
         MOV  R4,R3                  ; 外循环首地址放入 R4
         ADD  R2,R1,#1               ; 内循环计数器初值
         MOV  R5,R4                  ; 内循环下一地址初值
         LDRH R6,[R4]                ; 取内循环第一个值 R4
LOOPJ    ADD  R5,R5,#2               ; 内循环下一地址值
         LDRH R7,[R5]                ; 取出下一地址值 R7
         CMP  R6,R7                  ; 比较
         BLT  NEXT1                  ; 小则取下一个
         LDRH R7,[R5]                ; 将R5所存的的值存入R7
         STRH R6,[R5]                ; 将R6的值存入R5这个地址空间
         STRH R7,[R8]                ; 将R7的值存入R8这个地址空间
         LDRH R6,[R8]                ; 将R8所存的值存回R6

NEXT1    ADD  R2,R2,#1               ; 内循环计数
         CMP  R2,#N                  ; 循环中止条件
         BLT  LOOPJ                  ; 小于 N 则继续内循环 , 实现比较一轮
         LDRH R7,[R3]                ; 将R3所存的值存入R7
         STRH R6,[R3]                ; 将R6的值存入R3
         ADD  R1,R1,#1               ; 外循环计数
         CMP  R1,#N-1                ; 处循环中止条件
         BLT  LOOPI                  ; 小于 N-1 继续执行外循环

START3   LDR  R0,=Address2           ; 保存地址
         MOV  R1,#0                  ; 外循环计数器
         MOV  R2,#0                  ; 内循环计数器

LOOPII   ADD  R3,R0,R1,LSL #1        ; 外循环首地址放入 R3
         MOV  R4,R3                  ; 外循环首地址放入 R4
         ADD  R2,R1,#1               ; 内循环计数器初值
         MOV  R5,R4                  ; 内循环下一地址初值
         LDRH R6,[R4]                ; 取内循环第一个值 R4
LOOPJJ   ADD  R5,R5,#2               ; 内循环下一地址值
         LDRH R7,[R5]                ; 取出下一地址值 R7
         CMP  R7,R6                  ; 比较
         BLT  NEXT2                  ; 小则取下一个
         LDRH R7,[R5]                ; 将R5所存的的值存入R7
         STRH R6,[R5]                ; 将R6的值存入R5这个地址空间
         STRH R7,[R8]                ; 将R7的值存入R8这个地址空间
         LDRH R6,[R8]                ; 将R8所存的值存回R6

NEXT2    ADD  R2,R2,#1               ; 内循环计数
         CMP  R2,#N                  ; 循环中止条件
         BLT  LOOPJJ                 ; 小于 N 则继续内循环 , 实现比较一轮
         LDRH R7,[R3]                ; 将R3所存的值存入R7
         STRH R6,[R3]                ; 将R6的值存入R3
         ADD  R1,R1,#1               ; 外循环计数
         CMP  R1,#N-1                ; 处循环中止条件
         BLT  LOOPII                 ; 小于 N-1 继续执行外循环
         B    START3

MyData2  DCW  100,95,90,85,80,75,70,65,60,5,50,45,40,35,30,25,20,15,10,55  ; 第2组数据

         END