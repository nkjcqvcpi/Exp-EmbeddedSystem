#include  "config.h"


// 定义独立按键KEY1的输入口
#define  KEY_CON	    (1<<4)      /* GPF4口  */

// 定义LED控制口 (输出高电平时点亮LED)
#define  LED1_CON       (1<<11)     /* GPE11口 */
#define  LED2_CON       (1<<12)     /* GPE12口 */
#define  LED3_CON       (1<<4)      /* GPH4口  */
#define  LED4_CON       (1<<6)      /* GPH6口  */


void DelayNS(uint32 dly) {
    uint32 i;
    
    for(; dly>0; dly--)
        for(i=0; i<50000; i++);
}


void LED_Disp13(void) {
    rGPEDAT = rGPEDAT | (0x01<<11);
    rGPHDAT = rGPHDAT | (0x01<<4);
    rGPEDAT = rGPEDAT & (~(0x01<<12));
    rGPHDAT = rGPHDAT & (~(0x01<<6));
}


void LED_Disp24(void) {
    rGPEDAT = rGPEDAT | (0x01<<12);
    rGPHDAT = rGPHDAT | (0x01<<6);
    rGPEDAT = rGPEDAT & (~(0x01<<11));
    rGPHDAT = rGPHDAT & (~(0x01<<4));
}


void  LED_DispAllOff(void) {
    rGPEDAT = rGPEDAT & (~(0x03<<11));
    rGPHDAT = rGPHDAT & (~(0x05<<4));
}


void LED_DispNum(uint32 dat) {
    dat = dat & 0x0000000F;     // 参数过滤
    
    // 控制LED4、LED3显示(d3、d2位)
    if (dat & 0x08) rGPHDAT = rGPHDAT | (0x01<<6);
    else rGPHDAT = rGPHDAT & (~(0x01<<6));
    if (dat & 0x04) rGPHDAT = rGPHDAT | (0x01<<4);
    else rGPHDAT = rGPHDAT & (~(0x01<<4));
    
    // 控制LED2、LED1显示(d1、d0位)
    rGPEDAT = (rGPEDAT & (~(0x03<<11))) | ((dat&0x03) << 11);
}


int main(void) {		
    int  i;
    
    // 初始化I/O
    rGPECON = (rGPECON & (~(0x0F<<22))) | (0x05<<22);   // rGPECON[25:22] = 0101b，设置GPE11、GPE12为GPIO输出模式
    rGPHCON = (rGPHCON & (~(0x33<<8))) | (0x11<<8);     // rGPHCON[13:8] = 01xx01b，设置GPH4、GPH6为GPIO输出模式
    rGPFCON = (rGPFCON & (~(0x03<<8)));                 // rGPFCON[9:8] = 00b，设置GPF4为GPIO输入模式
    
    LED_DispAllOff();
    
    // LED显示控制
    while(1) {
        if (rGPFDAT & KEY_CON) {   // 读取GPF口线上的电平，判断GPF4是否为高电平
            i = 0;
        } else {
            // LED全闪烁5次
            for(i=0; i<5; i++) {
                LED_Disp13();   // LED全熄灭
                DelayNS(5);
                LED_Disp24();    // LED全点亮
                DelayNS(5);
            }
            LED_DispAllOff();
            // 控制LED指示0～F的16进制数值
            for(i=0; i<8; i++) {
                LED_DispNum(i * 2);     // 显示数值i
                DelayNS(5);
            }
            for(i=8; i>0; i--) {
                LED_DispNum(i * 2 - 1);     // 显示数值i
                DelayNS(5);
            }
            LED_DispAllOff();
        }
        DelayNS(1);
    }
    return 0;
}
