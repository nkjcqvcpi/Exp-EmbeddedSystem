/****************************************Copyright (c)**************************************************
**                               Guangzhou ZHIYUAN electronics Co.,LTD.
**                                     
**                                 http://www.zyinside.com
**
**--------------File Info-------------------------------------------------------------------------------
** File Name:          os_cpu.h
** Last modified Date: 2006-01-06 
** Last Version:       v2.0
** Descriptions:       μCOS-II在LPC210x上的移植代码CPU配置部分，用ADS1.2编译
**
**------------------------------------------------------------------------------------------------------
** Created By:         陈明计
** Created date:       2003-06-05
** Version:            v1.0
** Descriptions:       创建
**
**------------------------------------------------------------------------------------------------------
** Modified by:        陈明计
** Modified date:      2003-06-19
** Version:            v1.3
**                     1、增加软件中断服务功能
**                     2、因取消变量OSNeedToSwapContext而做的改动
**
**------------------------------------------------------------------------------------------------------
** Modified by:        甘达
** Modified date:      2006-01-06
** Version:            v2.0
** Descriptions:       升级注释
**
**------------------------------------------------------------------------------------------------------
** Modified by:      
** Modified date:     
** Version:           
** Descriptions:      
**
********************************************************************************************************/
#ifdef  OS_CPU_GLOBALS
#define OS_CPU_EXT
#else
#define OS_CPU_EXT  extern
#endif

/**********************************************************************************************************
*                    定义与编译器无关的数据类型
**********************************************************************************************************/

typedef unsigned char  BOOLEAN;                 /* 布尔变量                                 */
typedef unsigned char  INT8U;                   /* 无符号8位整型变量                        */
typedef signed   char  INT8S;                   /* 有符号8位整型变量                        */
typedef unsigned short INT16U;                  /* 无符号16位整型变量                       */
typedef signed   short INT16S;                  /* 有符号16位整型变量                       */
typedef unsigned int   INT32U;                  /* 无符号32位整型变量                       */
typedef signed   int   INT32S;                  /* 有符号32位整型变量                       */
typedef float          FP32;                    /* 单精度浮点数（32位长度）                 */
typedef double         FP64;                    /* 双精度浮点数（64位长度）                 */

typedef INT32U         OS_STK;                  /* 堆栈是32位宽度                           */

/* 以下是兼容UC/OS V1.XX的数据类型，在uC/OS-II没有使用  */
#define BYTE           INT8S
#define UBYTE          INT8U
#define WORD           INT16S
#define UWORD          INT16U
#define LONG           INT32S
#define ULONG          INT32U

/* *********************************************************************************************************
*                    与ARM7体系结构相关的一些定义
**********************************************************************************************************/
#define     OS_CRITICAL_METHOD     2            /* 选择开、关中断的方式 */


__swi(0x00) void OS_TASK_SW(void);              /*  任务级任务切换函数          */
__swi(0x01) void _OSStartHighRdy(void);         /*  运行优先级最高的任务        */
__swi(0x02) void OS_ENTER_CRITICAL(void);       /*  关中断                      */
__swi(0x03) void OS_EXIT_CRITICAL(void);        /*  开中断                      */

__swi(0x40) void *GetOSFunctionAddr(int Index); /*  获取系统服务函数入口        */
__swi(0x41) void *GetUsrFunctionAddr(int Index);/*  获取自定义服务函数入口      */
__swi(0x42) void OSISRBegin(void);              /*  中断开始处理                */
__swi(0x43) int  OSISRNeedSwap(void);           /*  判断中断是否需要切换        */

__swi(0x80) void ChangeToSYSMode(void);         /*  任务切换到系统模式          */
__swi(0x81) void ChangeToUSRMode(void);         /*  任务切换到用户模式          */
__swi(0x82) void TaskIsARM(INT8U prio);         /*  任务代码是ARM代码           */
__swi(0x83) void TaskIsTHUMB(INT8U prio);       /*  任务代码是THUMB             */

#define OS_STK_GROWTH    1                      /*  堆栈是从上往下长的          */

#define     USR32Mode       0x10                /*  用户模式                    */
#define     SYS32Mode       0x1f                /*  系统模式                    */
#define     NoInt           0x80

#ifndef USER_USING_MODE
#define	USER_USING_MODE	USR32Mode               /*  任务缺省模式                 */
#endif

#ifndef OS_SELF_EN
#define	OS_SELF_EN     0                        /*  允许返回OS与任务分别编译、固化*/    
#endif


OS_CPU_EXT INT32U OsEnterSum;                   /*  关中断计数器（开关中断的信号量）    */


/*********************************************************************************************************
**                            End Of File
********************************************************************************************************/
