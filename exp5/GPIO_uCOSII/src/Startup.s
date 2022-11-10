;/****************************************Copyright (c)**************************************************
;**                               Guangzhou ZHIYUAN electronics Co.,LTD.
;**                                     
;**                                 http://www.zyinside.com
;**
;**--------------File Info-------------------------------------------------------------------------------
;** File Name:          startup.s
;** Last modified Date: 2006-01-06 
;** Last Version:       v1.1
;** Descriptions:       S3C2410�쳣������ڼ��쳣������c���Դ���Ľӿڣ�������ʼ����ջ����ʼ��PLL�Ĵ���
;**
;**------------------------------------------------------------------------------------------------------
;** Created By:         ���ܱ�
;** Created date:       2005-11-11
;** Version:            v1.0
;** Descriptions:       ����
;**
;**------------------------------------------------------------------------------------------------------
;** Modified by:        �ʴ�
;** Modified date:      2006-01-06 
;** Version:            v1.1
;** Descriptions:       
;**
;**------------------------------------------------------------------------------------------------------
;** Modified by:      
;** Modified date:     
;** Version:           
;** Descriptions:      
;**
;********************************************************************************************************/
    IMPORT __use_no_semihosting_swi

; /* �����ջ�Ĵ�С */
; **** �û��ɸ���ʵ����Ҫ�޸� ****
SVC_STACK_LEGTH     EQU         16
FIQ_STACK_LEGTH     EQU         16
IRQ_STACK_LEGTH     EQU         9*8
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
I_BIT           EQU     0x80    ; when I bit is set (1), IRQ is disabled
F_BIT           EQU     0x40    ; when F bit is set (1), FIQ is disabled


; ���߿�ȿ��ƶ���(0��ʾ8λ��1��ʾ16λ��2��ʾ32λ)
DW8                 EQU         (0x0)
DW16                EQU         (0x1)
DW32                EQU         (0x2)
WAIT                EQU         (0x1<<2)
UBLB                EQU         (0x1<<3)

; **** �û��ɸ���ʵ����Ҫ�޸� ****
B7_BWCON            EQU         (DW16|WAIT|UBLB) 
B6_BWCON            EQU         (DW32|UBLB)  
B5_BWCON            EQU         (DW16|WAIT|UBLB)  
B4_BWCON            EQU         (DW16|WAIT|UBLB)  
B3_BWCON            EQU         (DW16|WAIT|UBLB)  
B2_BWCON            EQU         (DW16|WAIT|UBLB)  
B1_BWCON            EQU         (DW16|WAIT|UBLB)  


; CPUʱ������(PLLCON����ֵ)
; 50.00MHz (�ⲿ����Ϊ12MHzʱ)
MDIV_50             EQU     0x5C
PDIV_50             EQU     0x4
SDIV_50             EQU     0x2

; 200.00MHz (�ⲿ����Ϊ12MHzʱ) 
; ����ֵΪ��m=100,p=6,s=0, MPLL=FCLK=12*100/6=200MHz
MDIV_200            EQU     0x5C
PDIV_200            EQU     0x4
SDIV_200            EQU     0x0     
MPLLCON_200         EQU     ((MDIV_200 << 12) | (PDIV_200 << 4) | (SDIV_200)) 

; �Ĵ�������
;=================
; WATCH DOG TIMER
;=================
WTCON           EQU     0x53000000      ;Watch-dog timer mode
WTDAT           EQU     0x53000004      ;Watch-dog timer data
WTCNT           EQU     0x53000008      ;Eatch-dog timer count

;=================
; INTERRUPT
;=================
SRCPND          EQU     0x4a000000      ;Interrupt request status
INTMOD          EQU     0x4a000004      ;Interrupt mode control
INTMSK          EQU     0x4a000008      ;Interrupt mask control
PRIORITY        EQU     0x4a00000c      ;IRQ priority control  
INTPND          EQU     0x4a000010      ;Interrupt request status
INTOFFSET       EQU     0x4a000014      ;Interruot request source offset
SUSSRCPND       EQU     0x4a000018      ;Sub source pending
INTSUBMSK       EQU     0x4a00001c      ;Interrupt sub mask

;=================
; Memory control 
;=================
BWSCON          EQU     0x48000000     ;Bus width & wait status
BANKCON0        EQU     0x48000004     ;Boot ROM control
BANKCON1        EQU     0x48000008     ;BANK1 control
BANKCON2        EQU     0x4800000c     ;BANK2 cControl
BANKCON3        EQU     0x48000010     ;BANK3 control
BANKCON4        EQU     0x48000014     ;BANK4 control
BANKCON5        EQU     0x48000018     ;BANK5 control
BANKCON6        EQU     0x4800001c     ;BANK6 control
BANKCON7        EQU     0x48000020     ;BANK7 control
REFRESH         EQU     0x48000024     ;DRAM/SDRAM refresh
BANKSIZE        EQU     0x48000028     ;Flexible Bank Size
MRSRB6          EQU     0x4800002c     ;Mode register set for SDRAM
MRSRB7          EQU     0x48000030     ;Mode register set for SDRAM

;==========================
; CLOCK & POWER MANAGEMENT
;==========================
LOCKTIME        EQU     0x4c000000     ;PLL lock time counter
MPLLCON         EQU     0x4c000004     ;MPLL Control
UPLLCON         EQU     0x4c000008     ;UPLL Control
CLKCON          EQU     0x4c00000c     ;Clock generator control
CLKSLOW         EQU     0x4c000010     ;Slow clock control
CLKDIVN         EQU     0x4c000014     ;Clock divider control


; /************************************************************************/

; ������ⲿ�����������
        IMPORT  __main                          ;C������������� 
        IMPORT  SoftwareInterrupt
    

; ���ⲿʹ�õı����������
        EXPORT  Reset
        EXPORT  VICVectAddr
        EXPORT  bottom_of_heap
        EXPORT  StackUsr

        EXPORT  __user_initial_stackheap    
    

; /************************************************************************/
        CODE32
        AREA    vectors,CODE,READONLY
; �쳣������
Reset
        LDR     PC, ResetAddr
        LDR     PC, UndefinedAddr
        LDR     PC, SWI_Addr
        LDR     PC, PrefetchAddr
        LDR     PC, DataAbortAddr
        DCD     IRQ_Addr
        LDR     PC, IRQ_Addr
        LDR     PC, FIQ_Addr

ResetAddr           DCD     ResetInit
UndefinedAddr       DCD     Undefined
SWI_Addr            DCD     SoftwareInterrupt
PrefetchAddr        DCD     PrefetchAbort
DataAbortAddr       DCD     DataAbort
Nouse               DCD     0
IRQ_Addr            DCD     IRQ_Handler
FIQ_Addr            DCD     FIQ_Handler


; δ����ָ��
Undefined
        B       Undefined

SwiFunction
        DCD     IRQDisable       ;0
        DCD     IRQEnable        ;1
        DCD     FIQDisable       ;2
        DCD     FIQEnable        ;3

IRQDisable
        ;��IRQ�ж�
        MRS     R0, SPSR
        ORR     R0, R0, #I_BIT
        MSR     SPSR_c, R0
        MOVS    PC, LR

IRQEnable
        ;��IRQ�ж�
        MRS     R0, SPSR
        BIC     R0, R0, #I_BIT
        MSR     SPSR_c, R0
        MOVS    PC, LR
        
FIQDisable
        ;��FIQ�ж�
        MRS     R0, SPSR
        ORR     R0, R0, #F_BIT
        MSR     SPSR_c, R0
        MOVS    PC, LR

FIQEnable
        ;��FIQ�ж�
        MRS     R0, SPSR
        BIC     R0, R0, #F_BIT
        MSR     SPSR_c, R0
        MOVS    PC, LR

        
; ȡָ��ֹ
PrefetchAbort
        B       PrefetchAbort

; ȡ������ֹ
DataAbort
        B       DataAbort
        
; IRQ�ж�
NoInt       EQU 0x80

USR32Mode   EQU 0x10
SVC32Mode   EQU 0x13
SYS32Mode   EQU 0x1f
IRQ32Mode   EQU 0x12
FIQ32Mode   EQU 0x11


;������ⲿ�����������
        IMPORT  OSIntCtxSw                      ;�����л�����
        IMPORT  OSIntExit                       ;�ж��˳�����
        IMPORT  OSTCBCur
        IMPORT  OSTCBHighRdy
        IMPORT  OSIntNesting                    ;�ж�Ƕ�׼�����
        IMPORT  OsEnterSum


IRQ_Handler
        SUB     LR, LR, #4                      ; ���㷵�ص�ַ
        STMFD   SP!, {R0-R3, R12, LR}           ; �������񻷾�
        MRS     R3, SPSR                        ; ����״̬
        STMFD   SP, {R3, SP, LR}^               ; �����û�״̬��R3,SP,LR,ע�ⲻ�ܻ�д
                                                ; �����д�����û���SP�����Ժ���Ҫ����SP
        LDR     R2,  =OSIntNesting              ; OSIntNesting++
        LDRB    R1, [R2]
        ADD     R1, R1, #1
        STRB    R1, [R2]

        SUB     SP, SP, #4*3
        
        MSR     CPSR_c, #(NoInt | SYS32Mode)    ; �л���ϵͳģʽ
        CMP     R1, #1
        LDREQ   SP, =StackUsr
        

        LDR     R0, =INTPND
        LDR     R1, [R0]                        ; ��ȡINTPND��ֵ

        ; �ҳ���ǰ�жϺ�(INTPND)
        MOV     R0, #0       
FIND_NO 
        MOVS    R1, R1, LSR #1
        ADDNE   R0, R0, #1
        BNE     FIND_NO
FIND_END

        LDR     R1, =VICVectAddr 
        MOV     LR, PC                          ; ���淵�ص�ַ
        LDR     PC, [R1, R0, LSL #2]            ; ��ת����Ӧ�жϷ������        

        MSR     CPSR_c, #(NoInt | SYS32Mode)    ; �л���ϵͳģʽ
        LDR     R2, =OsEnterSum                 ; OsEnterSum,ʹOSIntExit�˳�ʱ�жϹر�
        MOV     R1, #1
        STR     R1, [R2]

        BL      OSIntExit

        LDR     R2, =OsEnterSum                 ; ��Ϊ�жϷ������Ҫ�˳�������OsEnterSum=0
        MOV     R1, #0
        STR     R1, [R2]

        MSR     CPSR_c, #(NoInt | IRQ32Mode)    ; �л���irqģʽ
        LDMFD   SP, {R3, SP, LR}^               ; �ָ��û�״̬��R3,SP,LR,ע�ⲻ�ܻ�д
                                                ; �����д�����û���SP�����Ժ���Ҫ����SP
        LDR     R0, =OSTCBHighRdy
        LDR     R0, [R0]
        LDR     R1, =OSTCBCur
        LDR     R1, [R1]
        CMP     R0, R1

        ADD     SP, SP, #4*3                    ; 
        MSR     SPSR_cxsf, R3
        LDMEQFD SP!, {R0-R3, R12, PC}^          ; �����������л�
        LDR     PC, =OSIntCtxSw                 ; ���������л�


; �����ж�
FIQ_Handler
        STMFD   SP!, {R0-R3, LR}        
        ; /* FIQ�жϴ��� */        
        LDMFD   SP!, {R0-R3, LR}
        SUBS    PC,  LR,  #4                
                
        
        
;/*********************************************************************************************************
;** ��������: Reset
;** ��������: ��λ���
;** �䡡��: ��
;** �䡡��: ��
;********************************************************************************************************/
ResetInit
        BL      InitStack               ; ��ʼ����ջ                                              
        BL      TargetInitReset         ; ���Ŀ����ϵͳ��ʼ��        
        BL      Remap                   ; ��ӳ�����
        B       __main                  ; ��ת��c�������  


;/*********************************************************************************************************
;** ��������: Remap
;** ��������: ��ӳ�������������
;** �䡡��: ��
;** �䡡��: ��
;** ˵�������������Ƶ�0x0000000��ַ������Ҫ��ϵͳΪNAND Flash������ʽ��
;**       ռ��R0--R9�Ĵ�����
;********************************************************************************************************/ 
Remap
    IF :DEF: Release
        MOV     PC, LR
    ELSE        
        MOV     R0, #0x00000000
        LDR     R1, =Reset
        LDMIA   R1!, {R2-R9}
        STMIA   R0!, {R2-R9}
        LDMIA   R1!, {R2-R9}
        STMIA   R0!, {R2-R9}     
        MOV     PC, LR
    ENDIF       
 
;/*********************************************************************************************************
;** ��������: TargetInitReset
;** ��������: ���Ŀ����ϵͳ��ʼ��������WDT���жϡ�PLL��SDRAM�������ȵȡ�
;** �䡡��: ��
;** �䡡��: ��
;** ˵����ռ��R0--R8�Ĵ���
;********************************************************************************************************/ 
TargetInitReset
        LDR     R0, =WTCON                  ; �ر�WDT 
        LDR     R1, =0x0000         
        STR     R1,[R0]                     ; WTCON=0x0000

        LDR     R0, =INTMSK                 ; ��ֹ�����ж� (�жϿ�����)
        LDR     R1, =0xFFFFFFFF  
        STR     R1, [R0]                    ; INTMSK=0xFFFFFFFF

        LDR     R0, =INTSUBMSK
        LDR     R1, =0x07FF                 ; INTSUBMSK=0x07FF
        STR     R1, [R0]
        
        LDR     R0, =SRCPND                 ; ����жϱ�־ (add)
        LDR     R1, =0xFFFFFFFF
        STR     R1, [R0]
        
        LDR     R0, =INTPND      
        LDR     R1, =0xFFFFFFFF  
        STR     R1, [R0]
        
    IF :DEF: Release    
        ; ϵͳʱ�����ã�����PLL
        LDR     R0, =LOCKTIME
        LDR     R1, =0x00FFFFFF             ; ����ʱ������U_LTIME=0xFFF��M_LTIME=0xFFF
        STR     R1, [R0]
        
        LDR     R0, =CLKDIVN     
        MOV     R1, #0x03                   ; HCLK=FCLK/2��PCLK=HCLK/2
        STR     R1, [R0]             
        
        MRC     p15, 0, R1, c1, c0, 0       ; (MMU����) �����ƼĴ��� 
        ORR     R1, R1, #0xC0000000   
        MRC     p15, 0, R1, c1, c0, 0    

        LDR     R0, =MPLLCON     
        LDR     R1, =MPLLCON_200            ; ����CPUʱ��Ϊ200Mhz (FCLK)
        STR     R1, [R0]                             
            
        ; �������ã���ʼ��SDRAM
        LDR     R0, =BUS_INIT
        LDR     R1, =BWSCON
        LDMIA   R0!, {R2-R8}
        STMIA   R1!, {R2-R8}
        LDMIA   R0!, {R2-R7}
        STMIA   R1!, {R2-R7}         
    ENDIF                                           
    
        MOV     PC, LR               ; ����
        
; �����������ݱ�        
BUS_INIT    DCD (B7_BWCON<<28)|(B6_BWCON<<24)|(B5_BWCON<<20)|(B4_BWCON<<16) \
                              |(B3_BWCON<<12)|(B2_BWCON<<8)|(B1_BWCON<<4)   ; BWSCON  �Ĵ���
            DCD (1<<13)|(1<<11)|(7<<8)|(1<<6)|(1<<4)|(1<<2)|(0<<0)          ; BANKCON0�Ĵ���
            DCD (1<<13)|(1<<11)|(7<<8)|(1<<6)|(1<<4)|(1<<2)|(0<<0)          ; BANKCON1�Ĵ���    
            DCD (1<<13)|(1<<11)|(7<<8)|(1<<6)|(1<<4)|(1<<2)|(0<<0)          ; BANKCON2�Ĵ���
            DCD (1<<13)|(1<<11)|(7<<8)|(1<<6)|(1<<4)|(1<<2)|(0<<0)          ; BANKCON3�Ĵ���
            DCD (1<<13)|(1<<11)|(7<<8)|(1<<6)|(1<<4)|(1<<2)|(0<<0)          ; BANKCON4�Ĵ���
            DCD (1<<13)|(1<<11)|(7<<8)|(1<<6)|(1<<4)|(1<<2)|(0<<0)          ; BANKCON5�Ĵ���
            DCD (3<<15)|(1<<2)|(1<<0)                                       ; BANKCON6�Ĵ���(SDRAM)
            DCD (0<<15)|(1<<13)|(1<<11)|(7<<8)|(1<<6)|(1<<4)|(1<<2)|(0<<0)  ; BANKCON7�Ĵ���(SRAM )
            DCD (1<<23)|(0<<22)|(0<<20)|(3<<18)|(1113)                      ; REFRESH �Ĵ���(SDRAM) ��period=15.6us, HCLK=60Mhz, (2048+1-15.6*60)
            DCD (1<<7)|(1<<5)|(1<<4)|(2<<0)                                 ; BANKSIZE�Ĵ���(128MB)
            DCD (3<<4)                                                      ; MRSRB6  �Ĵ���
            DCD (3<<4)                                                      ; MRSRB7  �Ĵ���
               
               
;/*********************************************************************************************************
;** ��������: InitStack
;** ��������: ��ʼ����ջ����󷵻�ʱ��������������ϵͳģʽ��
;** �䡡��:   ��
;** �䡡��:   ��
;** ˵  ��:   �ɱ��ļ���ͷ��USR_STACK_LEGTH��SVC_STACK_LEGTH�ȶ��������ģʽ�Ķ�ջ��С��
;********************************************************************************************************/
InitStack    
        MOV     R0, LR

;���ù���ģʽ��ջ
        MSR     CPSR_c, #(Mode_SVC | I_BIT | F_BIT)     ; 0xd3
        LDR     SP, StackSvc
;�����ж�ģʽ��ջ
        MSR     CPSR_c, #(Mode_IRQ | I_BIT | F_BIT)     ; 0xd2
        LDR     SP, StackIrq
;���ÿ����ж�ģʽ��ջ
        MSR     CPSR_c, #(Mode_FIQ | I_BIT | F_BIT)     ; 0xd1
        LDR     SP, StackFiq
;������ֹģʽ��ջ
        MSR     CPSR_c, #(Mode_ABT | I_BIT | F_BIT)     ; 0xd7
        LDR     SP, StackAbt
;����δ����ģʽ��ջ
        MSR     CPSR_c, #(Mode_UND | I_BIT | F_BIT)     ; 0xdb
        LDR     SP, StackUnd
;����ϵͳģʽ��ջ
        MSR     CPSR_c, #(Mode_SYS | I_BIT | F_BIT)     ; 0xdf
        LDR     SP, =StackUsr

        MOV     PC, R0

StackSvc           DCD     SvcStackSpace + (SVC_STACK_LEGTH - 1)* 4
StackIrq           DCD     IrqStackSpace + (IRQ_STACK_LEGTH - 1)* 4
StackFiq           DCD     FiqStackSpace + (FIQ_STACK_LEGTH - 1)* 4
StackAbt           DCD     AbtStackSpace + (ABT_STACK_LEGTH - 1)* 4
StackUnd           DCD     UndtStackSpace + (UND_STACK_LEGTH - 1)* 4

    
;/*********************************************************************************************************
;** ��������: __user_initial_stackheap 
;** ��������: �⺯����ʼ���Ѻ�ջ������ɾ��
;** �䡡��: �ο��⺯���ֲ�
;** �䡡��: �ο��⺯���ֲ�
;********************************************************************************************************/
__user_initial_stackheap    
    LDR   r0, =bottom_of_heap
    MOV   pc, lr

; /* �����ջ�ռ� */
        AREA    MyStacks, DATA, NOINIT, ALIGN=2
SvcStackSpace      SPACE   SVC_STACK_LEGTH * 4  ;����ģʽ��ջ�ռ�
IrqStackSpace      SPACE   IRQ_STACK_LEGTH * 4  ;�ж�ģʽ��ջ�ռ�
FiqStackSpace      SPACE   FIQ_STACK_LEGTH * 4  ;�����ж�ģʽ��ջ�ռ�
AbtStackSpace      SPACE   ABT_STACK_LEGTH * 4  ;��ֹ��ģʽ��ջ�ռ�
UndtStackSpace     SPACE   UND_STACK_LEGTH * 4  ;δ����ģʽ��ջ

; /* IRQ�ж�������ַ���� */
VICVectAddr        SPACE   32*4  

        AREA    Heap, DATA, READWRITE
bottom_of_heap    SPACE   1

        AREA    Stacks, DATA, NOINIT
StackUsr
        END
;/*********************************************************************************************************
;**                            End Of File
;********************************************************************************************************/
