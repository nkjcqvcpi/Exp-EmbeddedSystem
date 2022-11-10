/****************************************Copyright (c)**************************************************
**                               Guangzhou ZHIYUAN electronics Co.,LTD.
**                                     
**                                 http://www.zyinside.com
**
**--------------File Info-------------------------------------------------------------------------------
** File Name: main.c
** Last modified Date: 2006-01-05
** Last Version: v1.0
** Description: MagicARM2410ʵ����Ļ���ʵ��---GPIO����ʵ�顣
**              ʹ��GPIO����ģʽ��GPF4�ڽ���ɨ�裬�Է��������ơ�
**------------------------------------------------------------------------------------------------------
** Created By: ���ܱ�
** Created date: 2006-01-05
** Version: v1.0
** Descriptions:
**
**------------------------------------------------------------------------------------------------------
** Modified by:
** Modified date:
** Version:
** Description:
**
********************************************************************************************************/
#include  "config.h"

// �����������KEY1�������
#define     KEY_CON		    (1<<4)          /* GPF4��  */

// ������������ƿ�
#define   	BEEP		   	(1<<10)     	/* GPH10�� */	
#define   	BEEP_MASK	  	(~BEEP)


/*********************************************************************************************************
** Function name: DelayNS
** Descriptions: ��������ʱ��
**              ��ʱʱ����ϵͳʱ���йء�
** Input: dly	��ʱ������ֵԽ����ʱԽ��
** Output: ��
** Created by: ���ܱ�
** Created Date: 2005-12-31 
**-------------------------------------------------------------------------------------------------------
** Modified by:
** Modified Date: 
**------------------------------------------------------------------------------------------------------
********************************************************************************************************/
void  DelayNS(uint32  dly)
{  
	uint32  i;

   	for(; dly>0; dly--) 
       for(i=0; i<50000; i++);
}



/*********************************************************************************************************
** Function name: main
** Descriptions: ���ϵض�ȡGPF4�ڵ�ֵ����������Ʒ�����B1��           
** Input: ��
** Output: ϵͳ����ֵ0
** Created by: ���ܱ�
** Created Date: 2005-12-31 
**-------------------------------------------------------------------------------------------------------
** Modified by:
** Modified Date: 
**------------------------------------------------------------------------------------------------------
********************************************************************************************************/
int  main(void)
{	
    // ��ʼ��I/O
    rGPFCON = (rGPFCON & (~(0x03<<8)));                 // rGPFCON[9:8] = 00b������GPF4ΪGPIO����ģʽ   
    rGPHCON = (rGPHCON & (~(0x03<<20))) | (0x01<<20);   // rGPHCON[21:20] = 01b������GPH10ΪGPIO���ģʽ 												
    
    while(1)
    {
        if(rGPFDAT & KEY_CON)   // ��ȡGPF�����ϵĵ�ƽ���ж�GPF4�Ƿ�Ϊ�ߵ�ƽ
        {
            rGPHDAT = rGPHDAT | BEEP;       // GPF4Ϊ�ߵ�ƽ��������GPH10=1
        }
        else
        {
            rGPHDAT = rGPHDAT & BEEP_MASK;  // GPF4Ϊ�͵�ƽ��������GPH10=0
        }
        
        DelayNS(1);
    }
    	
   	return(0);
}

/*********************************************************************************************************
**                            End Of File
********************************************************************************************************/