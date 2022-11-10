/****************************************Copyright (c)**************************************************
**                               Guangzhou ZHIYUAN electronics Co.,LTD.
**                                     
**                                 http://www.zyinside.com
**
**--------------File Info-------------------------------------------------------------------------------
** File Name: lcddrive.h
** Last modified Date: 2005-12-31 
** Last Version: v1.0
** Description: S3C2410��LCD�������� (ͷ�ļ�)
**              ���LQ080V3DG01Һ��ģ����������� (640x480, TFT, 18BPP)
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
*******************************************************************************************************/
#ifndef  __LCDDRIVE_H
#define  __LCDDRIVE_H

// ������ɫ��������(���������ݽṹ)
#define  TCOLOR				uint16
   
// ����LCM��������                 
#define  GUI_LCM_XMAX		640		    /* ����Һ��x��ĵ��� */
#define  GUI_LCM_YMAX		480			/* ����Һ��y��ĵ��� */

// ������ɫ�궨�� (��ʽ: R=5, G=6, B=5)
#define   BLACK		        0x0000      /* ��ɫ��    0,   0,   0 */
#define   NAVY		        0x000F      /* ����ɫ��  0,   0, 128 */
#define   DGREEN	        0x03E0		/* ����ɫ��  0, 128,   0 */
#define   DCYAN		        0x03EF		/* ����ɫ��  0, 128, 128 */
#define   MAROON	        0x7800		/* ���ɫ��128,   0,   0 */
#define   PURPLE	        0x780F		/* ��ɫ��  128,   0, 128 */
#define   OLIVE		        0x7BE0 	    /* ����̣�128, 128,   0 */
#define   LGRAY		        0xC618	    /* �Ұ�ɫ��192, 192, 192 */
#define   DGRAY		        0x7BEF		/* ���ɫ��128, 128, 128 */
#define   BLUE		        0x001F		/* ��ɫ��    0,   0, 255 */
#define   GREEN		        0x07E0		/* ��ɫ��    0, 255,   0 */
#define   CYAN	            0x07FF 		/* ��ɫ��    0, 255, 255 */
#define   RED		        0xF800		/* ��ɫ��  255,   0,   0 */
#define   MAGENTA	        0xF81F		/* Ʒ�죺  255,   0, 255 */
#define   YELLOW	        0xFFE0		/* ��ɫ��  255, 255, 0   */
#define   WHITE		        0xFFFF      /* ��ɫ��  255, 255, 255 */

// ��������ɫ
#define  GUI_CCOLOR         BLACK


#ifndef  IN_LCDDRIVE

    #ifdef __cplusplus
    extern "C" {
    #endif


// ������ʾ������
extern volatile uint16  FrameBuffer[GUI_LCM_YMAX][GUI_LCM_XMAX];


/********************************************************************************************************
** Function name: GUI_Initialize
** Descriptions: ��ʼ��GUI��������ʼ����ʾ����������ʼ��LCM��������
**               �û�����LCM��ʵ�������д�˺�����
** Input: ��
** Output: ��
********************************************************************************************************/
extern void  GUI_Initialize(void);



/********************************************************************************************************
** Function name: GUI_FillSCR
** Descriptions: ȫ����䡣ֱ��ʹ�����������ʾ��������
**               �û�����LCM��ʵ�������д�˺�����
** Input: dat   ��������
** Output: ��
********************************************************************************************************/
extern void  GUI_FillSCR(TCOLOR dat);



/********************************************************************************************************
** Function name: GUI_ClearSCR
** Descriptions: ������
**               �û�����LCM��ʵ�������д�˺�����
** Input: ��
** Output: ��
********************************************************************************************************/
extern void  GUI_ClearSCR(void);



/********************************************************************************************************
** Function name: GUI_Point
** Descriptions: ��ָ��λ���ϻ��㡣
** Input: x		ָ���������е�λ��
**        y		ָ���������е�λ��
**        color	��ʾ��ɫ
** Output: ����ֵΪ1ʱ��ʾ�����ɹ���Ϊ0ʱ��ʾ����ʧ�ܡ�
********************************************************************************************************/
extern uint32  GUI_Point(uint16 x, uint16 y, TCOLOR color);



/********************************************************************************************************
** Function name: GUI_ReadPoint
** Descriptions: ��ȡָ��λ�õ����ɫ���ݡ�
** Input: x		ָ���������е�λ��
**        y		ָ���������е�λ��
**        ret   ����������ɫֵ�ı���(ָ��)
** Output: ����ֵΪ1ʱ��ʾ�����ɹ���Ϊ0ʱ��ʾ����ʧ�ܡ�
********************************************************************************************************/
extern uint32  GUI_ReadPoint(uint16 x, uint16 y, TCOLOR *ret);



/********************************************************************************************************
** Function name: GUI_HLine
** Descriptions: ��ˮƽ�ߡ�
**               ����ʧ��ԭ����ָ����ַ������������Χ��
** Input: x0    ˮƽ����������е�λ��
**        y0	ˮƽ����������е�λ��
**        x1    ˮƽ���յ������е�λ��
**        color	��ʾ��ɫ
** Output: ��
********************************************************************************************************/
extern void  GUI_HLine(uint16 x0, uint16 y0, uint16 x1, TCOLOR color);



/********************************************************************************************************
** Function name: GUI_RLine
** Descriptions: ����ֱ�ߡ�
**              ����ʧ��ԭ����ָ����ַ������������Χ��
** Input: x0	��ֱ����������е�λ��
**        y0	��ֱ����������е�λ��
**        y1    ��ֱ���յ������е�λ��
**        color	��ʾ��ɫ
** Output: ��
********************************************************************************************************/
extern void  GUI_RLine(uint16 x0, uint16 y0, uint16 y1, TCOLOR color);



/********************************************************************************************************
** Function name: GUI_CmpColor
** Descriptions: �ж���ɫֵ�Ƿ�һ�¡�
**              ������ɫ����TCOLOR�����ǽṹ���ͣ�������Ҫ�û���д�ȽϺ�����
** Input: color1	��ɫֵ1
**		  color2	��ɫֵ2
** Output: ����1��ʾ��ͬ������0��ʾ����ͬ��
********************************************************************************************************/
//extern int  GUI_CmpColor(TCOLOR color1, TCOLOR color2);
#define  GUI_CmpColor(color1, color2)	(color1 == color2)



/********************************************************************************************************
** Function name: GUI_CopyColor
** Descriptions: ��ɫֵ���ơ�
**              ������ɫ����TCOLOR�����ǽṹ���ͣ�������Ҫ�û���д���ƺ�����
** Input: color1    Ŀ����ɫ����
**		  color2	Դ��ɫ����
** Output: ��
********************************************************************************************************/
//extern void  GUI_CopyColor(TCOLOR *color1, TCOLOR color2);
#define  GUI_CopyColor(color1, color2) 	 *color1 = color2



/********************************************************************************************************
** Function name: GUI_Rectangle
** Descriptions: �����Ρ�
**               ����ʧ��ԭ����ָ����ַ������������Χ��
** Input: x0	�������Ͻǵ�x����ֵ
**        y0	�������Ͻǵ�y����ֵ
**        x1    �������½ǵ�x����ֵ
**        y1    �������½ǵ�y����ֵ
**        color	��ʾ��ɫ
** Output: ��
********************************************************************************************************/
extern void  GUI_Rectangle(uint32 x0, uint32 y0, uint32 x1, uint32 y1, TCOLOR color);



/********************************************************************************************************
** Function name: GUI_RectangleFill
** Descriptions: �����Ρ���һ�����ľ��Σ����ɫ��߿�ɫһ����
**              ����ʧ��ԭ����ָ����ַ������������Χ��
** Input: x0	�������Ͻǵ�x����ֵ
**        y0	�������Ͻǵ�y����ֵ
**        x1    �������½ǵ�x����ֵ
**        y1    �������½ǵ�y����ֵ
**        color	�����ɫ
** Output: ��
********************************************************************************************************/
extern void  GUI_RectangleFill(uint32 x0, uint32 y0, uint32 x1, uint32 y1, TCOLOR color);



/********************************************************************************************************
** Function name: GUI_Line
** Descriptions: ����������֮���ֱ�ߡ�
**              ����ʧ��ԭ����ָ����ַ������������Χ��
** Input: x0	ֱ������x����ֵ
**        y0	ֱ������y����ֵ
**        x1    ֱ���յ��x����ֵ
**        y1    ֱ���յ��y����ֵ
**        color	��ʾ��ɫ(���ںڰ�ɫLCM��Ϊ0ʱ��Ϊ1ʱ��ʾ)
** Output: ��
********************************************************************************************************/
extern void  GUI_Line(uint32 x0, uint32 y0, uint32 x1, uint32 y1, TCOLOR color);



/********************************************************************************************************
** Function name: GUI_DispPic
** Descriptions: ָ��λ����ʾͼƬ(ͼƬ��СΪw��h)��
**              ������ȷ��ʾԭ�������ָ������ʼ�㲻�ԣ���߶ȡ����ȳ���Һ����ʾ��Χ�������ݸ�ʽ����
** Input: x,y  	    �����������ʼ��(���Ͻ�)
*		  w,h		������Ⱥ͸߶�
*         buffer    ��ʾ���ݻ�����(uint16, ��ʽΪ R:5, G:6, B:5)
** Output: ��
********************************************************************************************************/
extern void  GUI_DispPic( uint16 x, uint16 y, uint16 w, uint16 h, uint16  *buffer);



/********************************************************************************************************/
    #ifdef __cplusplus
    }
    #endif    
    
#endif      // IN_LCDDRIVE

#endif      // __LCDDRIVE_H