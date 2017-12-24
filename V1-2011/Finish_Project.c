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
// LCD модул връзки
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
// Край на LCD модул връзки

// Манчестър комуникация връзки
sbit MANRXPIN at PIND0_bit;
sbit MANRXPIN_Direction at DDD0_bit;
sbit MANTXPIN at PORTD1_bit;
sbit MANTXPIN_Direction at DDD1_bit;
// Край на манчестър комуникация връзки

char index, character,counter,temp_whole,serial[11],txt[2],txt2[6],*temperature = "00.0",i,counter2,oldCount2;
unsigned long  int count,oldCount,count1,temp,count2;
const char _THRESHOLD = 16,_THRESHOLD2 = 32;
int direction;
unsigned short int Rh,oldRh;
// Променливи за температура
int temperature2;
const unsigned short TEMP_RESOLUTION = 9;
unsigned int temp_fraction;
const unsigned short RES_SHIFT = TEMP_RESOLUTION - 8;
// край на инициализациите на променливи
bit flag;

//Измерване на честотата с таймери T0 и Т1
void Timer2Overflow_ISR() org IVT_ADDR_TIMER2_OVF {
   count1 = ((TCNT1H<<8)+TCNT1L);                                        // count1 за измерване на Rh използва T1
   count2 = TCNT0;                                                       // count2 за измерване скорост на вятъра използва T0

   if (counter >= _THRESHOLD) {
     count = (count1*2*2*1.0435);                                        // Корекция на честотата
     oldCount = count;                                                   // Честотата за относителна влажност
     oldCount2 = (count2*2*2);                                           // Честотата за скорост на вятъра
     oldCount2 = oldCount2 - (oldCount2*0.11);                           // Корекция на честотата
     count2 = 0;                                                         // Reset   count2
     TCNT0 = 0;                                                          // Нулирай  таймер TCNT0
     count = 0;                                                          // Нулирай брояча count
     counter = 0;                                                        // Нулирай брояча counter
     TCNT1H = 0;                                                         // Нулиране на старшия байт на Т1
     TCNT1L = 0;                                                         // Нулиране на младшия байт на Т1

  }
  else
    counter++;                                                           // икрементирай counter
    counter2++;                                                          // инкрементирай counter2
}
// Край на прекъсване

// Измерване на температура   с DS18S20
int Display_Temperature(unsigned int temp2write) {

     // Провери ако температурата е отрицателна
     if (temp2write & 0x8000) {
        temperature[0] = '-';
        temp2write = ~temp2write + 1;
        }
     else {
          temperature[0] = '+';
        }
        // конвертирай temp_whole
        temp_whole = temp2write >> RES_SHIFT ;
        temperature[1] = (temp_whole/10)%10 + 48;                     // Изведи десетици
        temperature[2] =  temp_whole%10     + 48;                     // Изведи единици
        temp_fraction  = temp2write << (4-RES_SHIFT);
        temp_fraction &= 0x000F;
        temp_fraction *= 625;
        // конвертирай temp_fraction в символ
        temperature[3] =  temp_fraction/1000    + 48;                // Изведи дробна част
        return 0;
}
//Край на функция за измерване на температура
   
// Посока на вятъра
int directionF (void) {

switch (PINA) {                                               //Провери ветропоказателя

  case 0b11111110:
  //Lcd_Out(2,1," N");
  return serial[3] = 1 + 48;                                      //Текущата посока е N
  break;
  case 0b11111101:
  //Lcd_Out(2,1,"NE");
  return serial[3] = 2 + 48;                                      //Текущата посока е NE
  break;
  case 0b11111011:
 // Lcd_Out(2,1," E");
  return serial[3] = 3 + 48;                                     //Текущата посока е E
  break;
  case 0b11110111:
  //Lcd_Out(2,1,"SE");
  return serial[3] = 4 + 48;                                     //Текущата посока е SE
  break;
  case 0b11101111:
  //Lcd_Out(2,1," S");
  return  serial[3] = 5 + 48;                                   //Текущата посока е S
  break;
  case 0b11011111:
  //Lcd_Out(2,1,"SW");
  return  serial[3] = 6 + 48;                                   //Текущата посока е SW
  break;
  case 0b10111111:
  //Lcd_Out(2,1," W");
  return  serial[3] = 7 + 48;                                   //Текущата посока е W
  break;
  case 0b01111111:
  //Lcd_Out(2,1,"NW");
  return serial[3] = 8 + 48;                                   //Текущата посока е NW
  break;
  default: '1';
  break;
  }
}
// Край на функция directionF()
void InitGlobal(void) {                                        //Инициализация на променливи
     DDRA = 0x00;                                              // PortA вход
     temp = 0;                                                 // инициализирай temp със 0
     SREG_I_bit = 1;                                           // Разреши прекъсване глобално
     TOIE2_bit  = 1;                                           // Timer2 препулнен  разреши прекъсване
     TCCR2  = 0x07;                                            // Стартирай таймер с 1024 prescaler
     TCCR1A = 0x00;                                            // Сетване на таймер TC1 като брояч на PB1
     TCCR1B = 0x07;                                            // Сетване на таймер TC1 като брояч на PB1
     TCCR0 = 0x07;                                             // Сетване на TC0 като 8-битов брояч на PB0
     Lcd_Init();                                               // Инициализация на  LCD ако има такова ако няма //
     Lcd_Cmd(_LCD_CLEAR);                                      // Изчисти LCD
     Lcd_Cmd(_LCD_CURSOR_OFF);                                 // Премахни курсор
     Man_Send_Init();                                          // Инициализирай Манчестър комуникация
     serial[0] = 49;                                           // Инициализирай елемента на масива с '1'
     serial[1] = 49;                                           // Инициализирай елемента на масива с '1'
     serial[2] = 49;                                           // Инициализирай елемента на масива с '1'
     serial[3] = 49;                                           // Инициализирай елемента на масива с '1'
     serial[4] = 49;                                           // Инициализирай елемента на масива с '1'
     serial[5] = 49;                                           // Инициализирай елемента на масива с '1'
     serial[6] = 49;                                           // Инициализирай елемента на масива с '1'
     serial[7] = 49;                                           // Инициализирай елемента на масива с '1'
     serial[8] = 49;                                           // Инициализирай елемента на масива с '1'
     serial[9] = 49;                                           // Инициализирай елемента на масива с '1'
     serial[10] = 49;                                          // Инициализирай елемента на масива с '1'
     serial[11] = 49;                                          // Инициализирай елемента на масива с '1'
     serial[12] = 49;                                          // Инициализирай елемента на масива с '1'
     serial[13] = 49;                                          // Инициализирай елемента на масива с '1'
     serial[14] = 0;                                           // Край на стринг
}

void main() {

     InitGlobal();                                             // Глобални инициализации
     
     Lcd_Out(1, 1, "Rh:");
     Lcd_Out(1,10,"%");
     Lcd_Out(2,1,"Frequency:");
     Lcd_Out(2,15,"Hz");


  while (1) {
          if( oldCount >=6033 & oldCount<= 7351 ) {           // Rh = 565.3-(oldCount*0.07675) Това е полинома
                       Rh = 565.3-(oldCount*0.0765);
                       oldRh = Rh;                            // Ако има грешка върни предишна стойност
     // Това е полином от 3-степен в случая работим с полином от 1-степен
     // Rh = (6.262*oldCount*0.001*oldCount*0.001*oldCount*0.001)-(132.1*oldCount*0.001*oldCount*0.001)+(847.8*oldCount*0.001)-1583;
     }
     else {
          //if( oldCount < 6032 |  oldCount > 7350 ) {
              Rh = oldRh;
          //}
     }

       // Температурни конверсии
       Ow_Reset(&PORTB, 2);                                                  // Onewire нулиращ сигнал
       Ow_Write(&PORTB, 2, 0xCC);                                            // Издаване на команда SKIP_ROM
       Ow_Write(&PORTB, 2, 0x44);                                            // Издаване на команда CONVERT_T
       Delay_us(120);

        Ow_Reset(&PORTB, 2);
        Ow_Write(&PORTB, 2, 0xCC);                                           // Издаване на команда SKIP_ROM
        Ow_Write(&PORTB, 2, 0xBE);                                           // Издаване на команда READ_SCRATCHPAD
        Delay_ms(400);

        temperature2 =  Ow_Read(&PORTB, 2);
        temperature2 = (Ow_Read(&PORTB, 2) << 8) + temperature2;

        Display_Temperature(temperature2);
        
        //Изкарай резултат на LCD
        WordToStr(oldCount, txt2);
        Lcd_Out(2, 10, txt2);
        WordToStr(Rh, txt);
        Lcd_Out(1,4,txt);
// Стринг за изпращане към мастер контролера
        serial[0] = '1';                                                    // Контролен байт
        serial[1] = (Rh/10)%10 + 48;                                        // Влажност десетици
        serial[2] = Rh%10     + 48;                                         // Влажност единици
        directionF();                                                       // Посока на вятъра
        serial[4] = ((oldCount2/10)%10) + 48;                              // Скорост на вятъра десетици
        serial[5] = (oldCount2%10) + 48;                                   // Скорост на вятъра единици
        serial[6] = temperature[0];                                        // Температура знак
        serial[7] = temperature[1];                                        // Температура десетици
        serial[8] = temperature[2];                                        // Температура единици
        serial[9] = temperature[3];                                        // Температура дробна част
        // CRC проверка на стринга
        serial[10] = (((serial[0] + serial[1] + serial[2] + serial[3] + serial[4] + serial[5] +  serial[7] + serial[8] + serial[9] )%2)+48);
        serial[11] = 0;   // Край на стринга
 Man_Send(0x0B);                                                           // Изпращане на стартов байт
    Delay_ms(100);                                                         // Изчакваме
    character = serial[0];                                                 // Присвои първи символ от стринга
    index = 0;                                                             // Инициализация на  index променлива
    while (character) {                                                    // Стрига завършва с нула
          Man_Send(character);                                             // Изпрати символ
          Delay_ms(90);                                                    // Изчакай
          index++;                                                         // инкрементирай index променливата
          character = serial[index];                                       // Изпрати следващия символ на стринга
    }
    Man_Send(0x0E);                                                        // Изпрати стоп байт
}
}