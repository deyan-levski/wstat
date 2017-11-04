#line 1 "C:/Documents and Settings/Administrator/Desktop/Source PIC/HTTP_Demo.c"
#line 1 "c:/documents and settings/administrator/desktop/source pic/__ethenc28j60.h"
#line 119 "c:/documents and settings/administrator/desktop/source pic/__ethenc28j60.h"
typedef struct
 {
 unsigned char valid;
 unsigned long tmr;
 unsigned char ip[4];
 unsigned char mac[6];
 } SPI_Ethernet_arpCacheStruct;

extern SPI_Ethernet_arpCacheStruct SPI_Ethernet_arpCache[];

extern unsigned char SPI_Ethernet_macAddr[6];
extern unsigned char SPI_Ethernet_ipAddr[4];
extern unsigned char SPI_Ethernet_gwIpAddr[4];
extern unsigned char SPI_Ethernet_ipMask[4];
extern unsigned char SPI_Ethernet_dnsIpAddr[4];
extern unsigned char SPI_Ethernet_rmtIpAddr[4];

extern unsigned long SPI_Ethernet_userTimerSec;

typedef struct {
 unsigned canCloseTCP: 1;
 unsigned isBroadcast: 1;
} TEthPktFlags;
#line 146 "c:/documents and settings/administrator/desktop/source pic/__ethenc28j60.h"
extern void SPI_Ethernet_Init(unsigned char *resetPort, unsigned char resetBit, unsigned char *CSport, unsigned char CSbit, unsigned char *mac, unsigned char *ip, unsigned char fullDuplex);
extern unsigned char SPI_Ethernet_doPacket();
extern void SPI_Ethernet_putByte(unsigned char b);
extern void SPI_Ethernet_putBytes(unsigned char *ptr, unsigned int n);
extern void SPI_Ethernet_putConstBytes(const unsigned char *ptr, unsigned int n);
extern unsigned char SPI_Ethernet_getByte();
extern void SPI_Ethernet_getBytes(unsigned char *ptr, unsigned int addr, unsigned int n);
extern unsigned int SPI_Ethernet_UserUDP(unsigned char *remoteHost, unsigned int remotePort, unsigned int localPort, unsigned int reqLength, TEthPktFlags * flags);
extern unsigned int SPI_Ethernet_UserTCP(unsigned char *remoteHost, unsigned int remotePort, unsigned int localPort, unsigned int reqLength, TEthPktFlags * flags);
extern void SPI_Ethernet_confNetwork(char *ipMask, char *gwIpAddr, char *dnsIpAddr);
#line 45 "C:/Documents and Settings/Administrator/Desktop/Source PIC/HTTP_Demo.c"
sfr sbit SPI_Ethernet_Rst at LATC0_bit;
sfr sbit SPI_Ethernet_CS at LATC1_bit;
sfr sbit SPI_Ethernet_Rst_Direction at TRISC0_bit;
sfr sbit SPI_Ethernet_CS_Direction at TRISC1_bit;



sbit Soft_I2C_Scl at RD3_bit;
sbit Soft_I2C_Sda at RD2_bit;
sbit Soft_I2C_Scl_Direction at TRISD3_bit;
sbit Soft_I2C_Sda_Direction at TRISD2_bit;



sbit MANRXPIN at RE0_bit;
sbit MANRXPIN_Direction at TRISE0_bit;
#line 68 "C:/Documents and Settings/Administrator/Desktop/Source PIC/HTTP_Demo.c"
const code unsigned char httpHeader[] = "HTTP/1.1 200 OK\nContent-type: " ;
const code unsigned char httpMimeTypeHTML[] = "text/html\n\n" ;
const code unsigned char httpMimeTypeScript[] = "text/plain\n\n" ;
unsigned char httpMethod[] = "GET /";
#line 93 "C:/Documents and Settings/Administrator/Desktop/Source PIC/HTTP_Demo.c"
const code char *indexPage = "<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /><meta http-equiv=\"refresh\" content=\"10\"></head><body><script src=/s></script><script>function w(x) {document.write(x);}</script><CENTER><h1>Automatic Weather Station - LAT: 43.805606N, LON: 25.933868E</h1><p><a href=g>24h Stats</a> ---  <a href=x>CSV Page</a><p>&nbsp;</p><table border=\"9\"><tr><td>Temperature:</td><td><script>document.write(MNS,TW1,TW2,'.',TF,TF1)</script> C</td>" ;
#line 104 "C:/Documents and Settings/Administrator/Desktop/Source PIC/HTTP_Demo.c"
const code char *indexPage2 = "<td>Wind Speed:</td><td><script>w(WS)</script> m/s</td><td>Wind Direction:</td><td><script>w(WD)</script></td><td>Humidity:</td><td><script>w(RH)</script> %</td></tr>\<tr><td>Pressure:</td><td><script>w(BP)</script> hPa</td><td>Soil Temperature:</td><td><script>document.write(MNS2,ST)</script> C</td><td>Solar Radiation:</td><td><script>w(AN3)</script> W/m<SUP>2</SUP></td><td>Background Radioactivity:</td><td><script>w(RAD2)</script> uSv/h</td></tr>" ;
#line 119 "C:/Documents and Settings/Administrator/Desktop/Source PIC/HTTP_Demo.c"
const code char *indexPage3 = "<tr><td>Dew Point:</td><td><script>w(TD)</script> C</td><td>Heat Index:</td><td><script>w(DP)</script> C</td><td>Time:</td><td><script>document.write(HR,'-',MN,'-',SC)</script></td><td>Date:</td><td><script>document.write(DY,'-',MH,'-201',YR)</script></td></tr></table><p>&nbsp;</p></center><HR>Copyright 2011 - Dilema Ltd. - Eng. Deyan Levski, Sredna Kula, Ruse, BULGARIA</body></html>" ;

const code char *graphPage =
#line 159 "C:/Documents and Settings/Administrator/Desktop/Source PIC/HTTP_Demo.c"
"<html>\n<head>\n<table align=\"center\"><tr><td><script type=\"text/javascript\"\nsrc=\"http://www.dilemaltd.com/deyan-levski/dygraph-combined.js\"></script>\n</head>\n<body>\n<center><h4>Daily Air, Soil Temperature [C] and Air Humidity [%]</h4></center><div id=\"graphdiv\"style=\"width:800px; height:400px;\"></div>\n<script type=\"text/javascript\">\ng = new Dygraph(  \ndocument.getElementById(\"graphdiv\"),\"x.csv\",\n{\nlabels: [ 'Date', 'AirTemp', 'SoilTemp', 'Humidity' ],            'AirTemp': {              axis: {              }            },            'SoilTemp': {              axis: 'AirTemp'            },            axes: {              Humidity: {                labelsKMB: true              }            }          });\n</script>\n<center><h4>Copyright 2011 - Eng. Deyan Levski</h4></center></body>\n</html>";
#line 164 "C:/Documents and Settings/Administrator/Desktop/Source PIC/HTTP_Demo.c"
unsigned char myMacAddr[6] = {0x00, 0x14, 0xA5, 0x76, 0x19, 0x3f} ;
unsigned char myIpAddr[4] = {192, 168, 20, 60 } ;
unsigned char gwIpAddr[4] = {192, 168, 20, 1 } ;
unsigned char ipMask[4] = {255, 255, 255, 0 } ;
unsigned char dnsIpAddr[4] = {192, 168, 20, 1 } ;

unsigned char getRequest[25] ;
unsigned char dyna[29] ;
unsigned char csvbuft[1368];










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





 unsigned int seconds, minutes, hours, day, month, year;
 unsigned int seconds1, minutes1, hours1, day1, month1, year1;
 unsigned int seconds2, minutes2, hours2, day2, month2;


 char strHH[3], strMM[3], strSS[3], strDD[3], strMO[3], strYY[3];



 unsigned int SI_fin, RH;
#line 223 "C:/Documents and Settings/Administrator/Desktop/Source PIC/HTTP_Demo.c"
 char error, ErrorCount, tempman;
 char manch[14], manch2[14];
 unsigned m;

 unsigned char WS[8], WD[8], ST[8], BP[8], MNS2[8], RAD[8];
#line 237 "C:/Documents and Settings/Administrator/Desktop/Source PIC/HTTP_Demo.c"
unsigned int SPI_Ethernet_UserTCP(unsigned char *remoteHost, unsigned int remotePort, unsigned int localPort, unsigned int reqLength, TEthPktFlags *flags)
 {

 unsigned int len;


 strHH[2] = strMM[2] = strSS[2] = 0;




 if(localPort != 80)
 {
 return(0) ;
 }


 for(len = 0 ; len < 20 ; len++)
 {
 getRequest[len] = SPI_Ethernet_getByte() ;
 }
 getRequest[len] = 0 ;
 len = 0;

 if(memcmp(getRequest, httpMethod, 5))
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


 Soft_I2C_Start();
 Soft_I2C_Write(0xA0);
 Soft_I2C_Write(0);
 Soft_I2C_Write(0x80);
 Soft_I2C_Stop();


 Soft_I2C_Start();
 Soft_I2C_Write(0xA0);
 Soft_I2C_Write(0);
 Soft_I2C_Write(0x80);
 Soft_I2C_Write(0);
 Soft_I2C_Write(Dec2Bcd(atoi(strSS)));
 Soft_I2C_Write(Dec2Bcd(atoi(strMM)));
 Soft_I2C_Write(Dec2Bcd(atoi(strHH)));
 Soft_I2C_Write((Dec2Bcd(atoi(strDD))&0x3F)|((Dec2Bcd(atoi(strYY))&0x03)<<6));
 Soft_I2C_Write(Dec2Bcd(atoi(strMO)));
 Soft_I2C_Stop();


 Soft_I2C_Start();
 Soft_I2C_Write(0xA0);
 Soft_I2C_Write(0);
 Soft_I2C_Write(0);
 Soft_I2C_Stop();

 }

 else if(getRequest[5] == 's')
 {



 len =  SPI_Ethernet_putConstString (httpHeader) ;
 len +=  SPI_Ethernet_putConstString (httpMimeTypeScript) ;

 Delay_us(120);

 SI_fin=ADC_Read(3);
 SI_fin=SI_fin*2;

 WordToStr(SI_fin, dyna) ;
 len +=  SPI_Ethernet_putConstString ("var AN3=") ;
 len +=  SPI_Ethernet_putString (dyna) ;
 len +=  SPI_Ethernet_putConstString (";") ;




 Ow_Reset(&PORTE, 2);
 Ow_Write(&PORTE, 2, 0xCC);
 Ow_Write(&PORTE, 2, 0x44);
 Delay_us(120);

 Ow_Reset(&PORTE, 2);
 Ow_Write(&PORTE, 2, 0xCC);
 Ow_Write(&PORTE, 2, 0xBE);
 Delay_us(120);

 temp = Ow_Read(&PORTE, 2);
 temp = (Ow_Read(&PORTE, 2) << 8) + temp;



 if (temp & 0x8000) {
 minus = 1;
 temp = ~temp + 1; }
 else {
 minus = 0;
 }

 temp_whole = temp >> RES_SHIFT ;
 temp_whole_1 = (temp_whole/10)%10 ;
 temp_whole_2 = temp_whole%10 ;
 temp_fraction = temp << (4-RES_SHIFT);

 temp_fraction_1 = temp_fraction%10 ;
 temp_fraction_2 = (temp_fraction/10)%10;


 if (minus==1){
 len +=  SPI_Ethernet_putConstString ("var MNS=\"-\";") ;

 }
 else{
 len +=  SPI_Ethernet_putConstString ("var MNS=\"+\";");

 }

 WordToStr(temp_whole_1, dyna) ;
 len +=  SPI_Ethernet_putConstString ("var TW1=") ;
 len +=  SPI_Ethernet_putString (dyna) ;
 len +=  SPI_Ethernet_putConstString (";") ;

 WordToStr(temp_whole_2, dyna) ;
 len +=  SPI_Ethernet_putConstString ("var TW2=") ;
 len +=  SPI_Ethernet_putString (dyna) ;
 len +=  SPI_Ethernet_putConstString (";") ;

 WordToStr(temp_fraction_1, dyna) ;
 len +=  SPI_Ethernet_putConstString ("var TF=") ;
 len +=  SPI_Ethernet_putString (dyna) ;
 len +=  SPI_Ethernet_putConstString (";") ;

 WordToStr(temp_fraction_2, dyna) ;
 len +=  SPI_Ethernet_putConstString ("var TF1=") ;
 len +=  SPI_Ethernet_putString (dyna) ;
 len +=  SPI_Ethernet_putConstString (";") ;



 Soft_I2C_Start();
 Soft_I2C_Write(0xA0);
 Soft_I2C_Write(2);
 Soft_I2C_Start();
 Soft_I2C_Write(0xA1);

 seconds = Soft_I2C_Read(1);
 minutes = Soft_I2C_Read(1);
 hours = 0x3f&Soft_I2C_Read(1);
 day = Soft_I2C_Read(1);
 month = Soft_I2C_Read(0);
 Soft_I2C_Stop();

 seconds = ((seconds & 0xF0) >> 4)*10 + (seconds & 0x0F);
 minutes = ((minutes & 0xF0) >> 4)*10 + (minutes & 0x0F);
 hours = ((hours & 0xF0) >> 4)*10 + (hours & 0x0F);
 year = (day & 0xC0) >> 6;
 day = ((day & 0x30) >> 4)*10 + (day & 0x0F);
 month = ((month & 0x10) >> 4)*10 + (month & 0x0F);


 WordToStr(hours, dyna) ;
 len +=  SPI_Ethernet_putConstString ("var HR=") ;
 len +=  SPI_Ethernet_putString (dyna) ;
 len +=  SPI_Ethernet_putConstString (";") ;
 WordToStr(minutes, dyna) ;
 len +=  SPI_Ethernet_putConstString ("var MN=") ;
 len +=  SPI_Ethernet_putString (dyna) ;
 len +=  SPI_Ethernet_putConstString (";") ;
 WordToStr(seconds, dyna) ;
 len +=  SPI_Ethernet_putConstString ("var SC=") ;
 len +=  SPI_Ethernet_putString (dyna) ;
 len +=  SPI_Ethernet_putConstString (";") ;
 WordToStr(day, dyna) ;
 len +=  SPI_Ethernet_putConstString ("var DY=") ;
 len +=  SPI_Ethernet_putString (dyna) ;
 len +=  SPI_Ethernet_putConstString (";") ;
 WordToStr(month, dyna) ;
 len +=  SPI_Ethernet_putConstString ("var MH=") ;
 len +=  SPI_Ethernet_putString (dyna) ;
 len +=  SPI_Ethernet_putConstString (";") ;
 WordToStr(year, dyna) ;
 len +=  SPI_Ethernet_putConstString ("var YR=") ;
 len +=  SPI_Ethernet_putString (dyna) ;
 len +=  SPI_Ethernet_putConstString (";") ;



 RH=ADC_Read(1);
 if(RH>=1000) {
 RH=100;
 }
 else{
 RH=RH/10;
 }

 WordToStr(RH, dyna) ;
 len +=  SPI_Ethernet_putConstString ("var RH=\"") ;
 len +=  SPI_Ethernet_putString (dyna) ;
 len +=  SPI_Ethernet_putConstString ("\";") ;

 len +=  SPI_Ethernet_putConstString ("var WD=\"") ;

 switch(WD[0]){

 case '1': len +=  SPI_Ethernet_putConstString ("North") ; break;
 case '2': len +=  SPI_Ethernet_putConstString ("North-East") ; break;
 case '3': len +=  SPI_Ethernet_putConstString ("East") ; break;
 case '4': len +=  SPI_Ethernet_putConstString ("South-East") ; break;
 case '5': len +=  SPI_Ethernet_putConstString ("South") ; break;
 case '6': len +=  SPI_Ethernet_putConstString ("South-West") ; break;
 case '7': len +=  SPI_Ethernet_putConstString ("West") ; break;
 case '8': len +=  SPI_Ethernet_putConstString ("North-West") ; break;
 }

 len +=  SPI_Ethernet_putConstString ("\";") ;

 len +=  SPI_Ethernet_putConstString ("var WS=\"") ;
 len +=  SPI_Ethernet_putString (WS) ;
 len +=  SPI_Ethernet_putConstString ("\";") ;

 len +=  SPI_Ethernet_putConstString ("var MNS2=\"") ;
 len +=  SPI_Ethernet_putString (MNS2) ;
 len +=  SPI_Ethernet_putConstString ("\";") ;

 len +=  SPI_Ethernet_putConstString ("var ST=\"") ;
 len +=  SPI_Ethernet_putString (ST) ;
 len +=  SPI_Ethernet_putConstString ("\";") ;

 len +=  SPI_Ethernet_putConstString ("var BP=\"") ;
 len +=  SPI_Ethernet_putString (BP) ;
 len +=  SPI_Ethernet_putConstString ("\";") ;
#line 498 "C:/Documents and Settings/Administrator/Desktop/Source PIC/HTTP_Demo.c"
 len +=  SPI_Ethernet_putConstString ("var RAD2=\"");
 len +=  SPI_Ethernet_putString (RAD);
 len +=  SPI_Ethernet_putConstString ("\";");



 }

 else if(getRequest[5] == 'x')
 {
 len =  SPI_Ethernet_putConstString ("Date,AirTemp,SoilTemp,Humidity\n") ;
 len +=  SPI_Ethernet_putString (csvbuft) ;
 }

 else if(getRequest[5] == 'u')
 {
 len =  SPI_Ethernet_putConstString ("Slave 1:\n");
 len +=  SPI_Ethernet_putString (manch);
 len +=  SPI_Ethernet_putConstString ("\nSlave 2:\n");
 len +=  SPI_Ethernet_putString (manch2);
 }

 else if(getRequest[5] == 'g')
 {
 len =  SPI_Ethernet_putConstString (httpHeader) ;
 len +=  SPI_Ethernet_putConstString (httpMimeTypeHTML) ;
 len +=  SPI_Ethernet_putConstString (graphPage) ;
 }
 if(len == 0)
 {
 len =  SPI_Ethernet_putConstString (httpHeader) ;
 len +=  SPI_Ethernet_putConstString (httpMimeTypeHTML) ;
 len +=  SPI_Ethernet_putConstString (indexPage) ;
 len +=  SPI_Ethernet_putConstString (indexPage2) ;
 len +=  SPI_Ethernet_putConstString (indexPage3) ;
 }

 return(len) ;

 }
#line 548 "C:/Documents and Settings/Administrator/Desktop/Source PIC/HTTP_Demo.c"
unsigned int SPI_Ethernet_UserUDP(unsigned char *remoteHost, unsigned int remotePort, unsigned int destPort, unsigned int reqLength, TEthPktFlags *flags)
 {
 unsigned int len ;


 ByteToStr(remoteHost[0], dyna) ;
 dyna[3] = '.' ;
 ByteToStr(remoteHost[1], dyna + 4) ;
 dyna[7] = '.' ;
 ByteToStr(remoteHost[2], dyna + 8) ;
 dyna[11] = '.' ;
 ByteToStr(remoteHost[3], dyna + 12) ;

 dyna[15] = ':' ;


 WordToStr(remotePort, dyna + 16) ;
 dyna[21] = '[' ;
 WordToStr(destPort, dyna + 22) ;
 dyna[27] = ']' ;
 dyna[28] = 0 ;


 len = 28 + reqLength;


 SPI_Ethernet_putBytes(dyna, 28) ;


 while(reqLength--)
 {
 SPI_Ethernet_putByte(toupper(SPI_Ethernet_getByte())) ;
 }

 return(len) ;
 }


 void Init_Main_RTC() {

 TRISB = 0;
 PORTB = 0xFF;
 TRISB = 0xff;

 Soft_I2C_Init();
}

unsigned int i=0;
unsigned long int cnt=0, manchcnt=0, manchcnt2=0;



void main()
 {

 ErrorCount = 0;
 cnt=0;
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






 ADCON1 = 0x0B ;
 CMCON = 0x07 ;




 TRISA3_bit = 1 ;
 TRISA0_bit = 0;
 TRISA1_bit = 1;
 TRISA4_bit = 0;
 TRISA5_bit = 0;
 PORTD = 0 ;
 TRISD = 0 ;
 TRISC = 1;
#line 667 "C:/Documents and Settings/Administrator/Desktop/Source PIC/HTTP_Demo.c"
 RA5_bit=1;
 RA4_bit=0;
 Man_Receive_Init();
 Delay_ms(150);
 SPI1_Init();
 SPI_Rd_Ptr = SPI1_Read;
 SPI_Ethernet_Init(myMacAddr, myIpAddr,  0x01 ) ;

 SPI_Ethernet_confNetwork(ipMask, gwIpAddr, dnsIpAddr) ;


 Delay_ms(100);





 Init_Main_RTC();

 RA4_bit=1;
 RA5_bit=1;

 while(1) {


 cnt=cnt+1;
 manchcnt=manchcnt+1;
 if(cnt==28124000){

 Soft_I2C_Start();
 Soft_I2C_Write(0xA0);
 Soft_I2C_Write(2);
 Soft_I2C_Start();
 Soft_I2C_Write(0xA1);

 seconds = Soft_I2C_Read(1);
 minutes = Soft_I2C_Read(1);
 hours = 0x3f&Soft_I2C_Read(1);
 day = Soft_I2C_Read(1);
 month = Soft_I2C_Read(0);
 Soft_I2C_Stop();

 seconds = ((seconds & 0xF0) >> 4)*10 + (seconds & 0x0F);
 minutes = ((minutes & 0xF0) >> 4)*10 + (minutes & 0x0F);
 hours = ((hours & 0xF0) >> 4)*10 + (hours & 0x0F);
 year = (day & 0xC0) >> 6;
 day = ((day & 0x30) >> 4)*10 + (day & 0x0F);
 month = ((month & 0x10) >> 4)*10 + (month & 0x0F);



 Ow_Reset(&PORTE, 2);
 Ow_Write(&PORTE, 2, 0xCC);
 Ow_Write(&PORTE, 2, 0x44);
 Delay_us(120);

 Ow_Reset(&PORTE, 2);
 Ow_Write(&PORTE, 2, 0xCC);
 Ow_Write(&PORTE, 2, 0xBE);
 Delay_us(120);

 temp = Ow_Read(&PORTE, 2);
 temp = (Ow_Read(&PORTE, 2) << 8) + temp;



 if (temp & 0x8000) {
 minus = 1;
 temp = ~temp + 1; }
 else {
 minus = 0;
 }

 temp_whole = temp >> RES_SHIFT ;
 temp_fraction = temp << (4-RES_SHIFT);

 RH=ADC_Read(1);
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
 tempman = Man_Receive(&error);
 if (tempman == 0x0B)
 break;
 if (error)
 break;
 }

 do
 {
 tempman = Man_Receive(&error);
 if (error) {
 ErrorCount++;
 if (ErrorCount > 20) {
 tempman = Man_Synchro();
 Man_Receive_Init();
 ErrorCount = 0;
 }
 }
 else {
 if (tempman != 0x0E)
 manch[m]=tempman;
 m++;
 }
 Delay_ms(25);
 }

 while (tempman != 0x0E) ;
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
 tempman = Man_Receive(&error);
 if (tempman == 0x0B)
 break;
 if (error)
 break;
 }

 do
 {
 tempman = Man_Receive(&error);
 if (error) {
 ErrorCount++;
 if (ErrorCount > 20) {
 tempman = Man_Synchro();
 Man_Receive_Init();
 ErrorCount = 0;
 }
 }
 else {
 if (tempman != 0x0E)
 manch2[m]=tempman;
 m++;
 }
 Delay_ms(25);
 }

 while (tempman != 0x0E) ;
 m=0;
 manchcnt2=0;
 manch2[9]=0;
 if((manch2[0]=='1') && ((manch2[0] + manch2[1] + manch2[2] + manch2[3] + manch2[4] + manch2[5] + manch2[6] + manch2[7])%2)+48==manch2[8]){
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

 SPI_Ethernet_doPacket() ;

 }


}
