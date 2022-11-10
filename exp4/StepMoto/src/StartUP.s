;/****************************************Copyright (c)**************************************************
;**                               Guangzhou ZHIYUAN electronics Co.,LTD.
;**                                     
;**                                 http://www.zyinside.com
;**
;**--------------File Info-------------------------------------------------------------------------------
;** File Name: startup.s
;** Last modified Date: 2005-12-31 
;** Last Version: v1.0
;** Description: S3C2410异常向量表与c语言代码的接口，包括初始化堆栈、堆空间分配、打开/禁止中断的代码
;**
;**------------------------------------------------------------------------------------------------------
;** Created By: 黄绍斌
;** Created date: 2005-12-31 
;** Version: v1.0
;** Descriptions:
;**
;**------------------------------------------------------------------------------------------------------
;** Modified by:
;** Modified date:
;** Version:
;** Description:
;**
;********************************************************************************************************/

; /* 定义堆栈的大小 */
; **** 用户可根据实际需要修改 ****
USR_STACK_LEGTH     EQU         64
SVC_STACK_LEGTH     EQU         16
FIQ_STACK_LEGTH     EQU         16
IRQ_STACK_LEGTH     EQU         64
ABT_STACK_LEGTH     EQU         0
UND_STACK_LEGTH     EQU         0

   
; /*************************************************************************/
; /* CPSR寄存器的位域                                                      */
; /*************************************************************************/
; /*                                                                       */
; /* 31  30  29   28         7   6   5   4   3   2   1   0                 */
; /*+---+---+---+---+--ss--+---+---+---+---+---+---+---+---+               */
; /*| N | Z | C | V |      | I | F | T |     M4 ~ M0       |               */
; /*+---+---+---+---+--ss--+---+---+---+---+---+---+---+---+               */
; /*                                                                       */
; /* Processor Mode and Mask                                               */
; /*                                                                       */
; /*************************************************************************/
Mode_USR        EQU     0x10
Mode_FIQ        EQU     0x11
Mode_IRQ        EQU     0x12
Mode_SVC        EQU     0x13
Mode_ABT        EQU     0x17
Mode_UND        EQU     0x1B
Mode_SYS        EQU     0x1F 
I_BIT           EQU     0x80 	; when I bit is set (1), IRQ is disabled
F_BIT           EQU     0x40 	; when F bit is set (1), FIQ is disabled



; /************************************************************************/
; /* 引入的外部标号在这声明 */
		IMPORT  __main                          ; C语言主程序入口 
		IMPORT  FIQ_Exception 					; FIQ中断服务程序
		IMPORT  IRQ_Exception					; IRQ中断服务程序 
		IMPORT  TargetBusInit                   ; 针对目标板的总线系统初始化
		IMPORT  TargetResetInit 				; 调用main函数前目标板初始化代码
	
; /* 给外部使用的标号在这声明 */
    	EXPORT  Vectors    
    	EXPORT  ResetInit
        EXPORT  DisableMMU 
        EXPORT  EnableICache  
        EXPORT  DisableICache
        EXPORT  EnableDCache  
        EXPORT  DisableDCache 
    
    	EXPORT  __rt_div0
    	EXPORT  __user_initial_stackheap    
    

; /************************************************************************/
    	CODE32
   		AREA    Startup,CODE,READONLY
; /* 异常向量表 */
Vectors
        LDR     PC, ResetAddr
        LDR     PC, UndefinedAddr
        LDR     PC, SWI_Addr
        LDR     PC, PrefetchAddr
        LDR     PC, DataAbortAddr
        DCD     0
        LDR     PC, IRQ_Addr
        LDR     PC, FIQ_Addr

ResetAddr           DCD     ResetInit
UndefinedAddr       DCD     Undefined
SWI_Addr            DCD     SoftwareInterrupt
PrefetchAddr        DCD     PrefetchAbort
DataAbortAddr       DCD     DataAbort
Nouse               DCD     0
IRQ_Addr            DCD     IRQ_Exception
FIQ_Addr            DCD     FIQ_Handler


; /* 未定义指令 */
Undefined
        B       Undefined
        

; /* 软中断 */
SoftwareInterrupt			                               
        CMP     R0, #4
        LDRLO   PC, [PC, R0, LSL #2]
        MOVS    PC, LR

SwiFunction
        DCD     IRQDisable       ;0
        DCD     IRQEnable        ;1
        DCD		FIQDisable		 ;2
        DCD		FIQEnable		 ;3

IRQDisable
        ; 关IRQ中断
        MRS     R0, SPSR
        ORR     R0, R0, #I_BIT
        MSR     SPSR_c, R0
        MOVS    PC, LR

IRQEnable
        ; 开IRQ中断
        MRS     R0, SPSR
        BIC     R0, R0, #I_BIT
        MSR     SPSR_c, R0
        MOVS    PC, LR
        
FIQDisable
        ; 关FIQ中断
        MRS     R0, SPSR
        ORR     R0, R0, #F_BIT
        MSR     SPSR_c, R0
        MOVS    PC, LR

FIQEnable
        ; 开FIQ中断
        MRS     R0, SPSR
        BIC     R0, R0, #F_BIT
        MSR     SPSR_c, R0
        MOVS    PC, LR

        
; /* 取指中止 */
PrefetchAbort
        B       PrefetchAbort

; /* 取数据中止 */
DataAbort
        B       DataAbort
        

; /* 快速中断 */
FIQ_Handler
        STMFD   SP!, {R0-R3, LR}        
        BL      FIQ_Exception			; FIQ中断处理
        LDMFD   SP!, {R0-R3, LR}
        SUBS    PC,  LR,  #4                
                
        
        

;/*********************************************************************************************************
;** Function name: ResetInit
;** Descriptions: 复位入口
;** Input: 无
;** Output: 无
;** Created by: 陈明计
;** Created Date: 2004-02-02
;**-------------------------------------------------------------------------------------------------------
;** Modified by: 黄绍斌
;** Modified Date: 2005-12-31 
;**------------------------------------------------------------------------------------------------------
;********************************************************************************************************/
ResetInit
        BL      InitStack               ; 初始化堆栈                                              
        BL      TargetBusInit           ; 总线系统初始化 (函数中不允许堆栈操作)
 		BL		TargetResetInit			; 针对目标板的系统初始化 		  	 			
 		
 		MRC		p15,0,R1,c1,c0,0		; (MMU设置，异步总线模式) 读控制寄存器
		ORR		R1,R1,#0xC0000000	    ; 当HDIVN=1时操作有效
		MRC		p15,0,R1,c1,c0,0
		
        B       __main					; 跳转到c语言入口  
        B       .                       ; 如果main返回，则死循环 



;/*********************************************************************************************************
;** Function name: DisableMMU
;** Descriptions: 禁止MMU
;** Input: 无
;** Output: 无
;** Created by: 黄绍斌
;** Created Date: 2005-12-31 
;**-------------------------------------------------------------------------------------------------------
;** Modified by: 
;** Modified Date: 
;**------------------------------------------------------------------------------------------------------
;********************************************************************************************************/
DisableMMU
        MRC     p15,0,R0,c1,c0,0
        BIC     R0,R0,#(1<<0)
        MCR     p15,0,R0,c1,c0,0
        MOV     PC, LR
        
        

;/*********************************************************************************************************
;** Function name: EnableICache
;** Descriptions: 使能指令CACHE
;** Input: 无
;** Output: 无
;** Created by: 黄绍斌
;** Created Date: 2005-12-31 
;**-------------------------------------------------------------------------------------------------------
;** Modified by: 
;** Modified Date: 
;**------------------------------------------------------------------------------------------------------
;********************************************************************************************************/
EnableICache        
        MRC     p15,0,R0,c1,c0,0
        ORR     r0,R0,#(1<<12)
        MCR     p15,0,R0,c1,c0,0
        MOV     PC, LR
        


;/*********************************************************************************************************
;** Function name: DisableICache
;** Descriptions: 禁止指令CACHE
;** Input: 无
;** Output: 无
;** Created by: 黄绍斌
;** Created Date: 2005-12-31 
;**-------------------------------------------------------------------------------------------------------
;** Modified by: 
;** Modified Date: 
;**------------------------------------------------------------------------------------------------------
;********************************************************************************************************/
DisableICache       
        MRC     p15,0,R0,c1,c0,0
        BIC     R0,R0,#(1<<12)
        MCR     p15,0,R0,c1,c0,0
        MOV     PC, LR
   
   
   
;/*********************************************************************************************************
;** Function name: EnableDCache
;** Descriptions: 使能数据CACHE
;** Input: 无
;** Output: 无
;** Created by: 黄绍斌
;** Created Date: 2005-12-31 
;**-------------------------------------------------------------------------------------------------------
;** Modified by: 
;** Modified Date: 
;**------------------------------------------------------------------------------------------------------
;********************************************************************************************************/
EnableDCache        
        MRC     p15,0,R0,c1,c0,0
        ORR     R0,R0,#(1<<2)
        MCR     p15,0,R0,c1,c0,0
        MOV     PC, LR



;/*********************************************************************************************************
;** Function name: DisableDCache
;** Descriptions: 禁止数据CACHE
;** Input: 无
;** Output: 无
;** Created by: 黄绍斌
;** Created Date: 2005-12-31 
;**-------------------------------------------------------------------------------------------------------
;** Modified by: 
;** Modified Date: 
;**------------------------------------------------------------------------------------------------------
;********************************************************************************************************/
DisableDCache       
        MRC     p15,0,R0,c1,c0,0
        BIC     R0,R0,#(1<<2)
        MCR     p15,0,R0,c1,c0,0
        MOV     PC,LR


	    															   
;/*********************************************************************************************************
;** Function name: InitStack
;** Descriptions: 初始化堆栈
;** Input: 无
;** Output: 无
;** Created by: 陈明计
;** Created Date: 2004-02-02
;**-------------------------------------------------------------------------------------------------------
;** Modified by: 黄绍斌
;** Modified Date: 2005-12-31 
;** Note: 给CPSR_c赋值采用宏的方式
;**------------------------------------------------------------------------------------------------------
;********************************************************************************************************/
InitStack    
        MOV     R0, LR

; /* 设置管理模式堆栈 */
        MSR     CPSR_c, #(Mode_SVC | I_BIT | F_BIT) 	; 0xd3
        LDR     SP, StackSvc
; /* 设置中断模式堆栈 */
        MSR     CPSR_c, #(Mode_IRQ | I_BIT | F_BIT)		; 0xd2
        LDR     SP, StackIrq
; /* 设置快速中断模式堆栈 */
        MSR     CPSR_c, #(Mode_FIQ | I_BIT | F_BIT)		; 0xd1
        LDR     SP, StackFiq
; /* 设置中止模式堆栈 */
        MSR     CPSR_c, #(Mode_ABT | I_BIT | F_BIT)		; 0xd7
        LDR     SP, StackAbt
; /* 设置未定义模式堆栈 */
        MSR     CPSR_c, #(Mode_UND | I_BIT | F_BIT)		; 0xdb
        LDR     SP, StackUnd
; /* 设置系统模式堆栈 */
        MSR     CPSR_c, #(Mode_SYS | I_BIT | F_BIT)		; 0xdf
        LDR     SP, StackUsr

        MOV     PC, R0

StackUsr           DCD     UsrStackSpace + (USR_STACK_LEGTH - 1) * 4
StackSvc           DCD     SvcStackSpace + (SVC_STACK_LEGTH - 1)* 4
StackIrq           DCD     IrqStackSpace + (IRQ_STACK_LEGTH - 1)* 4
StackFiq           DCD     FiqStackSpace + (FIQ_STACK_LEGTH - 1)* 4
StackAbt           DCD     AbtStackSpace + (ABT_STACK_LEGTH - 1)* 4
StackUnd           DCD     UndtStackSpace + (UND_STACK_LEGTH - 1)* 4


	
;/*********************************************************************************************************
;** Function name: __user_initial_stackheap
;** Descriptions: 库函数初始化堆和栈，不能删除
;** Input: 参考库函数手册
;** Output: 参考库函数手册
;** Created by: 陈明计
;** Created Date: 2004-02-02
;**-------------------------------------------------------------------------------------------------------
;** Modified by: 
;** Modified Date: 
;**------------------------------------------------------------------------------------------------------
;********************************************************************************************************/
__user_initial_stackheap    
    LDR   r0,=bottom_of_heap
    MOV   pc,lr



;/*********************************************************************************************************
;** Function name: __rt_div0
;** Descriptions: 整数除法除数为0错误处理函数，替代原始的__rt_div0减少目标代码大小
;** Input: 参考库函数手册
;** Output: 无
;** Created by: 陈明计
;** Created Date: 2004-02-02
;**-------------------------------------------------------------------------------------------------------
;** Modified by: 
;** Modified Date: 
;**------------------------------------------------------------------------------------------------------
;********************************************************************************************************/
__rt_div0
        B       __rt_div0
        
        


; /* 分配堆空间 */
        AREA    Myheap, DATA, NOINIT, ALIGN=2
bottom_of_heap     SPACE   256  				;库函数的堆空间			


; /* 分配堆栈空间 */
        AREA    MyStacks, DATA, NOINIT, ALIGN=2
UsrStackSpace      SPACE   USR_STACK_LEGTH * 4  ;用户（系统）模式堆栈空间
SvcStackSpace      SPACE   SVC_STACK_LEGTH * 4  ;管理模式堆栈空间
IrqStackSpace      SPACE   IRQ_STACK_LEGTH * 4  ;中断模式堆栈空间
FiqStackSpace      SPACE   FIQ_STACK_LEGTH * 4  ;快速中断模式堆栈空间
AbtStackSpace      SPACE   ABT_STACK_LEGTH * 4  ;中止义模式堆栈空间
UndtStackSpace     SPACE   UND_STACK_LEGTH * 4  ;未定义模式堆栈

		END
;/*********************************************************************************************************
;**                            End Of File
;********************************************************************************************************/
