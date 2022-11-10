#define uint16 unsigned short int

extern void BubbleSort(uint16 data[]);

extern uint16 data[] = {90, 80, 0, 60, 50, 10, 30, 20, 40, 70};
// 调用汇编程序Add实现加法运算
void Main(void) {
    BubbleSort(data);
    while(1);
}
