#define uint8  unsigned char
#define uint32 unsigned int
#define uint16 unsigned short int

extern void BubbleSort(uint16 data[]);

extern uint16 data[] = {16,18,22,9,7,33,62,58,77,66,78,22,67,35,47,13,99,2,10,100};
// 调用汇编程序Add实现加法运算
void Main(void) {
    BubbleSort(data);
    while(1);
}
