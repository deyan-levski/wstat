/*This project is part of a larger project related to the final work
  Name Project: Weather Station Ethernet Server
   Microchip  PIC 18F4525 Master MCU
   Atmel  AtMega32  Slave MCU
   XTAL 16MHz
   
   (c) Tsvetomir Gotsov  2010
   
   Created:01.12.2010 there ever
   Updated:02.04.2011    4MHz   V0.0 Lcd_Module and one-wire sensor DS18S20
   Updated:04.04.2011    4MHz   V0.1 Work Frequency meters for Rh mesurment.
   Updated:05.04.2011    16MHz  V0.2 Work Rh.
   Updated:06.04.2011    16MHz  V0.3 Work communication!
   Updated:07.04.2011    16MHZ  V0.4 Second working Frequency meters for a wind speed.
   Updated:12.04.2011    16MHz  V0.5
   Updated:20.04.2011    16MHz  V0.6 Communication has a Chek Sum, Rh is considered outside the interruption.
   
*/
// LCD ����� ������
sbit LCD_RS at PORTD2_bit;
sbit LCD_EN at PORTD3_bit;
sbit LCD_D4 at PORTD4_bit;
sbit LCD_D5 at PORTD5_bit;
sbit LCD_D6 at PORTD6_bit;
sbit LCD_D7 at PORTD7_bit;

sbit LCD_RS_Direction at DDD2_bit;
sbit LCD_EN_Direction at DDD3_bit;
sbit LCD_D4_Direction at DDD4_bit;
sbit LCD_D5_Direction at DDD5_bit;
sbit LCD_D6_Direction at DDD6_bit;
sbit LCD_D7_Direction at DDD7_bit;
// ���� �� LCD ����� ������

// ��������� ����������� ������
sbit MANRXPIN at PIND0_bit;
sbit MANRXPIN_Direction at DDD0_bit;
sbit MANTXPIN at PORTD1_bit;
sbit MANTXPIN_Direction at DDD1_bit;
// ���� �� ��������� ����������� ������

char index, character,counter,temp_whole,serial[11],txt[2],txt2[6],*temperature = "00.0",i,counter2,oldCount2;
unsigned long  int count,oldCount,count1,temp,count2;
const char _THRESHOLD = 16,_THRESHOLD2 = 32;
int direction;
unsigned short int Rh,oldRh;
// ���������� �� �����������
int temperature2;
const unsigned short TEMP_RESOLUTION = 9;
unsigned int temp_fraction;
const unsigned short RES_SHIFT = TEMP_RESOLUTION - 8;
// ���� �� ��������������� �� ����������
bit flag;

//��������� �� ��������� � ������� T0 � �1
void Timer2Overflow_ISR() org IVT_ADDR_TIMER2_OVF {
   count1 = ((TCNT1H<<8)+TCNT1L);                                        // count1 �� ��������� �� Rh �������� T1
   count2 = TCNT0;                                                       // count2 �� ��������� ������� �� ������ �������� T0

   if (counter >= _THRESHOLD) {
     count = (count1*2*2*1.0435);                                        // �������� �� ���������
     oldCount = count;                                                   // ��������� �� ����������� ��������
     oldCount2 = (count2*2*2);                                           // ��������� �� ������� �� ������
     oldCount2 = oldCount2 - (oldCount2*0.11);                           // �������� �� ���������
     count2 = 0;                                                         // Reset   count2
     TCNT0 = 0;                                                          // �������  ������ TCNT0
     count = 0;                                                          // ������� ������ count
     counter = 0;                                                        // ������� ������ counter
     TCNT1H = 0;                                                         // �������� �� ������� ���� �� �1
     TCNT1L = 0;                                                         // �������� �� ������� ���� �� �1

  }
  else
    counter++;                                                           // ������������ counter
    counter2++;                                                          // ������������� counter2
}
// ���� �� ����������

// ��������� �� �����������   � DS18S20
int Display_Temperature(unsigned int temp2write) {

     // ������� ��� ������������� � �����������
     if (temp2write & 0x8000) {
        temperature[0] = '-';
        temp2write = ~temp2write + 1;
        }
     else {
          temperature[0] = '+';
        }
        // ����������� temp_whole
        temp_whole = temp2write >> RES_SHIFT ;
        temperature[1] = (temp_whole/10)%10 + 48;                     // ������ ��������
        temperature[2] =  temp_whole%10     + 48;                     // ������ �������
        temp_fraction  = temp2write << (4-RES_SHIFT);
        temp_fraction &= 0x000F;
        temp_fraction *= 625;
        // ����������� temp_fraction � ������
        temperature[3] =  temp_fraction/1000    + 48;                // ������ ������ ����
        return 0;
}
//���� �� ������� �� ��������� �� �����������
   
// ������ �� ������
int directionF (void) {

switch (PINA) {                                               //������� ���������������

  case 0b11111110:
  //Lcd_Out(2,1," N");
  return serial[3] = 1 + 48;                                      //�������� ������ � N
  break;
  case 0b11111101:
  //Lcd_Out(2,1,"NE");
  return serial[3] = 2 + 48;                                      //�������� ������ � NE
  break;
  case 0b11111011:
 // Lcd_Out(2,1," E");
  return serial[3] = 3 + 48;                                     //�������� ������ � E
  break;
  case 0b11110111:
  //Lcd_Out(2,1,"SE");
  return serial[3] = 4 + 48;                                     //�������� ������ � SE
  break;
  case 0b11101111:
  //Lcd_Out(2,1," S");
  return  serial[3] = 5 + 48;                                   //�������� ������ � S
  break;
  case 0b11011111:
  //Lcd_Out(2,1,"SW");
  return  serial[3] = 6 + 48;                                   //�������� ������ � SW
  break;
  case 0b10111111:
  //Lcd_Out(2,1," W");
  return  serial[3] = 7 + 48;                                   //�������� ������ � W
  break;
  case 0b01111111:
  //Lcd_Out(2,1,"NW");
  return serial[3] = 8 + 48;                                   //�������� ������ � NW
  break;
  default: '1';
  break;
  }
}
// ���� �� ������� directionF()
void InitGlobal(void) {                                        //������������� �� ����������
     DDRA = 0x00;                                              // PortA ����
     temp = 0;                                                 // ������������� temp ��� 0
     SREG_I_bit = 1;                                           // ������� ���������� ��������
     TOIE2_bit  = 1;                                           // Timer2 ���������  ������� ����������
     TCCR2  = 0x07;                                            // ��������� ������ � 1024 prescaler
     TCCR1A = 0x00;                                            // ������� �� ������ TC1 ���� ����� �� PB1
     TCCR1B = 0x07;                                            // ������� �� ������ TC1 ���� ����� �� PB1
     TCCR0 = 0x07;                                             // ������� �� TC0 ���� 8-����� ����� �� PB0
     Lcd_Init();                                               // ������������� ��  LCD ��� ��� ������ ��� ���� //
     Lcd_Cmd(_LCD_CLEAR);                                      // ������� LCD
     Lcd_Cmd(_LCD_CURSOR_OFF);                                 // �������� ������
     Man_Send_Init();                                          // ������������� ��������� �����������
     serial[0] = 49;                                           // ������������� �������� �� ������ � '1'
     serial[1] = 49;                                           // ������������� �������� �� ������ � '1'
     serial[2] = 49;                                           // ������������� �������� �� ������ � '1'
     serial[3] = 49;                                           // ������������� �������� �� ������ � '1'
     serial[4] = 49;                                           // ������������� �������� �� ������ � '1'
     serial[5] = 49;                                           // ������������� �������� �� ������ � '1'
     serial[6] = 49;                                           // ������������� �������� �� ������ � '1'
     serial[7] = 49;                                           // ������������� �������� �� ������ � '1'
     serial[8] = 49;                                           // ������������� �������� �� ������ � '1'
     serial[9] = 49;                                           // ������������� �������� �� ������ � '1'
     serial[10] = 49;                                          // ������������� �������� �� ������ � '1'
     serial[11] = 49;                                          // ������������� �������� �� ������ � '1'
     serial[12] = 49;                                          // ������������� �������� �� ������ � '1'
     serial[13] = 49;                                          // ������������� �������� �� ������ � '1'
     serial[14] = 0;                                           // ���� �� ������
}

void main() {

     InitGlobal();                                             // �������� �������������
     
     Lcd_Out(1, 1, "Rh:");
     Lcd_Out(1,10,"%");
     Lcd_Out(2,1,"Frequency:");
     Lcd_Out(2,15,"Hz");


  while (1) {
          if( oldCount >=6033 & oldCount<= 7351 ) {           // Rh = 565.3-(oldCount*0.07675) ���� � ��������
                       Rh = 565.3-(oldCount*0.0765);
                       oldRh = Rh;                            // ��� ��� ������ ����� �������� ��������
     // ���� � ������� �� 3-������ � ������ ������� � ������� �� 1-������
     // Rh = (6.262*oldCount*0.001*oldCount*0.001*oldCount*0.001)-(132.1*oldCount*0.001*oldCount*0.001)+(847.8*oldCount*0.001)-1583;
     }
     else {
          //if( oldCount < 6032 |  oldCount > 7350 ) {
              Rh = oldRh;
          //}
     }

       // ������������ ���������
       Ow_Reset(&PORTB, 2);                                                  // Onewire ������� ������
       Ow_Write(&PORTB, 2, 0xCC);                                            // �������� �� ������� SKIP_ROM
       Ow_Write(&PORTB, 2, 0x44);                                            // �������� �� ������� CONVERT_T
       Delay_us(120);

        Ow_Reset(&PORTB, 2);
        Ow_Write(&PORTB, 2, 0xCC);                                           // �������� �� ������� SKIP_ROM
        Ow_Write(&PORTB, 2, 0xBE);                                           // �������� �� ������� READ_SCRATCHPAD
        Delay_ms(400);

        temperature2 =  Ow_Read(&PORTB, 2);
        temperature2 = (Ow_Read(&PORTB, 2) << 8) + temperature2;

        Display_Temperature(temperature2);
        
        //������� �������� �� LCD
        WordToStr(oldCount, txt2);
        Lcd_Out(2, 10, txt2);
        WordToStr(Rh, txt);
        Lcd_Out(1,4,txt);
// ������ �� ��������� ��� ������ ����������
        serial[0] = '1';                                                    // ��������� ����
        serial[1] = (Rh/10)%10 + 48;                                        // �������� ��������
        serial[2] = Rh%10     + 48;                                         // �������� �������
        directionF();                                                       // ������ �� ������
        serial[4] = ((oldCount2/10)%10) + 48;                              // ������� �� ������ ��������
        serial[5] = (oldCount2%10) + 48;                                   // ������� �� ������ �������
        serial[6] = temperature[0];                                        // ����������� ����
        serial[7] = temperature[1];                                        // ����������� ��������
        serial[8] = temperature[2];                                        // ����������� �������
        serial[9] = temperature[3];                                        // ����������� ������ ����
        // CRC �������� �� �������
        serial[10] = (((serial[0] + serial[1] + serial[2] + serial[3] + serial[4] + serial[5] +  serial[7] + serial[8] + serial[9] )%2)+48);
        serial[11] = 0;   // ���� �� �������
 Man_Send(0x0B);                                                           // ��������� �� ������� ����
    Delay_ms(100);                                                         // ���������
    character = serial[0];                                                 // ������� ����� ������ �� �������
    index = 0;                                                             // ������������� ��  index ����������
    while (character) {                                                    // ������ �������� � ����
          Man_Send(character);                                             // ������� ������
          Delay_ms(90);                                                    // �������
          index++;                                                         // ������������� index ������������
          character = serial[index];                                       // ������� ��������� ������ �� �������
    }
    Man_Send(0x0E);                                                        // ������� ���� ����
}
}