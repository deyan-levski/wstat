/*
 * Project Name:
     Weather Station Ethernet Server
 * Target Platform:
     PIC 18F4525
 * Copyright:
     (c) Deyan Levski 2011
 *
 *  ver. 0.8
 *      RC0 : !RESET    to ENC reset input pin
 *      RC1 : !CS       to ENC chip select input pin
 *      the ENC28J60 SPI bus CLK, SO, SI must be connected to the corresponding SPI pins of the PIC
 *      the INT and WOL signals from the ENC are not used *
 * Test configuration:
     MCU:             PIC18F4525
     Oscillator:      HS-PLL4, 40.000MHz
 * NOTES:
     - Since the ENC28J60 doesn't support auto-negotiation, full-duplex mode is
       not compatible with most switches/routers.  If a dedicated network is used
       where the duplex of the remote node can be manually configured, you may
       change this configuration.  Otherwise, half duplex should always be used.
     - External power supply should be used due to Serial Ethernet Board power consumption.
 */

 // ver 0.1 ~ 0.5 Major Ethernet Tests
 // ver 0.6 - RTC added
 // ver 0.7 - RTC Set Implemented, Solar Index Added
 // ver 0.8 - UART Tests + Full HTML Index Table
 // ver 0.9 - Sunrise/Sunset Algorithm added // more work needs to be done here
 // ver 0.10 - CSV File added
 // ver 0.11 - CSV File + Graphics added
 // ver 0.12 - Compact Flash card added + CSV logging on card
 // ver 0.13 - Manchester code implemented
 // ver 0.14 - New Page Layout + Wind Direction & Humidity & Soil Temp
 // ver 0.15 - Dew Point Calculator Added
 // ver 0.16 - Double Manchester /Radioactivity Level/ + Octal Bus Transciever

// duplex config flags
#include  "__EthEnc28j60.h"

#define Spi_Ethernet_HALFDUPLEX     0x00  // half duplex
#define Spi_Ethernet_FULLDUPLEX     0x01  // full duplex

// Ethernet pinout
sfr sbit SPI_Ethernet_Rst at LATC0_bit;  // for writing to output pin always use latch (PIC18 family)
sfr sbit SPI_Ethernet_CS  at LATC1_bit;  // for writing to output pin always use latch (PIC18 family)
sfr sbit SPI_Ethernet_Rst_Direction at TRISC0_bit;
sfr sbit SPI_Ethernet_CS_Direction  at TRISC1_bit;
// End Ethernet pinout

// Software I2C connections for RTC
sbit Soft_I2C_Scl           at RD3_bit;
sbit Soft_I2C_Sda           at RD2_bit;
sbit Soft_I2C_Scl_Direction at TRISD3_bit;
sbit Soft_I2C_Sda_Direction at TRISD2_bit;
// End Software I2C connections for RTC

// Manchester module connections
sbit MANRXPIN at RE0_bit;                           //RC7_bit
sbit MANRXPIN_Direction at TRISE0_bit;              // TRISC7_bit
/*sbit MANTXPIN at RC6_bit;
sbit MANTXPIN_Direction at TRISC6_bit;*/
// End Manchester module connections

/************************************************************
 * ROM constant strings
 */
const code unsigned char httpHeader[] = "HTTP/1.1 200 OK\nContent-type: " ;  // HTTP header
const code unsigned char httpMimeTypeHTML[] = "text/html\n\n" ;              // HTML MIME type
const code unsigned char httpMimeTypeScript[] = "text/plain\n\n" ;           // TEXT MIME type
unsigned char httpMethod[] = "GET /";

//<meta http-equiv=\"refresh\" content=\"2\">
 
// <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\
 
const code   char    *indexPage = "<html>\
<head>\
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />\
<meta http-equiv=\"refresh\" content=\"10\">\
</head>\
<body>\
<script src=/s></script>\
<script>function w(x) {document.write(x);}</script>\
<CENTER>\
<h1>Automatic Weather Station - LAT: 43.805606N, LON: 25.933868E</h1>\
<p><a href=g>24h Stats</a> ---\
  <a href=x>CSV Page</a>\
<p>&nbsp;</p>\
<table border=\"9\">\
<tr>\
<td>Temperature:</td><td><script>document.write(MNS,TW1,TW2,'.',TF,TF1)</script> C</td>\
" ;

const code char *indexPage2 = "<td>Wind Speed:</td><td><script>w(WS)</script> m/s</td>\
<td>Wind Direction:</td><td><script>w(WD)</script></td>\
<td>Humidity:</td><td><script>w(RH)</script> %</td>\
</tr>\<tr>\
<td>Pressure:</td><td><script>w(BP)</script> hPa</td>\
<td>Soil Temperature:</td><td><script>document.write(MNS2,ST)</script> C</td>\
<td>Solar Radiation:</td><td><script>w(AN3)</script> W/m<SUP>2</SUP></td>\
<td>Background Radioactivity:</td><td><script>w(RAD2)</script> uSv/h</td>\
</tr>\
" ;

const code   char    *indexPage3 = "<tr>\
<td>Dew Point:</td><td><script>w(TD)</script> C</td>\
<td>Heat Index:</td><td><script>w(DP)</script> C</td>\
<td>Time:</td><td><script>document.write(HR,'-',MN,'-',SC)</script></td>\
<td>Date:</td><td><script>document.write(DY,'-',MH,'-201',YR)</script></td>\
</tr>\
</table>\
<p>&nbsp;</p>\
</center>\
<HR>\
Copyright 2011 - Dilema Ltd. - Eng. Deyan Levski, Sredna Kula, Ruse, BULGARIA\
</body>\
</html>\
" ;

const code char *graphPage =
"<html>\n\
<head>\n\
<table align=\"center\">\
<tr>\
<td>\
<script type=\"text/javascript\"\n\
src=\"http://www.dilemaltd.com/deyan-levski/dygraph-combined.js\"></script>\n\
</head>\n\
<body>\n\
<center>\
<h4>Daily Air, Soil Temperature [C] and Air Humidity [%]</h4></center>\
<div id=\"graphdiv\"style=\"width:800px; height:400px;\"></div>\n\
<script type=\"text/javascript\">\n\
g = new Dygraph(  \n\
document.getElementById(\"graphdiv\"),\
\"x.csv\",\n\
{\n\
labels: [ 'Date', 'AirTemp', 'SoilTemp', 'Humidity' ],\
            'AirTemp': {\
              axis: {\
              }\
            },\
            'SoilTemp': {\
              axis: 'AirTemp'\
            },\
            axes: {\
              Humidity: {\
                labelsKMB: true\
              }\
            }\
          }\
);\n\
</script>\n\
<center>\
<h4>Copyright 2011 - Eng. Deyan Levski</h4></center>\
</body>\n\
</html>\
";

/***********************************
 * RAM variables
 */
unsigned char   myMacAddr[6] = {0x00, 0x14, 0xA5, 0x76, 0x19, 0x3f} ;   // my MAC address
unsigned char   myIpAddr[4]  = {192, 168,   20,  60 } ;                   // my IP address
unsigned char   gwIpAddr[4]  = {192, 168,   20,  1 } ;                   // gateway (router) IP address
unsigned char   ipMask[4]    = {255, 255, 255,  0 } ;                   // network mask (for example : 255.255.255.0)
unsigned char   dnsIpAddr[4] = {192, 168,   20,  1 } ;                   // DNS server IP address

unsigned char   getRequest[25] ;                                        // HTTP request buffer
unsigned char   dyna[29] ;                                              // buffer for dynamic response
unsigned char   csvbuft[1368];                                          // buffer for the temperature csv file


#define putConstString  SPI_Ethernet_putConstString

#define putString  SPI_Ethernet_putString

#define putConstBytes SPI_Ethernet_putConstBytes


         //        THERMOMETER Variables
    const unsigned short TEMP_RESOLUTION = 12;
    unsigned int temp;
    const unsigned short RES_SHIFT = TEMP_RESOLUTION - 8;
    unsigned int minus;
    unsigned int temp_whole;
    unsigned int temp_whole_1;
    unsigned int temp_whole_2;
    unsigned int temp_fraction;
    unsigned int temp_fraction_1;
    unsigned int temp_fraction_2;
         //       End THERMOMETER Variables



         //  RTC Variables
    unsigned int seconds, minutes, hours, day, month, year; // Global date/time variables
    unsigned int seconds1, minutes1, hours1, day1, month1, year1; // Global date/time variables
    unsigned int seconds2, minutes2, hours2, day2, month2; // Global date/time variables
         //  End RTC Variables

   char strHH[3], strMM[3], strSS[3], strDD[3], strMO[3], strYY[3]; // Set RTC variables

        //  Solar Index Variables
//        float SI_raw, SI_sraw, SI_asraw;
        unsigned int SI_fin, RH;//, SI_wh, SI_fr, RH;
        //  End Solar Index Variables

         // Sunrise / Sunset Variables

       /*double pi = 3.14159;
         double degs;
         double rads;
         double L,g,daylen;
         double SunDia = 0.53;
         double AirRefr = 34.0/60.0;
         long int luku;*/

         // END Sunrise / Sunset Variables

         // Manchester Code Variables
    char error, ErrorCount, tempman;
    char manch[14], manch2[14];
    unsigned m;

    unsigned char WS[8], WD[8], ST[8], BP[8], MNS2[8], RAD[8];
         // End Manchester Code Variables
         
    // Parameter Calculation Variables
  /*unsigned short int Rh_conv;
    short int TDew;
    short int tempdp;
    char TD[8];*/
    // End Parameter Calculation Variables

unsigned int  SPI_Ethernet_UserTCP(unsigned char *remoteHost, unsigned int remotePort, unsigned int localPort, unsigned int reqLength, TEthPktFlags *flags)
        {

        unsigned int    len;            // my reply length


        strHH[2] = strMM[2] = strSS[2] = 0;

      //   *canClose = 0; // 0 - do not close socket
                          // otherwise - close socket

        if(localPort != 80)                         // I listen only to web request on port 80
                {
                return(0) ;
                }

        // get 20 first bytes only of the request, the rest is blah blah
        for(len = 0 ; len < 20 ; len++)
        {
        getRequest[len] = SPI_Ethernet_getByte() ;
        }
        getRequest[len] = 0 ;
        len = 0;

        if(memcmp(getRequest, httpMethod, 5))       // only GET method
                {
                return(0) ;
                }

        if(getRequest[5] == 't') {
               strHH[0] = getRequest[6];
               strHH[1] = getRequest[7];

               strMM[0] = getRequest[8];
               strMM[1] = getRequest[9];

               strSS[0] = getRequest[10];
               strSS[1] = getRequest[11];

               strDD[0] = getRequest[12];
               strDD[1] = getRequest[13];

               strMO[0] = getRequest[14];
               strMO[1] = getRequest[15];

               strYY[0] = getRequest[16];
               strYY[1] = getRequest[17];

        //STOP THE RTC COUNTER
   Soft_I2C_Start();      // Issue start signal
   Soft_I2C_Write(0xA0);  // Address PCF8583, see PCF8583 datasheet
   Soft_I2C_Write(0);     // Start from address 0 (configuration memory location)
   Soft_I2C_Write(0x80);  // Write 0x80 to configuration memory location (pause counter...)
   Soft_I2C_Stop();       // Issue stop signal

        //WRITE TO RTC
   Soft_I2C_Start();      // Issue start signal
   Soft_I2C_Write(0xA0);  // Address PCF8583, see PCF8583 datasheet
   Soft_I2C_Write(0);     // Start from address 0 (configuration memory location)
   Soft_I2C_Write(0x80);  // Write 0x80 to configuration memory location (pause counter...)
   Soft_I2C_Write(0);     // Write 0 to cents memory location
   Soft_I2C_Write(Dec2Bcd(atoi(strSS)));  // Write 0 to seconds memory location
   Soft_I2C_Write(Dec2Bcd(atoi(strMM)));  // Write 0x30 to minutes memory location
   Soft_I2C_Write(Dec2Bcd(atoi(strHH)));  // Write 0x12 to hours memory location
   Soft_I2C_Write((Dec2Bcd(atoi(strDD))&0x3F)|((Dec2Bcd(atoi(strYY))&0x03)<<6));  // Write 0x24 to year/date memory location
   Soft_I2C_Write(Dec2Bcd(atoi(strMO)));  // Write 0x08 to weekday/month memory location
   Soft_I2C_Stop();       // Issue stop signal

        //RESTART THE RTC COUNTER
   Soft_I2C_Start();      // Issue start signal
   Soft_I2C_Write(0xA0);  // Address PCF8530
   Soft_I2C_Write(0);     // Start from address 0
   Soft_I2C_Write(0);     // Write 0 to configuration memory location (enable counting)
   Soft_I2C_Stop();       // Issue stop signal

        }

        else if(getRequest[5] == 's')                    // if request path name starts with s, store dynamic data in transmit buffer
                {
                // the text string replied by this request can be interpreted as javascript statements
                // by browsers

                len = putConstString(httpHeader) ;              // HTTP header
                len += putConstString(httpMimeTypeScript) ;     // with text MIME type

                Delay_us(120);
                // Solar Index
                SI_fin=ADC_Read(3); //*0.004964;
                SI_fin=SI_fin*2;

                WordToStr(SI_fin, dyna) ;
                len += putConstString("var AN3=") ;
                len += putString(dyna) ;
                len += putConstString(";") ;

              //  Lcd_Out(1,1,dyna);  // Write http requests on LCD

              // Gather Temperature
    Ow_Reset(&PORTE, 2);                         // Onewire reset signal
    Ow_Write(&PORTE, 2, 0xCC);                   // Issue command SKIP_ROM
    Ow_Write(&PORTE, 2, 0x44);                   // Issue command CONVERT_T
    Delay_us(120);

    Ow_Reset(&PORTE, 2);
    Ow_Write(&PORTE, 2, 0xCC);                   // Issue command SKIP_ROM
    Ow_Write(&PORTE, 2, 0xBE);                   // Issue command READ_SCRATCHPAD
    Delay_us(120);
    
    temp =  Ow_Read(&PORTE, 2);
    temp = (Ow_Read(&PORTE, 2) << 8) + temp;

  // Extract temp_whole

     if (temp & 0x8000) {
     minus = 1;
     temp = ~temp + 1; }
     else {
     minus = 0;
     }

  temp_whole = temp >> RES_SHIFT ;
  temp_whole_1 = (temp_whole/10)%10 ;
  temp_whole_2 = temp_whole%10 ;
  temp_fraction  = temp << (4-RES_SHIFT);

  temp_fraction_1 =  temp_fraction%10 ;
  temp_fraction_2 = (temp_fraction/10)%10;
   
   
                 if (minus==1){
                 len += putConstString("var MNS=\"-\";") ;
               //  tempdp = (((temp_whole_1*10)+temp_whole_2)*(-1));
                 }
                 else{
                 len += putConstString("var MNS=\"+\";"); 
               //  tempdp = (temp_whole_1*10)+temp_whole_2;
               }

                WordToStr(temp_whole_1, dyna) ;
                len += putConstString("var TW1=") ;
                len += putString(dyna) ;
                len += putConstString(";") ;

                WordToStr(temp_whole_2, dyna) ;
                len += putConstString("var TW2=") ;
                len += putString(dyna) ;
                len += putConstString(";") ;

                WordToStr(temp_fraction_1, dyna) ;
                len += putConstString("var TF=") ;
                len += putString(dyna) ;
                len += putConstString(";") ;

                WordToStr(temp_fraction_2, dyna) ;
                len += putConstString("var TF1=") ;
                len += putString(dyna) ;
                len += putConstString(";") ;

                //RTC

  Soft_I2C_Start();               // Issue start signal
  Soft_I2C_Write(0xA0);           // Address PCF8583, see PCF8583 datasheet
  Soft_I2C_Write(2);              // Start from address 2
  Soft_I2C_Start();               // Issue repeated start signal
  Soft_I2C_Write(0xA1);           // Address PCF8583 for reading R/W=1

  seconds = Soft_I2C_Read(1);     // Read seconds byte
  minutes = Soft_I2C_Read(1);     // Read minutes byte
  hours = 0x3f&Soft_I2C_Read(1);       // Read hours byte
  day = Soft_I2C_Read(1);         // Read year/day byte
  month = Soft_I2C_Read(0);       // Read weekday/month byte
  Soft_I2C_Stop();                // Issue stop signal

  seconds  =  ((seconds & 0xF0) >> 4)*10 + (seconds & 0x0F);  // Transform seconds
  minutes  =  ((minutes & 0xF0) >> 4)*10 + (minutes & 0x0F);  // Transform months
  hours    =  ((hours & 0xF0)  >> 4)*10  + (hours & 0x0F);    // Transform hours
  year     =   (day & 0xC0) >> 6;                             // Transform year
  day      =  ((day & 0x30) >> 4)*10    + (day & 0x0F);       // Transform day
  month    =  ((month & 0x10)  >> 4)*10 + (month & 0x0F);     // Transform month


                WordToStr(hours, dyna) ;
                len += putConstString("var HR=") ;
                len += putString(dyna) ;
                len += putConstString(";") ;
                WordToStr(minutes, dyna) ;
                len += putConstString("var MN=") ;
                len += putString(dyna) ;
                len += putConstString(";") ;
                WordToStr(seconds, dyna) ;
                len += putConstString("var SC=") ;
                len += putString(dyna) ;
                len += putConstString(";") ;
                WordToStr(day, dyna) ;
                len += putConstString("var DY=") ;
                len += putString(dyna) ;
                len += putConstString(";") ;
                WordToStr(month, dyna) ;
                len += putConstString("var MH=") ;
                len += putString(dyna) ;
                len += putConstString(";") ;
                WordToStr(year, dyna) ;
                len += putConstString("var YR=") ;
                len += putString(dyna) ;
                len += putConstString(";") ;
                // RTC END

                // Manchester Pump
                RH=ADC_Read(1); //*0.004964;
                if(RH>=1000) {
                RH=100;
                }
                else{
                RH=RH/10;
                }
                
                WordToStr(RH, dyna) ;
                len += putConstString("var RH=\"") ;
                len += putString(dyna) ;
                len += putConstString("\";") ;

                len += putConstString("var WD=\"") ;
                
                switch(WD[0]){

                case '1':  len += putConstString("North") ; break;
                case '2':  len += putConstString("North-East") ; break;
                case '3':  len += putConstString("East") ; break;
                case '4':  len += putConstString("South-East") ; break;
                case '5':  len += putConstString("South") ; break;
                case '6':  len += putConstString("South-West") ; break;
                case '7':  len += putConstString("West") ; break;
                case '8':  len += putConstString("North-West") ; break;
                }

                len += putConstString("\";") ;

                len += putConstString("var WS=\"") ;
                len += putString(WS) ;
                len += putConstString("\";") ;

                len += putConstString("var MNS2=\"") ;
                len += putString(MNS2) ;
                len += putConstString("\";") ;

                len += putConstString("var ST=\"") ;
                len += putString(ST) ;
                len += putConstString("\";") ;

                len += putConstString("var BP=\"") ;
                len += putString(BP) ;
                len += putConstString("\";") ;

                /*TDew=(tempdp-((100-Rh_conv)*0.2));
                 ShortToStr(TDew,TD);
                 len += putConstString("var TD=\"") ;
                 len += putString(TD) ;
                 len += putConstString(".00\";") ;*/
                 
                 //wcf ~= 36 + 5/8T – 36V^1/6 + 7/16TV^1/6 Wind Chill Formula
                 
                 len += putConstString("var RAD2=\"");
                 len += putString(RAD);
                 len += putConstString("\";");
                 
                 // End Manchester Pump
                 
                 }

                  else if(getRequest[5] == 'x')                           // if request path name starts with t, toggle PORTD (LED) bit number that comes after
                 {
                 len = putConstString("Date,AirTemp,SoilTemp,Humidity\n") ;
                 len += putString(csvbuft) ;
                 }

                    else if(getRequest[5] == 'u')
                    {
                   len = putConstString("Slave 1:\n");
                   len += putString(manch);
                   len += putConstString("\nSlave 2:\n");
                   len += putString(manch2);
                   }

        else if(getRequest[5] == 'g')                           // if request path name starts with t, toggle PORTD (LED) bit number that comes after
                {
        len =  putConstString(httpHeader) ;             // HTTP header
        len += putConstString(httpMimeTypeHTML) ;       // with HTML MIME type
        len += putConstString(graphPage) ;              // HTML page first part
                }
        if(len == 0)                                            // what do to by default
                {
                len =  putConstString(httpHeader) ;             // HTTP header
                len += putConstString(httpMimeTypeHTML) ;       // with HTML MIME type
                len += putConstString(indexPage) ;              // HTML page first part
                len += putConstString(indexPage2) ;             // HTML page second part
                len += putConstString(indexPage3) ;             // HTML page third part
                }

        return(len) ;                                          // return to the library with the number of bytes to transmit

        }
/*
 * this function is called by the library
 * the user accesses to the UDP request by successive calls to Spi_Ethernet_getByte()
 * the user puts data in the transmit buffer by successive calls to Spi_Ethernet_putByte()
 * the function must return the length in bytes of the UDP reply, or 0 if nothing to transmit
 *
 * if you don't need to reply to UDP requests,
 * just define this function with a return(0) as single statement
 *
 */
unsigned int  SPI_Ethernet_UserUDP(unsigned char *remoteHost, unsigned int remotePort, unsigned int destPort, unsigned int reqLength, TEthPktFlags *flags)
        {
        unsigned int    len ;                           // my reply length

        // reply is made of the remote host IP address in human readable format
        ByteToStr(remoteHost[0], dyna) ;                // first IP address byte
        dyna[3] = '.' ;
        ByteToStr(remoteHost[1], dyna + 4) ;            // second
        dyna[7] = '.' ;
        ByteToStr(remoteHost[2], dyna + 8) ;            // third
        dyna[11] = '.' ;
        ByteToStr(remoteHost[3], dyna + 12) ;           // fourth

        dyna[15] = ':' ;                                // add separator

        // then remote host port number
        WordToStr(remotePort, dyna + 16) ;
        dyna[21] = '[' ;
        WordToStr(destPort, dyna + 22) ;
        dyna[27] = ']' ;
        dyna[28] = 0 ;

        // the total length of the request is the length of the dynamic string plus the text of the request
        len = 28 + reqLength;

        // puts the dynamic string into the transmit buffer
        SPI_Ethernet_putBytes(dyna, 28) ;

        // then puts the request string converted into upper char into the transmit buffer
        while(reqLength--)
                {
                SPI_Ethernet_putByte(toupper(SPI_Ethernet_getByte())) ;
                }

        return(len) ;           // back to the library with the length of the UDP reply
        }


 void Init_Main_RTC() {

  TRISB = 0;
  PORTB = 0xFF;
  TRISB = 0xff;

  Soft_I2C_Init();           // Initialize Soft I2C communication
}

unsigned int i=0;
unsigned long int cnt=0, manchcnt=0, manchcnt2=0;


//char *cunt, *cunt1;
void    main()
        {

        ErrorCount = 0;
        cnt=0;//358000;
        manchcnt=0;
        manchcnt2=0;
        i=0;

        memset(csvbuft, 0, 1386);
        memset(manch,49,14);
        memset(manch2,49,14);
        memset(WS,0,8);
        memset(WD,0,8);
        memset(ST,0,8);
        memset(BP,0,8);
        memset(MNS2,0,8);
        memset(RAD,0,8);
        
        WS[0]=49;
        WS[1]=49;
        WD[0]=49;
        ST[0]=49;
        ST[1]=49;
        ST[2]='.';
        ST[3]=49;
        BP[0]=49;
        BP[1]=49;
        BP[2]=49;
        BP[3]=49;
        MNS2[0]=49;
        RAD[0] = 49;
        RAD[1] = '.';
        RAD[2] = 49;
        RAD[3] = 49;
        RAD[4] = 0;
        





        ADCON1 = 0x0B ;         // ADC convertors will be used with AN2 and AN3
        CMCON  = 0x07 ;         // turn off comparators



        //PORTA = 0xFF ;
        TRISA3_bit = 1 ;          // set PORTA as input for ADC
        TRISA0_bit = 0;
        TRISA1_bit = 1;           // Input RH
        TRISA4_bit = 0;
        TRISA5_bit = 0;
        PORTD = 0 ;
        TRISD = 0 ;             // set PORTD as output
        TRISC = 1;
       // RCSTA = 1;


        /*
         * starts ENC28J60 with :
         * reset bit on RC0
         * CS bit on RC1
         * my MAC & IP address
         * full duplex
         */
         
        RA5_bit=1;
        RA4_bit=0;
        Man_Receive_Init();
        Delay_ms(150);
        SPI1_Init();
        SPI_Rd_Ptr = SPI1_Read;
        SPI_Ethernet_Init(myMacAddr, myIpAddr, Spi_Ethernet_FULLDUPLEX) ;
        // dhcp will not be used here, so use preconfigured addresses
        SPI_Ethernet_confNetwork(ipMask, gwIpAddr, dnsIpAddr) ;

        //UART1_Init(9600);                             // Initialize UART module at 9200 bps
        Delay_ms(100);                                       // Wait for UART module to stabilize
    //    Spi_Ethernet_writeReg(0x1B, 0xff) ;    //04
    //    Spi_Ethernet_writeReg(0x16, 0xff) ;    //08
    //    Spi_Ethernet_writeReg(0x17, 0xff) ;
    //    Spi_Ethernet_writeReg(0x18, 0xff) ;
        
        Init_Main_RTC();                    // Initialize RTC
        
         RA4_bit=1;
         RA5_bit=1;

        while(1)    {                        // do foreveryear, csvbuf) ;


                cnt=cnt+1;
                manchcnt=manchcnt+1;
                if(cnt==28124000){       //3600000  //18000000  //9008000   //27024000
                                      //Read RTC
  Soft_I2C_Start();               // Issue start signal
  Soft_I2C_Write(0xA0);           // Address PCF8583, see PCF8583 datasheet
  Soft_I2C_Write(2);              // Start from address 2
  Soft_I2C_Start();               // Issue repeated start signal
  Soft_I2C_Write(0xA1);           // Address PCF8583 for reading R/W=1

  seconds = Soft_I2C_Read(1);     // Read seconds byte
  minutes = Soft_I2C_Read(1);     // Read minutes byte
  hours = 0x3f&Soft_I2C_Read(1);       // Read hours byte
  day = Soft_I2C_Read(1);         // Read year/day byte
  month = Soft_I2C_Read(0);       // Read weekday/month byte
  Soft_I2C_Stop();                // Issue stop signal

  seconds  =  ((seconds & 0xF0) >> 4)*10 + (seconds & 0x0F);  // Transform seconds
  minutes  =  ((minutes & 0xF0) >> 4)*10 + (minutes & 0x0F);  // Transform months
  hours    =  ((hours & 0xF0)  >> 4)*10  + (hours & 0x0F);    // Transform hours
  year     =   (day & 0xC0) >> 6;                             // Transform year
  day      =  ((day & 0x30) >> 4)*10    + (day & 0x0F);       // Transform day
  month    =  ((month & 0x10)  >> 4)*10 + (month & 0x0F);     // Transform month


                                  //Temperature
    Ow_Reset(&PORTE, 2);                         // Onewire reset signal
    Ow_Write(&PORTE, 2, 0xCC);                   // Issue command SKIP_ROM
    Ow_Write(&PORTE, 2, 0x44);                   // Issue command CONVERT_T
    Delay_us(120);

    Ow_Reset(&PORTE, 2);
    Ow_Write(&PORTE, 2, 0xCC);                   // Issue command SKIP_ROM
    Ow_Write(&PORTE, 2, 0xBE);                   // Issue command READ_SCRATCHPAD
    Delay_us(120);

    temp =  Ow_Read(&PORTE, 2);
    temp = (Ow_Read(&PORTE, 2) << 8) + temp;

  // Extract temp_whole

    if (temp & 0x8000) {
     minus = 1;
     temp = ~temp + 1; }
     else {
     minus = 0;
     }

  temp_whole = temp >> RES_SHIFT ;
  temp_fraction  = temp << (4-RES_SHIFT);
  
                RH=ADC_Read(1); //*0.004964;
                if(RH>=1000) {
                RH=100;
                }
                else{
                RH=RH/10;
                }

                csvbuft[i+0]='2';
                csvbuft[i+1]='0';
                csvbuft[i+2]='1';
                csvbuft[i+3]=year+'0';
                csvbuft[i+4]='-';
                csvbuft[i+5]=(month/10)%10 + '0';
                csvbuft[i+6]=month%10 + '0';
                csvbuft[i+7]='-';
                csvbuft[i+8]=(day/10)%10 + '0';
                csvbuft[i+9]=day%10 + '0';
                csvbuft[i+10] = ' ';
                csvbuft[i+11] = (hours/10)%10 + '0';
                csvbuft[i+12] = hours%10 + '0';
                csvbuft[i+13] = ':';
                csvbuft[i+14] = (minutes/10)%10 + '0';
                csvbuft[i+15] = minutes%10 + '0';
                csvbuft[i+16] = ':';
                csvbuft[i+17] = (seconds/10)%10 + '0';
                csvbuft[i+18] = seconds%10 + '0';
                csvbuft[i+19] = ',';
                if (minus==1){csvbuft[i+20] = '-';}
                else {csvbuft[i+20] = '+';}
                csvbuft[i+21] = (temp_whole/10)%10 + '0';
                csvbuft[i+22] = temp_whole%10 + '0';
                csvbuft[i+23] = '.';
                csvbuft[i+24] = temp_fraction%10 + '0';
                csvbuft[i+25] = (temp_fraction/10)%10 + '0';
                csvbuft[i+26] = ',';
                csvbuft[i+27] = MNS2[0];
                csvbuft[i+28] = ST[0];
                csvbuft[i+29] = ST[1];
                csvbuft[i+30] = '.';
                csvbuft[i+31] = ST[3];
                csvbuft[i+32] = ',';
                csvbuft[i+33] = (RH/10)%10 + '0';
                csvbuft[i+34] = RH%10 + '0';
                csvbuft[i+35] = '\n';
                i=i+36;
                if (i==1368){
                i=0;
                }
                cnt=0;
                }

                if (manchcnt==2000000){

         m=0;
         RA5_bit=1;
         RA4_bit=0;
         Delay_ms(10);
         while (1) {
        tempman = Man_Receive(&error);               // Attempt byte receive
        if (tempman == 0x0B)                         // "Start" byte, see Transmitter example
          break;                                  // We got the starting sequence
        if (error)                                // Exit so we do not loop forever
          break;
        }

      do
        {
          tempman = Man_Receive(&error);             // Attempt byte receive
          if (error) {                            // If error occured
            ErrorCount++;                         // Update error counter
            if (ErrorCount > 20) {                // In case of multiple errors
              tempman = Man_Synchro();               // Try to synchronize again
              Man_Receive_Init();               // Alternative, try to Initialize Receiver again
              ErrorCount = 0;                     // Reset error counter
              }
            }
          else {                                  // No error occured
            if (tempman != 0x0E)
            manch[m]=tempman;                     // If "End" byte was received(see Transmitter example)
            m++;
              }
          Delay_ms(25);
        }

      while (tempman != 0x0E) ;                      // If "End" byte was received exit do loop
            m=0;
            manchcnt=0;
            manch[9]=0;
            

            if((manch[0]==49) && ((manch[0] + manch[1] + manch[2] + manch[3] + manch[4] + manch[5] + manch[6] + manch[7])%2)+48==manch[8]){
            
            WD[0]=manch[3];
            WD[1]=0;

            WS[0]=manch[1];
            WS[1]=manch[2];
            WS[2]=0;

            MNS2[0]=manch[4];
            MNS2[1]=0;
            
            ST[0]=manch[5];
            ST[1]=manch[6];
            ST[2]='.';
            ST[3]=manch[7];
            ST[4]=0;

            RA4_bit=1;
            RA5_bit=1;
            Delay_ms(25);
           }
             }
             manchcnt2++;
           if(manchcnt2==3200000){
             RA4_bit=1;
             RA5_bit=0;
             Delay_ms(10);

            while (1) {
        tempman = Man_Receive(&error);               // Attempt byte receive
        if (tempman == 0x0B)                         // "Start" byte, see Transmitter example
          break;                                  // We got the starting sequence
        if (error)                                // Exit so we do not loop forever
          break;
        }

      do
        {
          tempman = Man_Receive(&error);             // Attempt byte receive
          if (error) {                            // If error occured
            ErrorCount++;                         // Update error counter
            if (ErrorCount > 20) {                // In case of multiple errors
              tempman = Man_Synchro();               // Try to synchronize again
              Man_Receive_Init();               // Alternative, try to Initialize Receiver again
              ErrorCount = 0;                     // Reset error counter
              }
            }
          else {                                  // No error occured
            if (tempman != 0x0E)
            manch2[m]=tempman;                     // If "End" byte was received(see Transmitter example)
            m++;
              }
          Delay_ms(25);
        }

      while (tempman != 0x0E) ;                      // If "End" byte was received exit do loop
            m=0;
            manchcnt2=0;
            manch2[9]=0;
            if((manch2[0]==49) && ((manch2[0] + manch2[1] + manch2[2] + manch2[3] + manch2[4] + manch2[5] + manch2[6] + manch2[7])%2)+48==manch2[8]){
            BP[0]=manch2[1];
            BP[1]=manch2[2];
            BP[2]=manch2[3];
            BP[3]=manch2[4];
            BP[4]=0;
            
            RAD[0] = manch2[5];
            RAD[1] = '.' ;
            RAD[2] = manch2[6];
            RAD[3] = manch2[7];
            RAD[4] = 0;

            RA5_bit=1;
            RA4_bit=1;
           }
            }

                SPI_Ethernet_doPacket() ;   // process incoming Ethernet packets

                }
                
                
}