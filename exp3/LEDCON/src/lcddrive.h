/****************************************Copyright (c)**************************************************
**                               Guangzhou ZHIYUAN electronics Co.,LTD.
**                                     
**                                 http://www.zyinside.com
**
**--------------File Info-------------------------------------------------------------------------------
** File Name: lcddrive.h
** Last modified Date: 2005-12-31 
** Last Version: v1.0
** Description: S3C2410的LCD驱动程序 (头文件)
**              针对LQ080V3DG01液晶模块的驱动程序 (640x480, TFT, 18BPP)
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
*******************************************************************************************************/
#ifndef  __LCDDRIVE_H
#define  __LCDDRIVE_H

// 定义颜色数据类型(可以是数据结构)
#define  TCOLOR				uint16
   
// 定义LCM像素数宏                 
#define  GUI_LCM_XMAX		640		    /* 定义液晶x轴的点数 */
#define  GUI_LCM_YMAX		480			/* 定义液晶y轴的点数 */

// 设置颜色宏定义 (格式: R=5, G=6, B=5)
#define   BLACK		        0x0000      /* 黑色：    0,   0,   0 */
#define   NAVY		        0x000F      /* 深蓝色：  0,   0, 128 */
#define   DGREEN	        0x03E0		/* 深绿色：  0, 128,   0 */
#define   DCYAN		        0x03EF		/* 深青色：  0, 128, 128 */
#define   MAROON	        0x7800		/* 深红色：128,   0,   0 */
#define   PURPLE	        0x780F		/* 紫色：  128,   0, 128 */
#define   OLIVE		        0x7BE0 	    /* 橄榄绿：128, 128,   0 */
#define   LGRAY		        0xC618	    /* 灰白色：192, 192, 192 */
#define   DGRAY		        0x7BEF		/* 深灰色：128, 128, 128 */
#define   BLUE		        0x001F		/* 蓝色：    0,   0, 255 */
#define   GREEN		        0x07E0		/* 绿色：    0, 255,   0 */
#define   CYAN	            0x07FF 		/* 青色：    0, 255, 255 */
#define   RED		        0xF800		/* 红色：  255,   0,   0 */
#define   MAGENTA	        0xF81F		/* 品红：  255,   0, 255 */
#define   YELLOW	        0xFFE0		/* 黄色：  255, 255, 0   */
#define   WHITE		        0xFFFF      /* 白色：  255, 255, 255 */

// 定义清屏色
#define  GUI_CCOLOR         BLACK


#ifndef  IN_LCDDRIVE

    #ifdef __cplusplus
    extern "C" {
    #endif


// 声明显示缓冲区
extern volatile uint16  FrameBuffer[GUI_LCM_YMAX][GUI_LCM_XMAX];


/********************************************************************************************************
** Function name: GUI_Initialize
** Descriptions: 初始化GUI，包括初始化显示缓冲区，初始化LCM并清屏。
**               用户根据LCM的实际情况编写此函数。
** Input: 无
** Output: 无
********************************************************************************************************/
extern void  GUI_Initialize(void);



/********************************************************************************************************
** Function name: GUI_FillSCR
** Descriptions: 全屏填充。直接使用数据填充显示缓冲区。
**               用户根据LCM的实际情况编写此函数。
** Input: dat   填充的数据
** Output: 无
********************************************************************************************************/
extern void  GUI_FillSCR(TCOLOR dat);



/********************************************************************************************************
** Function name: GUI_ClearSCR
** Descriptions: 清屏。
**               用户根据LCM的实际情况编写此函数。
** Input: 无
** Output: 无
********************************************************************************************************/
extern void  GUI_ClearSCR(void);



/********************************************************************************************************
** Function name: GUI_Point
** Descriptions: 在指定位置上画点。
** Input: x		指定点所在列的位置
**        y		指定点所在行的位置
**        color	显示颜色
** Output: 返回值为1时表示操作成功，为0时表示操作失败。
********************************************************************************************************/
extern uint32  GUI_Point(uint16 x, uint16 y, TCOLOR color);



/********************************************************************************************************
** Function name: GUI_ReadPoint
** Descriptions: 读取指定位置点的颜色数据。
** Input: x		指定点所在列的位置
**        y		指定点所在行的位置
**        ret   用来保存颜色值的变量(指针)
** Output: 返回值为1时表示操作成功，为0时表示操作失败。
********************************************************************************************************/
extern uint32  GUI_ReadPoint(uint16 x, uint16 y, TCOLOR *ret);



/********************************************************************************************************
** Function name: GUI_HLine
** Descriptions: 画水平线。
**               操作失败原因是指定地址超出缓冲区范围。
** Input: x0    水平线起点所在列的位置
**        y0	水平线起点所在行的位置
**        x1    水平线终点所在列的位置
**        color	显示颜色
** Output: 无
********************************************************************************************************/
extern void  GUI_HLine(uint16 x0, uint16 y0, uint16 x1, TCOLOR color);



/********************************************************************************************************
** Function name: GUI_RLine
** Descriptions: 画垂直线。
**              操作失败原因是指定地址超出缓冲区范围。
** Input: x0	垂直线起点所在列的位置
**        y0	垂直线起点所在行的位置
**        y1    垂直线终点所在行的位置
**        color	显示颜色
** Output: 无
********************************************************************************************************/
extern void  GUI_RLine(uint16 x0, uint16 y0, uint16 y1, TCOLOR color);



/********************************************************************************************************
** Function name: GUI_CmpColor
** Descriptions: 判断颜色值是否一致。
**              由于颜色类型TCOLOR可以是结构类型，所以需要用户编写比较函数。
** Input: color1	颜色值1
**		  color2	颜色值2
** Output: 返回1表示相同，返回0表示不相同。
********************************************************************************************************/
//extern int  GUI_CmpColor(TCOLOR color1, TCOLOR color2);
#define  GUI_CmpColor(color1, color2)	(color1 == color2)



/********************************************************************************************************
** Function name: GUI_CopyColor
** Descriptions: 颜色值复制。
**              由于颜色类型TCOLOR可以是结构类型，所以需要用户编写复制函数。
** Input: color1    目标颜色变量
**		  color2	源颜色变量
** Output: 无
********************************************************************************************************/
//extern void  GUI_CopyColor(TCOLOR *color1, TCOLOR color2);
#define  GUI_CopyColor(color1, color2) 	 *color1 = color2



/********************************************************************************************************
** Function name: GUI_Rectangle
** Descriptions: 画矩形。
**               操作失败原因是指定地址超出缓冲区范围。
** Input: x0	矩形左上角的x坐标值
**        y0	矩形左上角的y坐标值
**        x1    矩形右下角的x坐标值
**        y1    矩形右下角的y坐标值
**        color	显示颜色
** Output: 无
********************************************************************************************************/
extern void  GUI_Rectangle(uint32 x0, uint32 y0, uint32 x1, uint32 y1, TCOLOR color);



/********************************************************************************************************
** Function name: GUI_RectangleFill
** Descriptions: 填充矩形。画一个填充的矩形，填充色与边框色一样。
**              操作失败原因是指定地址超出缓冲区范围。
** Input: x0	矩形左上角的x坐标值
**        y0	矩形左上角的y坐标值
**        x1    矩形右下角的x坐标值
**        y1    矩形右下角的y坐标值
**        color	填充颜色
** Output: 无
********************************************************************************************************/
extern void  GUI_RectangleFill(uint32 x0, uint32 y0, uint32 x1, uint32 y1, TCOLOR color);



/********************************************************************************************************
** Function name: GUI_Line
** Descriptions: 画任意两点之间的直线。
**              操作失败原因是指定地址超出缓冲区范围。
** Input: x0	直线起点的x坐标值
**        y0	直线起点的y坐标值
**        x1    直线终点的x坐标值
**        y1    直线终点的y坐标值
**        color	显示颜色(对于黑白色LCM，为0时灭，为1时显示)
** Output: 无
********************************************************************************************************/
extern void  GUI_Line(uint32 x0, uint32 y0, uint32 x1, uint32 y1, TCOLOR color);



/********************************************************************************************************
** Function name: GUI_DispPic
** Descriptions: 指定位置显示图片(图片大小为w、h)。
**              不能正确显示原因可能是指定的起始点不对，或高度、宽度超出液晶显示范围，或数据格式错误。
** Input: x,y  	    更新区域的起始点(左上角)
*		  w,h		区域宽度和高度
*         buffer    显示数据缓冲区(uint16, 格式为 R:5, G:6, B:5)
** Output: 无
********************************************************************************************************/
extern void  GUI_DispPic( uint16 x, uint16 y, uint16 w, uint16 h, uint16  *buffer);



/********************************************************************************************************/
    #ifdef __cplusplus
    }
    #endif    
    
#endif      // IN_LCDDRIVE

#endif      // __LCDDRIVE_H
