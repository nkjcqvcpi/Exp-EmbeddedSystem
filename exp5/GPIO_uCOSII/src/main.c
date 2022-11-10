/****************************************Copyright (c)**************************************************
**                               Guangzhou ZHIYUAN electronics Co.,LTD.
**                                     
**                                 http://www.zyinside.com
**
**--------------File Info-------------------------------------------------------------------------------
** File Name:          main.c
** Last modified Date: 2006-01-11 
** Last Version:       v1.0
** Descriptions:       主程序
**
**------------------------------------------------------------------------------------------------------
** Modified by:        甘达
** Modified date:      2006-01-06
** Version:            v1.0
** Descriptions:       创建
**
**------------------------------------------------------------------------------------------------------
** Modified by:      
** Modified date:     
** Version:           
** Descriptions:      
**
********************************************************************************************************/
#include "config.h"

#define	Task0StkLengh	64              // Define the Task0 stack length 定义用户任务0的堆栈长度
#define	Task1StkLengh	64              // Define the Task1 stack length 定义用户任务1的堆栈长度
#define	Task2StkLengh	64              // Define the Task1 stack length 定义用户任务2的堆栈长度
#define	Task3StkLengh	64              // Define the Task1 stack length 定义用户任务3的堆栈长度

OS_STK	Task0Stk [Task0StkLengh];       // Define the Task0 stack 定义用户任务0的堆栈
OS_STK	Task1Stk [Task1StkLengh];       // Define the Task1 stack 定义用户任务1的堆栈
OS_STK	Task2Stk [Task2StkLengh];       // Define the Task2 stack 定义用户任务2的堆栈
OS_STK	Task3Stk [Task3StkLengh];       // Define the Task3 stack 定义用户任务3的堆栈

// 定义独立按键KEY1的输入口
#define  	KEY_CON		   	(1<<4)      /* GPF4口  */

// 定义蜂鸣器控制口
#define   	BEEP		   	(1<<10)     /* GPH10口 */	
#define   	BEEP_MASK	  	(~BEEP)

// 定义LED控制口 (输出高电平时点亮LED)
#define  LED1_CON       (1<<11)     /* GPE11口 */
#define  LED2_CON       (1<<12)     /* GPE12口 */
#define  LED3_CON       (1<<4)      /* GPH4口  */
#define  LED4_CON       (1<<6)      /* GPH6口  */

// 步进电机控制口线及操作宏函数定义
#define   MOTOA	    (1<<5)              /* GPC5  */
#define   MOTOB		(1<<6)  	        /* GPC6  */
#define   MOTOC 	(1<<7)  	        /* GPC7  */
#define   MOTOD		(1<<0)		        /* GPC0  */

#define   GPIOSET(PIN)  rGPCDAT = rGPCDAT | PIN         /* 设置PIN输出1，PIN为MOTOA--MOTOD */
#define   GPIOCLR(PIN)  rGPCDAT = rGPCDAT & (~PIN)      /* 设置PIN输出0，PIN为MOTOA--MOTOD */


// 按键状态
uint8   KeyState = FALSE;
uint8   i = 0;

void 	Task0(void *pdata);			    // Task0 任务0
void 	Task1(void *pdata);			    // Task1 任务1
void 	Task2(void *pdata);			    // Task2 任务2
void 	Task3(void *pdata);			    // Task3 任务3
void    RunBeep(void);


/************************************************************************************
** Function name: main
** Descriptions:  主函数，uCOS/II移植实验范例
** Input:         无 
** Output:        系统返回值0
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
** Descriptions:  读取按键KEY1状态
************************************************************************************/
void Task0(void *pdata) {
	pdata = pdata;
	TargetInit ();
	
   	// 初始化I/O
    rGPFCON = (rGPFCON & (~(0x03<<8))); // rGPFCON[9:8] = 00b，设置GPF4为GPIO输入模式			
    rGPHCON = (rGPHCON & (~(0x03<<20))) | (0x01<<20);// rGPHCON[21:20] = 01b，设置GPH10为GPIO输出模式 	
    	// 步进电机控制口设置    
    rGPCCON = (rGPCCON & (~0x0000FC03)) | (0x00005401);	// GPC0、GPC5--7口设置为输出
    rGPCUP  = rGPCUP | 0x00E1;      // 禁止GPC0、GPC5--7口的上拉电阻
    rGPCDAT = rGPCDAT & (~0x00E1);  // 设置GPC0、GPC5--7口输出低电平 	
    	    // 初始化I/O
    rGPECON = (rGPECON & (~(0x0F<<22))) | (0x05<<22);   // rGPECON[25:22] = 0101b，设置GPE11、GPE12为GPIO输出模式
    rGPHCON = (rGPHCON & (~(0x33<<8))) | (0x11<<8);     // rGPHCON[13:8] = 01xx01b，设置GPH4、GPH6为GPIO输出模式	

	while (1) {
    	if(rGPFDAT & KEY_CON) KeyState = FALSE;  // 读取GPF口线上的电平，判断GPF4是否为高电平
    	else {
            OSTimeDly(OS_TICKS_PER_SEC/10);
    	    if (rGPFDAT & KEY_CON) KeyState = FALSE;  // 防抖动
    	    else KeyState = TRUE;
    	}
        OSTimeDly(OS_TICKS_PER_SEC/10);
	}
}

/************************************************************************************
** Function name: Task1
** Descriptions:  等待按键，控制蜂鸣器响
************************************************************************************/
void Task1(void *pdata) {   
	pdata = pdata;
	
	while (1) {
	    if(TRUE == KeyState) {;  // 如果有按键按下，则蜂鸣
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
		
	    i = i & 0x0000000F;     // 参数过滤

	    // 控制LED4、LED3显示(d3、d2位)
	    if(i & 0x08) rGPHDAT = rGPHDAT | (0x01<<6);
	    else  rGPHDAT = rGPHDAT & (~(0x01<<6)); 
	    if(i & 0x04) rGPHDAT = rGPHDAT | (0x01<<4);
	    else  rGPHDAT = rGPHDAT & (~(0x01<<4)); 
	        
	    // 控制LED2、LED1显示(d1、d0位)
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
	    // AB相有效 
        GPIOSET(MOTOA);
        GPIOSET(MOTOB);
        OSTimeDly(OS_TICKS_PER_SEC/10);
        GPIOCLR(MOTOA);
        GPIOCLR(MOTOB);
        
        // BC相有效 
        GPIOSET(MOTOB);
        GPIOSET(MOTOC);
        OSTimeDly(OS_TICKS_PER_SEC/10);
        GPIOCLR(MOTOB);
        GPIOCLR(MOTOC);

        // CD相有效 
        GPIOSET(MOTOC);
        GPIOSET(MOTOD);
        OSTimeDly(OS_TICKS_PER_SEC/10);
        GPIOCLR(MOTOC);
        GPIOCLR(MOTOD);
        
        // DA相有效 
        GPIOSET(MOTOD);            
        GPIOSET(MOTOA);
        OSTimeDly(OS_TICKS_PER_SEC/10);
        GPIOCLR(MOTOD);
        GPIOCLR(MOTOA);
	}
}

