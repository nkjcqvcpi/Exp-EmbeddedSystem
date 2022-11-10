/****************************************Copyright (c)**************************************************
**                               Guangzhou ZHIYUAN electronics Co.,LTD.
**                                     
**                                 http://www.zyinside.com
**
**--------------File Info-------------------------------------------------------------------------------
** File Name: config.h
** Last modified Date: 2005-12-31 
** Last Version: v1.0
** Descriptions: 用户配置头文件
**
**------------------------------------------------------------------------------------------------------
** Created By: 黄绍斌
** Created date: 2005-12-31 
** Version: v1.0
** Descriptions:
**
**------------------------------------------------------------------------------------------------------
** Modified by:
** Modified date:
** Version:
** Descriptions:
**
********************************************************************************************************/
#ifndef __CONFIG_H 
#define __CONFIG_H


//------------------------------------------------------------------------------------------------------

/********************************************************************************************************
**                  "以下为系统配置"
**                  system configs in here
********************************************************************************************************/
// 这一段无需改动
#ifndef TRUE
#define TRUE  		1
#endif

#ifndef FALSE
#define FALSE 		0
#endif

#ifndef NULL
#define NULL  		(void *)0
#endif

typedef unsigned char  	uint8;          /* 无符号8位整型变量            	*/
typedef signed   char  	int8;           /* 有符号8位整型变量            	*/
typedef unsigned short 	uint16;         /* 无符号16位整型变量               */
typedef signed   short 	int16;          /* 有符号16位整型变量               */
typedef unsigned int   	uint32;         /* 无符号32位整型变量               */
typedef signed   int   	int32;          /* 有符号32位整型变量               */
typedef float          	fp32;           /* 单精度浮点数（32位长度）         */
typedef double         	fp64;           /* 双精度浮点数（64位长度）         */



/*********************************************************************************************************
**                  "以下为程序配置"         
**                  project configs in here
********************************************************************************************************/
// 这一段无需改动
#include    "S3C2410.h"
#include    "target.h"
#include    "UART.h"
#include    "LCDDRIVE.h"

#include    <stdio.h>
#include    <ctype.h>
#include    <stdlib.h>

// IRQ中断向量地址表
extern  uint32 VICVectAddr[];

// 使能/禁能IRQ、FIQ中断
__swi(0x00) void SwiHandle1(int Handle);

#define IRQDisable()    SwiHandle1(0)
#define IRQEnable()     SwiHandle1(1)
#define FIQDisable()    SwiHandle1(2)
#define FIQEnable()     SwiHandle1(3)

/* CPU时钟设置(PLLCON控制值) */
/* 50.00MHz (外部晶振为12MHz时) */
#define  	MDIV_50			0x5C
#define  	PDIV_50			0x4
#define  	SDIV_50			0x2

/* 200.00MHz (外部晶振为12MHz时) */
/* 设置值为：m=100,p=6,s=0, MPLL=FCLK=12*100/6=200MHz */
#define  	MDIV_200		0x5C
#define  	PDIV_200		0x4
#define  	SDIV_200		0x0		
#define  	MPLLCON_200		((MDIV_200 << 12) | (PDIV_200 << 4) | (SDIV_200)) 

/* 系统时钟宏定义 */
#define     FCLK		(200*1000000)	/* 系统时钟，由target.c文件的TargetResetInit()设置 */	
#define     HCLK		(FCLK/2)		/* HCLK只能为FCLK除上1、2 */
#define     PCLK		(HCLK/2)		/* PCLK只能为HCLK除上1、2 */


/* 总线宽度控制定义(0表示8位，1表示16位，2表示32位) */
#define  	DW8			(0x0)
#define  	DW16		(0x1)
#define  	DW32		(0x2)
#define  	WAIT		(0x1<<2)
#define  	UBLB		(0x1<<3)

/* Bank时序控制(位域)定义 */
#define     MT			15			/* 存储类型选择，仅对Bank6和Bank7有效 (2bit) */
#define     Trcd		 2			/* RAS到CAS延迟，仅对SDRAM有效 (2bit) */
#define     SCAN		 0			/* 列地址位数，仅对SDRAM有效 (2bit) */

#define     Tacs		13			/* 在nGCSn有效之前，地址信号的建立时间 (2bit) */
#define     Tcos		11			/* 在nOE有效之前，片选的建立时间 (2bit) */
#define     Tacc		 8			/* 访问周期 (3bit) */
#define     Tcoh		 6			/* nOE结束之后，片选信号的保持时间 (2bit) */
#define     Tcah		 4			/* nGCSn结束之后，地址信号的保持时间 (2bit) */
#define     Tacp		 2			/* Page模式的访问周期 (2bit) */
#define     PMC			 0			/* Page模式配置 (2bit) */



/*********************************************************************************************************
**                  "以下为应用程序配置"         
**                  project configs in here
********************************************************************************************************/
// 以下根据需要改动

/**** 外部总线配置，用户可根据实际需要修改 ****/
#define  	B7_BWCON	(DW16|WAIT|UBLB) 
#define  	B6_BWCON	(DW32|UBLB) 	/* SDRAM所用的Bank，不要修改 */ 
#define  	B5_BWCON	(DW16|WAIT|UBLB)  
#define  	B4_BWCON	(DW16|WAIT|UBLB)  
#define  	B3_BWCON	(DW16|WAIT|UBLB)  
#define  	B2_BWCON	(DW16|WAIT|UBLB)  
#define  	B1_BWCON	(DW16|WAIT|UBLB)

#define  	B7_BANKCON	((0<<MT)|(1<<Tacs)|(1<<Tcos)|(7<<Tacc)|(1<<Tcoh)|(1<<Tcah)|(1<<Tacp)|(0<<PMC))
#define  	B6_BANKCON	((3<<MT)|(1<<Trcd)|(1<<SCAN))		/* SDRAM所用的Bank，不要修改 */
#define  	B5_BANKCON	((1<<Tacs)|(1<<Tcos)|(7<<Tacc)|(1<<Tcoh)|(1<<Tcah)|(1<<Tacp)|(0<<PMC))
#define  	B4_BANKCON	((1<<Tacs)|(1<<Tcos)|(7<<Tacc)|(1<<Tcoh)|(1<<Tcah)|(1<<Tacp)|(0<<PMC))
#define  	B3_BANKCON	((1<<Tacs)|(1<<Tcos)|(7<<Tacc)|(1<<Tcoh)|(1<<Tcah)|(1<<Tacp)|(0<<PMC))
#define  	B2_BANKCON	((1<<Tacs)|(1<<Tcos)|(7<<Tacc)|(1<<Tcoh)|(1<<Tcah)|(1<<Tacp)|(0<<PMC))
#define  	B1_BANKCON	((1<<Tacs)|(1<<Tcos)|(7<<Tacc)|(1<<Tcoh)|(1<<Tcah)|(1<<Tacp)|(0<<PMC))
#define  	B0_BANKCON	((1<<Tacs)|(1<<Tcos)|(7<<Tacc)|(1<<Tcoh)|(1<<Tcah)|(1<<Tacp)|(0<<PMC))

/* 是否显示液晶背景图片 */
#define     DISP_BGPIC  0               /* 非0时表示需要显示 */
 										
/* 串口(UART0/UART1)波特率 */
#define  	UART_BPS	115200			/* 定义通讯波特率 */ 



/*------------------------------------------------------------------------------------------------------*/
/* 其它包含文件在这里               */
/* header files in here             */




//------------------------------------------------------------------------------------------------------
/* 程序自己定义的内容               */
/* other project configs in here    */




//------------------------------------------------------------------------------------------------------
#endif  // __CONFIG_H

/*********************************************************************************************************
**                            End Of File
********************************************************************************************************/
