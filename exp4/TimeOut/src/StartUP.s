;/****************************************Copyright (c)**************************************************
;**                               Guangzhou ZHIYUAN electronics Co.,LTD.
;**                                     
;**                                 http://www.zyinside.com
;**
;**--------------File Info-------------------------------------------------------------------------------
;** File Name: startup.s
;** Last modified Date: 2005-12-31 
;** Last Version: v1.0
;** Description: S3C2410�쳣��������c���Դ���Ľӿڣ�������ʼ����ջ���ѿռ���䡢��/��ֹ�жϵĴ���
;**
;**------------------------------------------------------------------------------------------------------
;** Created By: ���ܱ�
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

; /* �����ջ�Ĵ�С */
; **** �û��ɸ���ʵ����Ҫ�޸� ****
USR_STACK_LEGTH     EQU         64
SVC_STACK_LEGTH     EQU         16
FIQ_STACK_LEGTH     EQU         16
IRQ_STACK_LEGTH     EQU         64
ABT_STACK_LEGTH     EQU         0
UND_STACK_LEGTH     EQU         0

   
; /*************************************************************************/
; /* CPSR�Ĵ�����λ��                                                      */
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
; /* ������ⲿ����������� */
		IMPORT  __main                          ; C������������� 
		IMPORT  FIQ_Exception 					; FIQ�жϷ������
		IMPORT  IRQ_Exception					; IRQ�жϷ������ 
		IMPORT  TargetBusInit                   ; ���Ŀ��������ϵͳ��ʼ��
		IMPORT  TargetResetInit 				; ����main����ǰĿ����ʼ������
	
; /* ���ⲿʹ�õı���������� */
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
; /* �쳣������ */
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


; /* δ����ָ�� */
Undefined
        B       Undefined
        

; /* ���ж� */
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
        ; ��IRQ�ж�
        MRS     R0, SPSR
        ORR     R0, R0, #I_BIT
        MSR     SPSR_c, R0
        MOVS    PC, LR

IRQEnable
        ; ��IRQ�ж�
        MRS     R0, SPSR
        BIC     R0, R0, #I_BIT
        MSR     SPSR_c, R0
        MOVS    PC, LR
        
FIQDisable
        ; ��FIQ�ж�
        MRS     R0, SPSR
        ORR     R0, R0, #F_BIT
        MSR     SPSR_c, R0
        MOVS    PC, LR

FIQEnable
        ; ��FIQ�ж�
        MRS     R0, SPSR
        BIC     R0, R0, #F_BIT
        MSR     SPSR_c, R0
        MOVS    PC, LR

        
; /* ȡָ��ֹ */
PrefetchAbort
        B       PrefetchAbort

; /* ȡ������ֹ */
DataAbort
        B       DataAbort
        

; /* �����ж� */
FIQ_Handler
        STMFD   SP!, {R0-R3, LR}        
        BL      FIQ_Exception			; FIQ�жϴ���
        LDMFD   SP!, {R0-R3, LR}
        SUBS    PC,  LR,  #4                
                
        
        

;/*********************************************************************************************************
;** Function name: ResetInit
;** Descriptions: ��λ���
;** Input: ��
;** Output: ��
;** Created by: ������
;** Created Date: 2004-02-02
;**-------------------------------------------------------------------------------------------------------
;** Modified by: ���ܱ�
;** Modified Date: 2005-12-31 
;**------------------------------------------------------------------------------------------------------
;********************************************************************************************************/
ResetInit
        BL      InitStack               ; ��ʼ����ջ                                              
        BL      TargetBusInit           ; ����ϵͳ��ʼ�� (�����в������ջ����)
 		BL		TargetResetInit			; ���Ŀ����ϵͳ��ʼ�� 		  	 			
 		
 		MRC		p15,0,R1,c1,c0,0		; (MMU���ã��첽����ģʽ) �����ƼĴ���
		ORR		R1,R1,#0xC0000000	    ; ��HDIVN=1ʱ������Ч
		MRC		p15,0,R1,c1,c0,0
		
        B       __main					; ��ת��c�������  
        B       .                       ; ���main���أ�����ѭ�� 



;/*********************************************************************************************************
;** Function name: DisableMMU
;** Descriptions: ��ֹMMU
;** Input: ��
;** Output: ��
;** Created by: ���ܱ�
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
;** Descriptions: ʹ��ָ��CACHE
;** Input: ��
;** Output: ��
;** Created by: ���ܱ�
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
;** Descriptions: ��ָֹ��CACHE
;** Input: ��
;** Output: ��
;** Created by: ���ܱ�
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
;** Descriptions: ʹ������CACHE
;** Input: ��
;** Output: ��
;** Created by: ���ܱ�
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
;** Descriptions: ��ֹ����CACHE
;** Input: ��
;** Output: ��
;** Created by: ���ܱ�
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
;** Descriptions: ��ʼ����ջ
;** Input: ��
;** Output: ��
;** Created by: ������
;** Created Date: 2004-02-02
;**-------------------------------------------------------------------------------------------------------
;** Modified by: ���ܱ�
;** Modified Date: 2005-12-31 
;** Note: ��CPSR_c��ֵ���ú�ķ�ʽ
;**------------------------------------------------------------------------------------------------------
;********************************************************************************************************/
InitStack    
        MOV     R0, LR

; /* ���ù���ģʽ��ջ */
        MSR     CPSR_c, #(Mode_SVC | I_BIT | F_BIT) 	; 0xd3
        LDR     SP, StackSvc
; /* �����ж�ģʽ��ջ */
        MSR     CPSR_c, #(Mode_IRQ | I_BIT | F_BIT)		; 0xd2
        LDR     SP, StackIrq
; /* ���ÿ����ж�ģʽ��ջ */
        MSR     CPSR_c, #(Mode_FIQ | I_BIT | F_BIT)		; 0xd1
        LDR     SP, StackFiq
; /* ������ֹģʽ��ջ */
        MSR     CPSR_c, #(Mode_ABT | I_BIT | F_BIT)		; 0xd7
        LDR     SP, StackAbt
; /* ����δ����ģʽ��ջ */
        MSR     CPSR_c, #(Mode_UND | I_BIT | F_BIT)		; 0xdb
        LDR     SP, StackUnd
; /* ����ϵͳģʽ��ջ */
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
;** Descriptions: �⺯����ʼ���Ѻ�ջ������ɾ��
;** Input: �ο��⺯���ֲ�
;** Output: �ο��⺯���ֲ�
;** Created by: ������
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
;** Descriptions: ������������Ϊ0�������������ԭʼ��__rt_div0����Ŀ������С
;** Input: �ο��⺯���ֲ�
;** Output: ��
;** Created by: ������
;** Created Date: 2004-02-02
;**-------------------------------------------------------------------------------------------------------
;** Modified by: 
;** Modified Date: 
;**------------------------------------------------------------------------------------------------------
;********************************************************************************************************/
__rt_div0
        B       __rt_div0
        
        


; /* ����ѿռ� */
        AREA    Myheap, DATA, NOINIT, ALIGN=2
bottom_of_heap     SPACE   256  				;�⺯���Ķѿռ�			


; /* �����ջ�ռ� */
        AREA    MyStacks, DATA, NOINIT, ALIGN=2
UsrStackSpace      SPACE   USR_STACK_LEGTH * 4  ;�û���ϵͳ��ģʽ��ջ�ռ�
SvcStackSpace      SPACE   SVC_STACK_LEGTH * 4  ;����ģʽ��ջ�ռ�
IrqStackSpace      SPACE   IRQ_STACK_LEGTH * 4  ;�ж�ģʽ��ջ�ռ�
FiqStackSpace      SPACE   FIQ_STACK_LEGTH * 4  ;�����ж�ģʽ��ջ�ռ�
AbtStackSpace      SPACE   ABT_STACK_LEGTH * 4  ;��ֹ��ģʽ��ջ�ռ�
UndtStackSpace     SPACE   UND_STACK_LEGTH * 4  ;δ����ģʽ��ջ

		END
;/*********************************************************************************************************
;**                            End Of File
;********************************************************************************************************/
