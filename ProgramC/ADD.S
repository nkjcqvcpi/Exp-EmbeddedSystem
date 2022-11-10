           EXPORT BubbleSort
Address1   EQU    0x40008000         ; 定义一个变量，地址为0x40008000
Address2   EQU    0x40008014	     ; 定义一个变量，地址为0x40008000
N          EQU    10
           AREA	  AddC,CODE,READONLY ; 声明代码段AddC
           ENTRY                     ; 标识程序入口
           CODE32                    ; 声明32位ARM指令

BubbleSort MOV    R11,#0             ; 外循环计数器
           MOV    R12,#0             ; 内循环计数器

LOOPI      ADD    R3,R0,R11,LSL #1   ; 外循环首地址放入 R3
           MOV    R4,R3              ; 外循环首地址放入 R4
           ADD    R12,R11,#1         ; 内循环计数器初值
           MOV    R5,R4              ; 内循环下一地址初值
           LDRH   R6,[R4]            ; 取内循环第一个值 R4

LOOPJ      ADD    R5,R5,#2           ; 内循环下一地址值
           LDRH   R7,[R5]            ; 取出下一地址值 R7
           CMP    R6,R7              ; 比较
           BLT    NEXT               ; 小则取下一个
           LDRH   R7,[R5]            ; 将R5所存的的值存入R7
           STRH   R6,[R5]            ; 将R6的值存入R5这个地址空间
           STRH   R7,[R8]            ; 将R7的值存入R8这个地址空间
           LDRH   R6,[R8]            ; 将R8所存的值存回R6

NEXT       ADD    R12,R12,#1         ; 内循环计数
           CMP    R12,#N             ; 循环中止条件
           BLT    LOOPJ              ; 小于 N 则继续内循环 , 实现比较一轮
           LDRH   R7,[R3]            ; 将R3所存的值存入R7
           STRH   R6,[R3]            ; 将R6的值存入R3
           ADD    R11,R11,#1         ; 外循环计数
           CMP    R11,#N-1           ; 处循环中止条件
           BLT    LOOPI              ; 小于 N-1 继续执行外循环

           MOV    R11,#0             ; 外循环计数器
           MOV    R12,#0             ; 内循环计数器
           ADD    R0,R0,#20          ; 从第十一个数开始

LOOPI1     ADD    R3,R0,R11,LSL #1   ; 外循环首地址放入 R3
           MOV    R4,R3              ; 外循环首地址放入 R4
           ADD    R12,R11,#1         ; 内循环计数器初值
           MOV    R5,R4              ; 内循环下一地址初值
           LDRH   R6,[R4]            ; 取内循环第一个值 R4

LOOPJ1     ADD    R5,R5,#2           ; 内循环下一地址值
           LDRH   R7,[R5]            ; 取出下一地址值 R7
           CMP    R7,R6              ; 比较
           BLT    NEXT1              ; 小则取下一个
           LDRH   R7,[R5]            ; 将R5所存的的值存入R7
           STRH   R6,[R5]            ; 将R6的值存入R5这个地址空间
           STRH   R7,[R8]            ; 将R7的值存入R8这个地址空间
           LDRH   R6,[R8]            ; 将R8所存的值存回R6

NEXT1      ADD    R12,R12,#1         ; 内循环计数
           CMP    R12,#N             ; 循环中止条件
           BLT    LOOPJ1             ; 小于 N 则继续内循环 , 实现比较一轮
           LDRH   R7,[R3]            ; 将R3所存的值存入R7
           STRH   R6,[R3]            ; 将R6的值存入R3
           ADD    R11,R11,#1         ; 外循环计数
           CMP    R11,#N-1           ; 处循环中止条件
           BLT    LOOPI1             ; 小于 N-1 继续执行外循环

           MOV    PC,LR
MyData2    DCW    60,80,70,60,50,40,30,20,10,45,33,48,96,48,16,19,83,37,48,55 ; 第2组数据

		   END
