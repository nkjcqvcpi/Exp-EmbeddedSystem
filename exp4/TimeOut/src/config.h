/****************************************Copyright (c)**************************************************
**                               Guangzhou ZHIYUAN electronics Co.,LTD.
**                                     
**                                 http://www.zyinside.com
**
**--------------File Info-------------------------------------------------------------------------------
** File Name: config.h
** Last modified Date: 2005-12-31 
** Last Version: v1.0
** Descriptions: �û�����ͷ�ļ�
**
**------------------------------------------------------------------------------------------------------
** Created By: ���ܱ�
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
**                  "����Ϊϵͳ����"
**                  system configs in here
********************************************************************************************************/
// ��һ������Ķ�
#ifndef TRUE
#define TRUE  		1
#endif

#ifndef FALSE
#define FALSE 		0
#endif

#ifndef NULL
#define NULL  		(void *)0
#endif

typedef unsigned char  	uint8;          /* �޷���8λ���ͱ���            	*/
typedef signed   char  	int8;           /* �з���8λ���ͱ���            	*/
typedef unsigned short 	uint16;         /* �޷���16λ���ͱ���               */
typedef signed   short 	int16;          /* �з���16λ���ͱ���               */
typedef unsigned int   	uint32;         /* �޷���32λ���ͱ���               */
typedef signed   int   	int32;          /* �з���32λ���ͱ���               */
typedef float          	fp32;           /* �����ȸ�������32λ���ȣ�         */
typedef double         	fp64;           /* ˫���ȸ�������64λ���ȣ�         */



/*********************************************************************************************************
**                  "����Ϊ��������"         
**                  project configs in here
********************************************************************************************************/
// ��һ������Ķ�
#include    "S3C2410.h"
#include    "target.h"
#include    "UART.h"
#include    "LCDDRIVE.h"

#include    <stdio.h>
#include    <ctype.h>
#include    <stdlib.h>

// IRQ�ж�������ַ��
extern  uint32 VICVectAddr[];

// ʹ��/����IRQ��FIQ�ж�
__swi(0x00) void SwiHandle1(int Handle);

#define IRQDisable()    SwiHandle1(0)
#define IRQEnable()     SwiHandle1(1)
#define FIQDisable()    SwiHandle1(2)
#define FIQEnable()     SwiHandle1(3)

/* CPUʱ������(PLLCON����ֵ) */
/* 50.00MHz (�ⲿ����Ϊ12MHzʱ) */
#define  	MDIV_50			0x5C
#define  	PDIV_50			0x4
#define  	SDIV_50			0x2

/* 200.00MHz (�ⲿ����Ϊ12MHzʱ) */
/* ����ֵΪ��m=100,p=6,s=0, MPLL=FCLK=12*100/6=200MHz */
#define  	MDIV_200		0x5C
#define  	PDIV_200		0x4
#define  	SDIV_200		0x0		
#define  	MPLLCON_200		((MDIV_200 << 12) | (PDIV_200 << 4) | (SDIV_200)) 

/* ϵͳʱ�Ӻ궨�� */
#define     FCLK		(200*1000000)	/* ϵͳʱ�ӣ���target.c�ļ���TargetResetInit()���� */	
#define     HCLK		(FCLK/2)		/* HCLKֻ��ΪFCLK����1��2 */
#define     PCLK		(HCLK/2)		/* PCLKֻ��ΪHCLK����1��2 */


/* ���߿�ȿ��ƶ���(0��ʾ8λ��1��ʾ16λ��2��ʾ32λ) */
#define  	DW8			(0x0)
#define  	DW16		(0x1)
#define  	DW32		(0x2)
#define  	WAIT		(0x1<<2)
#define  	UBLB		(0x1<<3)

/* Bankʱ�����(λ��)���� */
#define     MT			15			/* �洢����ѡ�񣬽���Bank6��Bank7��Ч (2bit) */
#define     Trcd		 2			/* RAS��CAS�ӳ٣�����SDRAM��Ч (2bit) */
#define     SCAN		 0			/* �е�ַλ��������SDRAM��Ч (2bit) */

#define     Tacs		13			/* ��nGCSn��Ч֮ǰ����ַ�źŵĽ���ʱ�� (2bit) */
#define     Tcos		11			/* ��nOE��Ч֮ǰ��Ƭѡ�Ľ���ʱ�� (2bit) */
#define     Tacc		 8			/* �������� (3bit) */
#define     Tcoh		 6			/* nOE����֮��Ƭѡ�źŵı���ʱ�� (2bit) */
#define     Tcah		 4			/* nGCSn����֮�󣬵�ַ�źŵı���ʱ�� (2bit) */
#define     Tacp		 2			/* Pageģʽ�ķ������� (2bit) */
#define     PMC			 0			/* Pageģʽ���� (2bit) */



/*********************************************************************************************************
**                  "����ΪӦ�ó�������"         
**                  project configs in here
********************************************************************************************************/
// ���¸�����Ҫ�Ķ�

/**** �ⲿ�������ã��û��ɸ���ʵ����Ҫ�޸� ****/
#define  	B7_BWCON	(DW16|WAIT|UBLB) 
#define  	B6_BWCON	(DW32|UBLB) 	/* SDRAM���õ�Bank����Ҫ�޸� */ 
#define  	B5_BWCON	(DW16|WAIT|UBLB)  
#define  	B4_BWCON	(DW16|WAIT|UBLB)  
#define  	B3_BWCON	(DW16|WAIT|UBLB)  
#define  	B2_BWCON	(DW16|WAIT|UBLB)  
#define  	B1_BWCON	(DW16|WAIT|UBLB)

#define  	B7_BANKCON	((0<<MT)|(1<<Tacs)|(1<<Tcos)|(7<<Tacc)|(1<<Tcoh)|(1<<Tcah)|(1<<Tacp)|(0<<PMC))
#define  	B6_BANKCON	((3<<MT)|(1<<Trcd)|(1<<SCAN))		/* SDRAM���õ�Bank����Ҫ�޸� */
#define  	B5_BANKCON	((1<<Tacs)|(1<<Tcos)|(7<<Tacc)|(1<<Tcoh)|(1<<Tcah)|(1<<Tacp)|(0<<PMC))
#define  	B4_BANKCON	((1<<Tacs)|(1<<Tcos)|(7<<Tacc)|(1<<Tcoh)|(1<<Tcah)|(1<<Tacp)|(0<<PMC))
#define  	B3_BANKCON	((1<<Tacs)|(1<<Tcos)|(7<<Tacc)|(1<<Tcoh)|(1<<Tcah)|(1<<Tacp)|(0<<PMC))
#define  	B2_BANKCON	((1<<Tacs)|(1<<Tcos)|(7<<Tacc)|(1<<Tcoh)|(1<<Tcah)|(1<<Tacp)|(0<<PMC))
#define  	B1_BANKCON	((1<<Tacs)|(1<<Tcos)|(7<<Tacc)|(1<<Tcoh)|(1<<Tcah)|(1<<Tacp)|(0<<PMC))
#define  	B0_BANKCON	((1<<Tacs)|(1<<Tcos)|(7<<Tacc)|(1<<Tcoh)|(1<<Tcah)|(1<<Tacp)|(0<<PMC))

/* �Ƿ���ʾҺ������ͼƬ */
#define     DISP_BGPIC  0               /* ��0ʱ��ʾ��Ҫ��ʾ */
 										
/* ����(UART0/UART1)������ */
#define  	UART_BPS	115200			/* ����ͨѶ������ */ 



/*------------------------------------------------------------------------------------------------------*/
/* ���������ļ�������               */
/* header files in here             */




//------------------------------------------------------------------------------------------------------
/* �����Լ����������               */
/* other project configs in here    */




//------------------------------------------------------------------------------------------------------
#endif  // __CONFIG_H

/*********************************************************************************************************
**                            End Of File
********************************************************************************************************/
