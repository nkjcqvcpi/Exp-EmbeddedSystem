   pc.c����ֲ�ڦ�COS-II��PC������루pc.c��
   ��Ҫ�Ķ���
1��#include "includes.h"��Ϊ"config.h"  
2������Ļ����ʾ��Ϊ��UART0�������ݣ��ڵ�������ʾ��Ӱ��ĺ�����
   PC_DispChar()��PC_DispClrCol()��PC_DispClrRow()��PC_DispClrScr()��PC_DispStr()
3����ȡ��ֵ��Ϊ��UART0��ȡ��Ӱ��ĺ�����PC_GetKey()
4����Ϊû��dos�����������޸ģ�Ӱ��ĺ�����
   PC_DOSReturn()��PC_DOSSaveReturn()��PC_SetTickRate()��ɾ������PC_VectGet()��ɾ������
   PC_VectSet��ɾ������
5����Ϊ��ʱ����ͬ�������޸ģ�Ӱ��ĺ�����
   PC_ElapsedStart()��PC_ElapsedStop()��
6����Ϊʵʱʱ�Ӳ�ͬ�������޸ģ�Ӱ��ĺ�����PC_GetDateTime()��