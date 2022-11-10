DATA_ADDR       EQU     0x40008000

                AREA    Exp1,CODE,READONLY
                ENTRY
                CODE32

START           MOV     R0,#0           ;   R0, Counter for data load times
                LDR     R1,=DATA_ADDR   ;   R1, Address 0x40008000
                LDR     R2,=DATA        ;   R2, Data address
                B       DATA_LOAD

DATA            DCW 5,10,15,20,25,30,35,34,33,32,13,12,65,70,75,80,60,100,132,145,167

DATA_LOAD       LDRH    R3,[R2],#2      ;   R3, Data temp storage
                STRH    R3,[R1],#2      ;   Save data to memory

                ADD     R0,R0,#1        ;   Counter increasement
                CMP     R0,#20          ;   Compare counter with 15
                BLS     DATA_LOAD       ;   Stop data_load when counter == 15

                MOV     R0,#0           ;   R0, Counter1 for bubble sort outer loop
LOOP_1                                  
                LDR     R1,=DATA_ADDR   ;   R1, Num1's address1
                ADD     R2,R1,#2        ;   R2, Num2's address2
                MOV     R5,#0           ;   R5, Counter2 for bubble sort inner loop

LOOP_2          
                LDRH    R3,[R1]         ;   R3, Num1
                LDRH    R4,[R2]         ;   R4, Num2
                CMP     R3,R4           ;   Compare Num1 with Num2 to judge swap condition
                STRHIH   R3,[R2]         ;   Condition True, Swap [R1] with [R2]
                STRHIH   R4,[R1]         ;   Condition True, Swap [R1] with [R2]
                ADD     R1,R1,#2        ;   Address1 increasement
                ADD     R2,R2,#2        ;   Address2 increasement

                ADD     R5,R5,#1        ;   Counter2 increasement
                CMP     R5,#20          ;   Loop2 15 times to continue next step
                BNE     LOOP_2          ;   Loop2 15 times to continue next step

                ADD     R0,R0,#1        ;   Counter1 increasement
                CMP     R0,#20          ;   Loop1 15 times to continue next step
                BNE     LOOP_1          ;   Loop1 15 times to continue next step

                MOV     R1,#6           ;   Success when R1's value change to 6
                END
