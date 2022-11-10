/****************************************Copyright (c)**************************************************
**                               Guangzhou ZHIYUAN electronics Co.,LTD.
**                                     
**                                 http://www.zyinside.com
**
**--------------File Info-------------------------------------------------------------------------------
** File Name:          main.c
** Last modified Date: 2006-01-11 
** Last Version:       v1.0
** Descriptions:       ������
**
**------------------------------------------------------------------------------------------------------
** Modified by:        �ʴ�
** Modified date:      2006-01-06
** Version:            v1.0
** Descriptions:       ����
**
**------------------------------------------------------------------------------------------------------
** Modified by:      
** Modified date:     
** Version:           
** Descriptions:      
**
********************************************************************************************************/
#include "config.h"

#define	Task0StkLengh	64              // Define the Task0 stack length �����û�����0�Ķ�ջ����
#define	Task1StkLengh	64              // Define the Task1 stack length �����û�����1�Ķ�ջ����
#define	Task2StkLengh	64              // Define the Task1 stack length �����û�����2�Ķ�ջ����
#define	Task3StkLengh	64              // Define the Task1 stack length �����û�����3�Ķ�ջ����

OS_STK	Task0Stk [Task0StkLengh];       // Define the Task0 stack �����û�����0�Ķ�ջ
OS_STK	Task1Stk [Task1StkLengh];       // Define the Task1 stack �����û�����1�Ķ�ջ
OS_STK	Task2Stk [Task2StkLengh];       // Define the Task2 stack �����û�����2�Ķ�ջ
OS_STK	Task3Stk [Task3StkLengh];       // Define the Task3 stack �����û�����3�Ķ�ջ

// �����������KEY1�������
#define  	KEY_CON		   	(1<<4)      /* GPF4��  */

// ������������ƿ�
#define   	BEEP		   	(1<<10)     /* GPH10�� */	
#define   	BEEP_MASK	  	(~BEEP)

// ����LED���ƿ� (����ߵ�ƽʱ����LED)
#define  LED1_CON       (1<<11)     /* GPE11�� */
#define  LED2_CON       (1<<12)     /* GPE12�� */
#define  LED3_CON       (1<<4)      /* GPH4��  */
#define  LED4_CON       (1<<6)      /* GPH6��  */

// ����������ƿ��߼������꺯������
#define   MOTOA	    (1<<5)              /* GPC5  */
#define   MOTOB		(1<<6)  	        /* GPC6  */
#define   MOTOC 	(1<<7)  	        /* GPC7  */
#define   MOTOD		(1<<0)		        /* GPC0  */

#define   GPIOSET(PIN)  rGPCDAT = rGPCDAT | PIN         /* ����PIN���1��PINΪMOTOA--MOTOD */
#define   GPIOCLR(PIN)  rGPCDAT = rGPCDAT & (~PIN)      /* ����PIN���0��PINΪMOTOA--MOTOD */


// ����״̬
uint8   KeyState = FALSE;
uint8   i = 0;

void 	Task0(void *pdata);			    // Task0 ����0
void 	Task1(void *pdata);			    // Task1 ����1
void 	Task2(void *pdata);			    // Task2 ����2
void 	Task3(void *pdata);			    // Task3 ����3
void    RunBeep(void);


/************************************************************************************
** Function name: main
** Descriptions:  ��������uCOS/II��ֲʵ�鷶��
** Input:         �� 
** Output:        ϵͳ����ֵ0
** Created by:   
** Created Date:  2006-01-12
**----------------------------------------------------------------------------------
** Modified by:
** Modified Date: 
**----------------------------------------------------------------------------------
************************************************************************************/
int main (void) {
	OSInit();																										
	OSTaskCreate(Task0, (void *)0, &Task0Stk[Task0StkLengh - 1], 2);
	OSTaskCreate(Task1, (void *)0, &Task1Stk[Task1StkLengh - 1], 3);
	OSTaskCreate(Task2, (void *)0, &Task2Stk[Task2StkLengh - 1], 4);
	OSTaskCreate(Task3, (void *)0, &Task3Stk[Task3StkLengh - 1], 5);
	OSStart();
	return 0;															
}

/************************************************************************************
** Function name: Task0
** Descriptions:  ��ȡ����KEY1״̬
************************************************************************************/
void Task0(void *pdata) {
	pdata = pdata;
	TargetInit ();
	
   	// ��ʼ��I/O
    rGPFCON = (rGPFCON & (~(0x03<<8))); // rGPFCON[9:8] = 00b������GPF4ΪGPIO����ģʽ			
    rGPHCON = (rGPHCON & (~(0x03<<20))) | (0x01<<20);// rGPHCON[21:20] = 01b������GPH10ΪGPIO���ģʽ 	
    	// ����������ƿ�����    
    rGPCCON = (rGPCCON & (~0x0000FC03)) | (0x00005401);	// GPC0��GPC5--7������Ϊ���
    rGPCUP  = rGPCUP | 0x00E1;      // ��ֹGPC0��GPC5--7�ڵ���������
    rGPCDAT = rGPCDAT & (~0x00E1);  // ����GPC0��GPC5--7������͵�ƽ 	
    	    // ��ʼ��I/O
    rGPECON = (rGPECON & (~(0x0F<<22))) | (0x05<<22);   // rGPECON[25:22] = 0101b������GPE11��GPE12ΪGPIO���ģʽ
    rGPHCON = (rGPHCON & (~(0x33<<8))) | (0x11<<8);     // rGPHCON[13:8] = 01xx01b������GPH4��GPH6ΪGPIO���ģʽ	

	while (1) {
    	if(rGPFDAT & KEY_CON) KeyState = FALSE;  // ��ȡGPF�����ϵĵ�ƽ���ж�GPF4�Ƿ�Ϊ�ߵ�ƽ
    	else {
            OSTimeDly(OS_TICKS_PER_SEC/10);
    	    if (rGPFDAT & KEY_CON) KeyState = FALSE;  // ������
    	    else KeyState = TRUE;
    	}
        OSTimeDly(OS_TICKS_PER_SEC/10);
	}
}

/************************************************************************************
** Function name: Task1
** Descriptions:  �ȴ����������Ʒ�������
************************************************************************************/
void Task1(void *pdata) {   
	pdata = pdata;
	
	while (1) {
	    if(TRUE == KeyState) {;  // ����а������£������
	    	rGPHDAT = rGPHDAT & BEEP_MASK;	 	// BEEP = 0
    		OSTimeDly(OS_TICKS_PER_SEC/10);
   			rGPHDAT = rGPHDAT | BEEP;           // BEEP = 1 
    		OSTimeDly(OS_TICKS_PER_SEC/10);
	    }
        OSTimeDly(OS_TICKS_PER_SEC/10);
	}
}


/************************************************************************************
** Function name: Task2
** Descriptions:  LED
************************************************************************************/
void Task2(void *pdata) {   
	pdata = pdata;
	
	while (1) {
		if (i > 15) i = 0;
		
	    i = i & 0x0000000F;     // ��������

	    // ����LED4��LED3��ʾ(d3��d2λ)
	    if(i & 0x08) rGPHDAT = rGPHDAT | (0x01<<6);
	    else  rGPHDAT = rGPHDAT & (~(0x01<<6)); 
	    if(i & 0x04) rGPHDAT = rGPHDAT | (0x01<<4);
	    else  rGPHDAT = rGPHDAT & (~(0x01<<4)); 
	        
	    // ����LED2��LED1��ʾ(d1��d0λ)
	    rGPEDAT = (rGPEDAT & (~(0x03<<11))) | ((i&0x03) << 11); 
		
	    i++;
	    OSTimeDly(OS_TICKS_PER_SEC/10);
	}
	
}

/************************************************************************************
** Function name: Task3
** Descriptions:  Motor
************************************************************************************/
void Task3(void *pdata) {   
	pdata = pdata;
	
	while (1) {   
	    // AB����Ч 
        GPIOSET(MOTOA);
        GPIOSET(MOTOB);
        OSTimeDly(OS_TICKS_PER_SEC/10);
        GPIOCLR(MOTOA);
        GPIOCLR(MOTOB);
        
        // BC����Ч 
        GPIOSET(MOTOB);
        GPIOSET(MOTOC);
        OSTimeDly(OS_TICKS_PER_SEC/10);
        GPIOCLR(MOTOB);
        GPIOCLR(MOTOC);

        // CD����Ч 
        GPIOSET(MOTOC);
        GPIOSET(MOTOD);
        OSTimeDly(OS_TICKS_PER_SEC/10);
        GPIOCLR(MOTOC);
        GPIOCLR(MOTOD);
        
        // DA����Ч 
        GPIOSET(MOTOD);            
        GPIOSET(MOTOA);
        OSTimeDly(OS_TICKS_PER_SEC/10);
        GPIOCLR(MOTOD);
        GPIOCLR(MOTOA);
	}
}

