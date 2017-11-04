
_SPI_Ethernet_UserTCP:

;HTTP_Demo.c,237 :: 		unsigned int  SPI_Ethernet_UserTCP(unsigned char *remoteHost, unsigned int remotePort, unsigned int localPort, unsigned int reqLength, TEthPktFlags *flags)
;HTTP_Demo.c,243 :: 		strHH[2] = strMM[2] = strSS[2] = 0;
	CLRF        _strSS+2 
	CLRF        _strMM+2 
	CLRF        _strHH+2 
;HTTP_Demo.c,248 :: 		if(localPort != 80)                         // I listen only to web request on port 80
	MOVLW       0
	XORWF       FARG_SPI_Ethernet_UserTCP_localPort+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SPI_Ethernet_UserTCP87
	MOVLW       80
	XORWF       FARG_SPI_Ethernet_UserTCP_localPort+0, 0 
L__SPI_Ethernet_UserTCP87:
	BTFSC       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP0
;HTTP_Demo.c,250 :: 		return(0) ;
	CLRF        R0 
	CLRF        R1 
	RETURN      0
;HTTP_Demo.c,251 :: 		}
L_SPI_Ethernet_UserTCP0:
;HTTP_Demo.c,254 :: 		for(len = 0 ; len < 20 ; len++)
	CLRF        SPI_Ethernet_UserTCP_len_L0+0 
	CLRF        SPI_Ethernet_UserTCP_len_L0+1 
L_SPI_Ethernet_UserTCP1:
	MOVLW       0
	SUBWF       SPI_Ethernet_UserTCP_len_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SPI_Ethernet_UserTCP88
	MOVLW       20
	SUBWF       SPI_Ethernet_UserTCP_len_L0+0, 0 
L__SPI_Ethernet_UserTCP88:
	BTFSC       STATUS+0, 0 
	GOTO        L_SPI_Ethernet_UserTCP2
;HTTP_Demo.c,256 :: 		getRequest[len] = SPI_Ethernet_getByte() ;
	MOVLW       _getRequest+0
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 0 
	MOVWF       FLOC__SPI_Ethernet_UserTCP+0 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 0 
	MOVWF       FLOC__SPI_Ethernet_UserTCP+1 
	CALL        _SPI_Ethernet_getByte+0, 0
	MOVFF       FLOC__SPI_Ethernet_UserTCP+0, FSR1L
	MOVFF       FLOC__SPI_Ethernet_UserTCP+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,254 :: 		for(len = 0 ; len < 20 ; len++)
	INFSNZ      SPI_Ethernet_UserTCP_len_L0+0, 1 
	INCF        SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,257 :: 		}
	GOTO        L_SPI_Ethernet_UserTCP1
L_SPI_Ethernet_UserTCP2:
;HTTP_Demo.c,258 :: 		getRequest[len] = 0 ;
	MOVLW       _getRequest+0
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;HTTP_Demo.c,259 :: 		len = 0;
	CLRF        SPI_Ethernet_UserTCP_len_L0+0 
	CLRF        SPI_Ethernet_UserTCP_len_L0+1 
;HTTP_Demo.c,261 :: 		if(memcmp(getRequest, httpMethod, 5))       // only GET method
	MOVLW       _getRequest+0
	MOVWF       FARG_memcmp_s1+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_memcmp_s1+1 
	MOVLW       _httpMethod+0
	MOVWF       FARG_memcmp_s2+0 
	MOVLW       hi_addr(_httpMethod+0)
	MOVWF       FARG_memcmp_s2+1 
	MOVLW       5
	MOVWF       FARG_memcmp_n+0 
	MOVLW       0
	MOVWF       FARG_memcmp_n+1 
	CALL        _memcmp+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP4
;HTTP_Demo.c,263 :: 		return(0) ;
	CLRF        R0 
	CLRF        R1 
	RETURN      0
;HTTP_Demo.c,264 :: 		}
L_SPI_Ethernet_UserTCP4:
;HTTP_Demo.c,266 :: 		if(getRequest[5] == 't') {
	MOVF        _getRequest+5, 0 
	XORLW       116
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP5
;HTTP_Demo.c,267 :: 		strHH[0] = getRequest[6];
	MOVF        _getRequest+6, 0 
	MOVWF       _strHH+0 
;HTTP_Demo.c,268 :: 		strHH[1] = getRequest[7];
	MOVF        _getRequest+7, 0 
	MOVWF       _strHH+1 
;HTTP_Demo.c,270 :: 		strMM[0] = getRequest[8];
	MOVF        _getRequest+8, 0 
	MOVWF       _strMM+0 
;HTTP_Demo.c,271 :: 		strMM[1] = getRequest[9];
	MOVF        _getRequest+9, 0 
	MOVWF       _strMM+1 
;HTTP_Demo.c,273 :: 		strSS[0] = getRequest[10];
	MOVF        _getRequest+10, 0 
	MOVWF       _strSS+0 
;HTTP_Demo.c,274 :: 		strSS[1] = getRequest[11];
	MOVF        _getRequest+11, 0 
	MOVWF       _strSS+1 
;HTTP_Demo.c,276 :: 		strDD[0] = getRequest[12];
	MOVF        _getRequest+12, 0 
	MOVWF       _strDD+0 
;HTTP_Demo.c,277 :: 		strDD[1] = getRequest[13];
	MOVF        _getRequest+13, 0 
	MOVWF       _strDD+1 
;HTTP_Demo.c,279 :: 		strMO[0] = getRequest[14];
	MOVF        _getRequest+14, 0 
	MOVWF       _strMO+0 
;HTTP_Demo.c,280 :: 		strMO[1] = getRequest[15];
	MOVF        _getRequest+15, 0 
	MOVWF       _strMO+1 
;HTTP_Demo.c,282 :: 		strYY[0] = getRequest[16];
	MOVF        _getRequest+16, 0 
	MOVWF       _strYY+0 
;HTTP_Demo.c,283 :: 		strYY[1] = getRequest[17];
	MOVF        _getRequest+17, 0 
	MOVWF       _strYY+1 
;HTTP_Demo.c,286 :: 		Soft_I2C_Start();      // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;HTTP_Demo.c,287 :: 		Soft_I2C_Write(0xA0);  // Address PCF8583, see PCF8583 datasheet
	MOVLW       160
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;HTTP_Demo.c,288 :: 		Soft_I2C_Write(0);     // Start from address 0 (configuration memory location)
	CLRF        FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;HTTP_Demo.c,289 :: 		Soft_I2C_Write(0x80);  // Write 0x80 to configuration memory location (pause counter...)
	MOVLW       128
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;HTTP_Demo.c,290 :: 		Soft_I2C_Stop();       // Issue stop signal
	CALL        _Soft_I2C_Stop+0, 0
;HTTP_Demo.c,293 :: 		Soft_I2C_Start();      // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;HTTP_Demo.c,294 :: 		Soft_I2C_Write(0xA0);  // Address PCF8583, see PCF8583 datasheet
	MOVLW       160
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;HTTP_Demo.c,295 :: 		Soft_I2C_Write(0);     // Start from address 0 (configuration memory location)
	CLRF        FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;HTTP_Demo.c,296 :: 		Soft_I2C_Write(0x80);  // Write 0x80 to configuration memory location (pause counter...)
	MOVLW       128
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;HTTP_Demo.c,297 :: 		Soft_I2C_Write(0);     // Write 0 to cents memory location
	CLRF        FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;HTTP_Demo.c,298 :: 		Soft_I2C_Write(Dec2Bcd(atoi(strSS)));  // Write 0 to seconds memory location
	MOVLW       _strSS+0
	MOVWF       FARG_atoi_s+0 
	MOVLW       hi_addr(_strSS+0)
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;HTTP_Demo.c,299 :: 		Soft_I2C_Write(Dec2Bcd(atoi(strMM)));  // Write 0x30 to minutes memory location
	MOVLW       _strMM+0
	MOVWF       FARG_atoi_s+0 
	MOVLW       hi_addr(_strMM+0)
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;HTTP_Demo.c,300 :: 		Soft_I2C_Write(Dec2Bcd(atoi(strHH)));  // Write 0x12 to hours memory location
	MOVLW       _strHH+0
	MOVWF       FARG_atoi_s+0 
	MOVLW       hi_addr(_strHH+0)
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;HTTP_Demo.c,301 :: 		Soft_I2C_Write((Dec2Bcd(atoi(strDD))&0x3F)|((Dec2Bcd(atoi(strYY))&0x03)<<6));  // Write 0x24 to year/date memory location
	MOVLW       _strDD+0
	MOVWF       FARG_atoi_s+0 
	MOVLW       hi_addr(_strDD+0)
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVLW       63
	ANDWF       R0, 0 
	MOVWF       FLOC__SPI_Ethernet_UserTCP+0 
	MOVLW       _strYY+0
	MOVWF       FARG_atoi_s+0 
	MOVLW       hi_addr(_strYY+0)
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVLW       3
	ANDWF       R0, 0 
	MOVWF       R2 
	MOVLW       6
	MOVWF       R1 
	MOVF        R2, 0 
	MOVWF       R0 
	MOVF        R1, 0 
L__SPI_Ethernet_UserTCP89:
	BZ          L__SPI_Ethernet_UserTCP90
	RLCF        R0, 1 
	BCF         R0, 0 
	ADDLW       255
	GOTO        L__SPI_Ethernet_UserTCP89
L__SPI_Ethernet_UserTCP90:
	MOVF        R0, 0 
	IORWF       FLOC__SPI_Ethernet_UserTCP+0, 0 
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;HTTP_Demo.c,302 :: 		Soft_I2C_Write(Dec2Bcd(atoi(strMO)));  // Write 0x08 to weekday/month memory location
	MOVLW       _strMO+0
	MOVWF       FARG_atoi_s+0 
	MOVLW       hi_addr(_strMO+0)
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;HTTP_Demo.c,303 :: 		Soft_I2C_Stop();       // Issue stop signal
	CALL        _Soft_I2C_Stop+0, 0
;HTTP_Demo.c,306 :: 		Soft_I2C_Start();      // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;HTTP_Demo.c,307 :: 		Soft_I2C_Write(0xA0);  // Address PCF8530
	MOVLW       160
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;HTTP_Demo.c,308 :: 		Soft_I2C_Write(0);     // Start from address 0
	CLRF        FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;HTTP_Demo.c,309 :: 		Soft_I2C_Write(0);     // Write 0 to configuration memory location (enable counting)
	CLRF        FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;HTTP_Demo.c,310 :: 		Soft_I2C_Stop();       // Issue stop signal
	CALL        _Soft_I2C_Stop+0, 0
;HTTP_Demo.c,312 :: 		}
	GOTO        L_SPI_Ethernet_UserTCP6
L_SPI_Ethernet_UserTCP5:
;HTTP_Demo.c,314 :: 		else if(getRequest[5] == 's')                    // if request path name starts with s, store dynamic data in transmit buffer
	MOVF        _getRequest+5, 0 
	XORLW       115
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP7
;HTTP_Demo.c,319 :: 		len = putConstString(httpHeader) ;              // HTTP header
	MOVLW       _httpHeader+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(_httpHeader+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(_httpHeader+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	MOVWF       SPI_Ethernet_UserTCP_len_L0+0 
	MOVF        R1, 0 
	MOVWF       SPI_Ethernet_UserTCP_len_L0+1 
;HTTP_Demo.c,320 :: 		len += putConstString(httpMimeTypeScript) ;     // with text MIME type
	MOVLW       _httpMimeTypeScript+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(_httpMimeTypeScript+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(_httpMimeTypeScript+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,322 :: 		Delay_us(120);
	MOVLW       2
	MOVWF       R12, 0
	MOVLW       141
	MOVWF       R13, 0
L_SPI_Ethernet_UserTCP8:
	DECFSZ      R13, 1, 1
	BRA         L_SPI_Ethernet_UserTCP8
	DECFSZ      R12, 1, 1
	BRA         L_SPI_Ethernet_UserTCP8
	NOP
	NOP
;HTTP_Demo.c,324 :: 		SI_fin=ADC_Read(3); //*0.004964;
	MOVLW       3
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _SI_fin+0 
	MOVF        R1, 0 
	MOVWF       _SI_fin+1 
;HTTP_Demo.c,325 :: 		SI_fin=SI_fin*2;
	MOVF        R0, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       R3 
	RLCF        R2, 1 
	BCF         R2, 0 
	RLCF        R3, 1 
	MOVF        R2, 0 
	MOVWF       _SI_fin+0 
	MOVF        R3, 0 
	MOVWF       _SI_fin+1 
;HTTP_Demo.c,327 :: 		WordToStr(SI_fin, dyna) ;
	MOVF        R2, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        R3, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       _dyna+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;HTTP_Demo.c,328 :: 		len += putConstString("var AN3=") ;
	MOVLW       ?lstr_5_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_5_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_5_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,329 :: 		len += putString(dyna) ;
	MOVLW       _dyna+0
	MOVWF       FARG_SPI_Ethernet_putString_ptr+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_SPI_Ethernet_putString_ptr+1 
	CALL        _SPI_Ethernet_putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,330 :: 		len += putConstString(";") ;
	MOVLW       ?lstr_6_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_6_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_6_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,335 :: 		Ow_Reset(&PORTE, 2);                         // Onewire reset signal
	MOVLW       PORTE+0
	MOVWF       FARG_Ow_Reset_port+0 
	MOVLW       hi_addr(PORTE+0)
	MOVWF       FARG_Ow_Reset_port+1 
	MOVLW       2
	MOVWF       FARG_Ow_Reset_pin+0 
	CALL        _Ow_Reset+0, 0
;HTTP_Demo.c,336 :: 		Ow_Write(&PORTE, 2, 0xCC);                   // Issue command SKIP_ROM
	MOVLW       PORTE+0
	MOVWF       FARG_Ow_Write_port+0 
	MOVLW       hi_addr(PORTE+0)
	MOVWF       FARG_Ow_Write_port+1 
	MOVLW       2
	MOVWF       FARG_Ow_Write_pin+0 
	MOVLW       204
	MOVWF       FARG_Ow_Write_data_+0 
	CALL        _Ow_Write+0, 0
;HTTP_Demo.c,337 :: 		Ow_Write(&PORTE, 2, 0x44);                   // Issue command CONVERT_T
	MOVLW       PORTE+0
	MOVWF       FARG_Ow_Write_port+0 
	MOVLW       hi_addr(PORTE+0)
	MOVWF       FARG_Ow_Write_port+1 
	MOVLW       2
	MOVWF       FARG_Ow_Write_pin+0 
	MOVLW       68
	MOVWF       FARG_Ow_Write_data_+0 
	CALL        _Ow_Write+0, 0
;HTTP_Demo.c,338 :: 		Delay_us(120);
	MOVLW       2
	MOVWF       R12, 0
	MOVLW       141
	MOVWF       R13, 0
L_SPI_Ethernet_UserTCP9:
	DECFSZ      R13, 1, 1
	BRA         L_SPI_Ethernet_UserTCP9
	DECFSZ      R12, 1, 1
	BRA         L_SPI_Ethernet_UserTCP9
	NOP
	NOP
;HTTP_Demo.c,340 :: 		Ow_Reset(&PORTE, 2);
	MOVLW       PORTE+0
	MOVWF       FARG_Ow_Reset_port+0 
	MOVLW       hi_addr(PORTE+0)
	MOVWF       FARG_Ow_Reset_port+1 
	MOVLW       2
	MOVWF       FARG_Ow_Reset_pin+0 
	CALL        _Ow_Reset+0, 0
;HTTP_Demo.c,341 :: 		Ow_Write(&PORTE, 2, 0xCC);                   // Issue command SKIP_ROM
	MOVLW       PORTE+0
	MOVWF       FARG_Ow_Write_port+0 
	MOVLW       hi_addr(PORTE+0)
	MOVWF       FARG_Ow_Write_port+1 
	MOVLW       2
	MOVWF       FARG_Ow_Write_pin+0 
	MOVLW       204
	MOVWF       FARG_Ow_Write_data_+0 
	CALL        _Ow_Write+0, 0
;HTTP_Demo.c,342 :: 		Ow_Write(&PORTE, 2, 0xBE);                   // Issue command READ_SCRATCHPAD
	MOVLW       PORTE+0
	MOVWF       FARG_Ow_Write_port+0 
	MOVLW       hi_addr(PORTE+0)
	MOVWF       FARG_Ow_Write_port+1 
	MOVLW       2
	MOVWF       FARG_Ow_Write_pin+0 
	MOVLW       190
	MOVWF       FARG_Ow_Write_data_+0 
	CALL        _Ow_Write+0, 0
;HTTP_Demo.c,343 :: 		Delay_us(120);
	MOVLW       2
	MOVWF       R12, 0
	MOVLW       141
	MOVWF       R13, 0
L_SPI_Ethernet_UserTCP10:
	DECFSZ      R13, 1, 1
	BRA         L_SPI_Ethernet_UserTCP10
	DECFSZ      R12, 1, 1
	BRA         L_SPI_Ethernet_UserTCP10
	NOP
	NOP
;HTTP_Demo.c,345 :: 		temp =  Ow_Read(&PORTE, 2);
	MOVLW       PORTE+0
	MOVWF       FARG_Ow_Read_port+0 
	MOVLW       hi_addr(PORTE+0)
	MOVWF       FARG_Ow_Read_port+1 
	MOVLW       2
	MOVWF       FARG_Ow_Read_pin+0 
	CALL        _Ow_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _temp+0 
	MOVLW       0
	MOVWF       _temp+1 
;HTTP_Demo.c,346 :: 		temp = (Ow_Read(&PORTE, 2) << 8) + temp;
	MOVLW       PORTE+0
	MOVWF       FARG_Ow_Read_port+0 
	MOVLW       hi_addr(PORTE+0)
	MOVWF       FARG_Ow_Read_port+1 
	MOVLW       2
	MOVWF       FARG_Ow_Read_pin+0 
	CALL        _Ow_Read+0, 0
	MOVF        R0, 0 
	MOVWF       R5 
	CLRF        R4 
	MOVF        _temp+0, 0 
	ADDWF       R4, 0 
	MOVWF       R2 
	MOVF        _temp+1, 0 
	ADDWFC      R5, 0 
	MOVWF       R3 
	MOVF        R2, 0 
	MOVWF       _temp+0 
	MOVF        R3, 0 
	MOVWF       _temp+1 
;HTTP_Demo.c,350 :: 		if (temp & 0x8000) {
	BTFSS       R3, 7 
	GOTO        L_SPI_Ethernet_UserTCP11
;HTTP_Demo.c,351 :: 		minus = 1;
	MOVLW       1
	MOVWF       _minus+0 
	MOVLW       0
	MOVWF       _minus+1 
;HTTP_Demo.c,352 :: 		temp = ~temp + 1; }
	COMF        _temp+0, 1 
	COMF        _temp+1, 1 
	INFSNZ      _temp+0, 1 
	INCF        _temp+1, 1 
	GOTO        L_SPI_Ethernet_UserTCP12
L_SPI_Ethernet_UserTCP11:
;HTTP_Demo.c,354 :: 		minus = 0;
	CLRF        _minus+0 
	CLRF        _minus+1 
;HTTP_Demo.c,355 :: 		}
L_SPI_Ethernet_UserTCP12:
;HTTP_Demo.c,357 :: 		temp_whole = temp >> RES_SHIFT ;
	MOVF        _temp+0, 0 
	MOVWF       R0 
	MOVF        _temp+1, 0 
	MOVWF       R1 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	MOVF        R0, 0 
	MOVWF       _temp_whole+0 
	MOVF        R1, 0 
	MOVWF       _temp_whole+1 
;HTTP_Demo.c,358 :: 		temp_whole_1 = (temp_whole/10)%10 ;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _temp_whole_1+0 
	MOVF        R1, 0 
	MOVWF       _temp_whole_1+1 
;HTTP_Demo.c,359 :: 		temp_whole_2 = temp_whole%10 ;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _temp_whole+0, 0 
	MOVWF       R0 
	MOVF        _temp_whole+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _temp_whole_2+0 
	MOVF        R1, 0 
	MOVWF       _temp_whole_2+1 
;HTTP_Demo.c,360 :: 		temp_fraction  = temp << (4-RES_SHIFT);
	MOVF        _temp+0, 0 
	MOVWF       _temp_fraction+0 
	MOVF        _temp+1, 0 
	MOVWF       _temp_fraction+1 
;HTTP_Demo.c,362 :: 		temp_fraction_1 =  temp_fraction%10 ;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _temp+0, 0 
	MOVWF       R0 
	MOVF        _temp+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _temp_fraction_1+0 
	MOVF        R1, 0 
	MOVWF       _temp_fraction_1+1 
;HTTP_Demo.c,363 :: 		temp_fraction_2 = (temp_fraction/10)%10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _temp_fraction+0, 0 
	MOVWF       R0 
	MOVF        _temp_fraction+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _temp_fraction_2+0 
	MOVF        R1, 0 
	MOVWF       _temp_fraction_2+1 
;HTTP_Demo.c,366 :: 		if (minus==1){
	MOVLW       0
	XORWF       _minus+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SPI_Ethernet_UserTCP91
	MOVLW       1
	XORWF       _minus+0, 0 
L__SPI_Ethernet_UserTCP91:
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP13
;HTTP_Demo.c,367 :: 		len += putConstString("var MNS=\"-\";") ;
	MOVLW       ?lstr_7_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_7_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_7_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,369 :: 		}
	GOTO        L_SPI_Ethernet_UserTCP14
L_SPI_Ethernet_UserTCP13:
;HTTP_Demo.c,371 :: 		len += putConstString("var MNS=\"+\";");
	MOVLW       ?lstr_8_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_8_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_8_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,373 :: 		}
L_SPI_Ethernet_UserTCP14:
;HTTP_Demo.c,375 :: 		WordToStr(temp_whole_1, dyna) ;
	MOVF        _temp_whole_1+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        _temp_whole_1+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       _dyna+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;HTTP_Demo.c,376 :: 		len += putConstString("var TW1=") ;
	MOVLW       ?lstr_9_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_9_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_9_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,377 :: 		len += putString(dyna) ;
	MOVLW       _dyna+0
	MOVWF       FARG_SPI_Ethernet_putString_ptr+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_SPI_Ethernet_putString_ptr+1 
	CALL        _SPI_Ethernet_putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,378 :: 		len += putConstString(";") ;
	MOVLW       ?lstr_10_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_10_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_10_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,380 :: 		WordToStr(temp_whole_2, dyna) ;
	MOVF        _temp_whole_2+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        _temp_whole_2+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       _dyna+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;HTTP_Demo.c,381 :: 		len += putConstString("var TW2=") ;
	MOVLW       ?lstr_11_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_11_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_11_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,382 :: 		len += putString(dyna) ;
	MOVLW       _dyna+0
	MOVWF       FARG_SPI_Ethernet_putString_ptr+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_SPI_Ethernet_putString_ptr+1 
	CALL        _SPI_Ethernet_putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,383 :: 		len += putConstString(";") ;
	MOVLW       ?lstr_12_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_12_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_12_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,385 :: 		WordToStr(temp_fraction_1, dyna) ;
	MOVF        _temp_fraction_1+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        _temp_fraction_1+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       _dyna+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;HTTP_Demo.c,386 :: 		len += putConstString("var TF=") ;
	MOVLW       ?lstr_13_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_13_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_13_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,387 :: 		len += putString(dyna) ;
	MOVLW       _dyna+0
	MOVWF       FARG_SPI_Ethernet_putString_ptr+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_SPI_Ethernet_putString_ptr+1 
	CALL        _SPI_Ethernet_putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,388 :: 		len += putConstString(";") ;
	MOVLW       ?lstr_14_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_14_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_14_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,390 :: 		WordToStr(temp_fraction_2, dyna) ;
	MOVF        _temp_fraction_2+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        _temp_fraction_2+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       _dyna+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;HTTP_Demo.c,391 :: 		len += putConstString("var TF1=") ;
	MOVLW       ?lstr_15_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_15_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_15_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,392 :: 		len += putString(dyna) ;
	MOVLW       _dyna+0
	MOVWF       FARG_SPI_Ethernet_putString_ptr+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_SPI_Ethernet_putString_ptr+1 
	CALL        _SPI_Ethernet_putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,393 :: 		len += putConstString(";") ;
	MOVLW       ?lstr_16_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_16_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_16_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,397 :: 		Soft_I2C_Start();               // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;HTTP_Demo.c,398 :: 		Soft_I2C_Write(0xA0);           // Address PCF8583, see PCF8583 datasheet
	MOVLW       160
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;HTTP_Demo.c,399 :: 		Soft_I2C_Write(2);              // Start from address 2
	MOVLW       2
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;HTTP_Demo.c,400 :: 		Soft_I2C_Start();               // Issue repeated start signal
	CALL        _Soft_I2C_Start+0, 0
;HTTP_Demo.c,401 :: 		Soft_I2C_Write(0xA1);           // Address PCF8583 for reading R/W=1
	MOVLW       161
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;HTTP_Demo.c,403 :: 		seconds = Soft_I2C_Read(1);     // Read seconds byte
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _seconds+0 
	MOVLW       0
	MOVWF       _seconds+1 
;HTTP_Demo.c,404 :: 		minutes = Soft_I2C_Read(1);     // Read minutes byte
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _minutes+0 
	MOVLW       0
	MOVWF       _minutes+1 
;HTTP_Demo.c,405 :: 		hours = 0x3f&Soft_I2C_Read(1);       // Read hours byte
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVLW       63
	ANDWF       R0, 0 
	MOVWF       _hours+0 
	CLRF        _hours+1 
	MOVLW       0
	ANDWF       _hours+1, 1 
	MOVLW       0
	MOVWF       _hours+1 
;HTTP_Demo.c,406 :: 		day = Soft_I2C_Read(1);         // Read year/day byte
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _day+0 
	MOVLW       0
	MOVWF       _day+1 
;HTTP_Demo.c,407 :: 		month = Soft_I2C_Read(0);       // Read weekday/month byte
	CLRF        FARG_Soft_I2C_Read_ack+0 
	CLRF        FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _month+0 
	MOVLW       0
	MOVWF       _month+1 
;HTTP_Demo.c,408 :: 		Soft_I2C_Stop();                // Issue stop signal
	CALL        _Soft_I2C_Stop+0, 0
;HTTP_Demo.c,410 :: 		seconds  =  ((seconds & 0xF0) >> 4)*10 + (seconds & 0x0F);  // Transform seconds
	MOVLW       240
	ANDWF       _seconds+0, 0 
	MOVWF       R3 
	MOVF        _seconds+1, 0 
	MOVWF       R4 
	MOVLW       0
	ANDWF       R4, 1 
	MOVF        R3, 0 
	MOVWF       R0 
	MOVF        R4, 0 
	MOVWF       R1 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVLW       15
	ANDWF       _seconds+0, 0 
	MOVWF       R2 
	MOVF        _seconds+1, 0 
	MOVWF       R3 
	MOVLW       0
	ANDWF       R3, 1 
	MOVF        R2, 0 
	ADDWF       R0, 0 
	MOVWF       _seconds+0 
	MOVF        R3, 0 
	ADDWFC      R1, 0 
	MOVWF       _seconds+1 
;HTTP_Demo.c,411 :: 		minutes  =  ((minutes & 0xF0) >> 4)*10 + (minutes & 0x0F);  // Transform months
	MOVLW       240
	ANDWF       _minutes+0, 0 
	MOVWF       R3 
	MOVF        _minutes+1, 0 
	MOVWF       R4 
	MOVLW       0
	ANDWF       R4, 1 
	MOVF        R3, 0 
	MOVWF       R0 
	MOVF        R4, 0 
	MOVWF       R1 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVLW       15
	ANDWF       _minutes+0, 0 
	MOVWF       R2 
	MOVF        _minutes+1, 0 
	MOVWF       R3 
	MOVLW       0
	ANDWF       R3, 1 
	MOVF        R2, 0 
	ADDWF       R0, 0 
	MOVWF       _minutes+0 
	MOVF        R3, 0 
	ADDWFC      R1, 0 
	MOVWF       _minutes+1 
;HTTP_Demo.c,412 :: 		hours    =  ((hours & 0xF0)  >> 4)*10  + (hours & 0x0F);    // Transform hours
	MOVLW       240
	ANDWF       _hours+0, 0 
	MOVWF       R3 
	MOVF        _hours+1, 0 
	MOVWF       R4 
	MOVLW       0
	ANDWF       R4, 1 
	MOVF        R3, 0 
	MOVWF       R0 
	MOVF        R4, 0 
	MOVWF       R1 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVLW       15
	ANDWF       _hours+0, 0 
	MOVWF       R2 
	MOVF        _hours+1, 0 
	MOVWF       R3 
	MOVLW       0
	ANDWF       R3, 1 
	MOVF        R2, 0 
	ADDWF       R0, 0 
	MOVWF       _hours+0 
	MOVF        R3, 0 
	ADDWFC      R1, 0 
	MOVWF       _hours+1 
;HTTP_Demo.c,413 :: 		year     =   (day & 0xC0) >> 6;                             // Transform year
	MOVLW       192
	ANDWF       _day+0, 0 
	MOVWF       _year+0 
	MOVF        _day+1, 0 
	MOVWF       _year+1 
	MOVLW       0
	ANDWF       _year+1, 1 
	MOVLW       6
	MOVWF       R0 
	MOVF        R0, 0 
L__SPI_Ethernet_UserTCP92:
	BZ          L__SPI_Ethernet_UserTCP93
	RRCF        _year+1, 1 
	RRCF        _year+0, 1 
	BCF         _year+1, 7 
	ADDLW       255
	GOTO        L__SPI_Ethernet_UserTCP92
L__SPI_Ethernet_UserTCP93:
;HTTP_Demo.c,414 :: 		day      =  ((day & 0x30) >> 4)*10    + (day & 0x0F);       // Transform day
	MOVLW       48
	ANDWF       _day+0, 0 
	MOVWF       R3 
	MOVF        _day+1, 0 
	MOVWF       R4 
	MOVLW       0
	ANDWF       R4, 1 
	MOVF        R3, 0 
	MOVWF       R0 
	MOVF        R4, 0 
	MOVWF       R1 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVLW       15
	ANDWF       _day+0, 0 
	MOVWF       R2 
	MOVF        _day+1, 0 
	MOVWF       R3 
	MOVLW       0
	ANDWF       R3, 1 
	MOVF        R2, 0 
	ADDWF       R0, 0 
	MOVWF       _day+0 
	MOVF        R3, 0 
	ADDWFC      R1, 0 
	MOVWF       _day+1 
;HTTP_Demo.c,415 :: 		month    =  ((month & 0x10)  >> 4)*10 + (month & 0x0F);     // Transform month
	MOVLW       16
	ANDWF       _month+0, 0 
	MOVWF       R3 
	MOVF        _month+1, 0 
	MOVWF       R4 
	MOVLW       0
	ANDWF       R4, 1 
	MOVF        R3, 0 
	MOVWF       R0 
	MOVF        R4, 0 
	MOVWF       R1 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVLW       15
	ANDWF       _month+0, 0 
	MOVWF       R2 
	MOVF        _month+1, 0 
	MOVWF       R3 
	MOVLW       0
	ANDWF       R3, 1 
	MOVF        R2, 0 
	ADDWF       R0, 0 
	MOVWF       _month+0 
	MOVF        R3, 0 
	ADDWFC      R1, 0 
	MOVWF       _month+1 
;HTTP_Demo.c,418 :: 		WordToStr(hours, dyna) ;
	MOVF        _hours+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        _hours+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       _dyna+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;HTTP_Demo.c,419 :: 		len += putConstString("var HR=") ;
	MOVLW       ?lstr_17_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_17_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_17_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,420 :: 		len += putString(dyna) ;
	MOVLW       _dyna+0
	MOVWF       FARG_SPI_Ethernet_putString_ptr+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_SPI_Ethernet_putString_ptr+1 
	CALL        _SPI_Ethernet_putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,421 :: 		len += putConstString(";") ;
	MOVLW       ?lstr_18_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_18_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_18_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,422 :: 		WordToStr(minutes, dyna) ;
	MOVF        _minutes+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        _minutes+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       _dyna+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;HTTP_Demo.c,423 :: 		len += putConstString("var MN=") ;
	MOVLW       ?lstr_19_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_19_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_19_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,424 :: 		len += putString(dyna) ;
	MOVLW       _dyna+0
	MOVWF       FARG_SPI_Ethernet_putString_ptr+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_SPI_Ethernet_putString_ptr+1 
	CALL        _SPI_Ethernet_putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,425 :: 		len += putConstString(";") ;
	MOVLW       ?lstr_20_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_20_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_20_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,426 :: 		WordToStr(seconds, dyna) ;
	MOVF        _seconds+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        _seconds+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       _dyna+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;HTTP_Demo.c,427 :: 		len += putConstString("var SC=") ;
	MOVLW       ?lstr_21_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_21_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_21_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,428 :: 		len += putString(dyna) ;
	MOVLW       _dyna+0
	MOVWF       FARG_SPI_Ethernet_putString_ptr+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_SPI_Ethernet_putString_ptr+1 
	CALL        _SPI_Ethernet_putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,429 :: 		len += putConstString(";") ;
	MOVLW       ?lstr_22_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_22_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_22_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,430 :: 		WordToStr(day, dyna) ;
	MOVF        _day+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        _day+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       _dyna+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;HTTP_Demo.c,431 :: 		len += putConstString("var DY=") ;
	MOVLW       ?lstr_23_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_23_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_23_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,432 :: 		len += putString(dyna) ;
	MOVLW       _dyna+0
	MOVWF       FARG_SPI_Ethernet_putString_ptr+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_SPI_Ethernet_putString_ptr+1 
	CALL        _SPI_Ethernet_putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,433 :: 		len += putConstString(";") ;
	MOVLW       ?lstr_24_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_24_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_24_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,434 :: 		WordToStr(month, dyna) ;
	MOVF        _month+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        _month+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       _dyna+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;HTTP_Demo.c,435 :: 		len += putConstString("var MH=") ;
	MOVLW       ?lstr_25_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_25_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_25_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,436 :: 		len += putString(dyna) ;
	MOVLW       _dyna+0
	MOVWF       FARG_SPI_Ethernet_putString_ptr+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_SPI_Ethernet_putString_ptr+1 
	CALL        _SPI_Ethernet_putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,437 :: 		len += putConstString(";") ;
	MOVLW       ?lstr_26_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_26_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_26_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,438 :: 		WordToStr(year, dyna) ;
	MOVF        _year+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        _year+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       _dyna+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;HTTP_Demo.c,439 :: 		len += putConstString("var YR=") ;
	MOVLW       ?lstr_27_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_27_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_27_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,440 :: 		len += putString(dyna) ;
	MOVLW       _dyna+0
	MOVWF       FARG_SPI_Ethernet_putString_ptr+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_SPI_Ethernet_putString_ptr+1 
	CALL        _SPI_Ethernet_putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,441 :: 		len += putConstString(";") ;
	MOVLW       ?lstr_28_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_28_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_28_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,445 :: 		RH=ADC_Read(1); //*0.004964;
	MOVLW       1
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _RH+0 
	MOVF        R1, 0 
	MOVWF       _RH+1 
;HTTP_Demo.c,446 :: 		if(RH>=1000) {
	MOVLW       3
	SUBWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SPI_Ethernet_UserTCP94
	MOVLW       232
	SUBWF       R0, 0 
L__SPI_Ethernet_UserTCP94:
	BTFSS       STATUS+0, 0 
	GOTO        L_SPI_Ethernet_UserTCP15
;HTTP_Demo.c,447 :: 		RH=100;
	MOVLW       100
	MOVWF       _RH+0 
	MOVLW       0
	MOVWF       _RH+1 
;HTTP_Demo.c,448 :: 		}
	GOTO        L_SPI_Ethernet_UserTCP16
L_SPI_Ethernet_UserTCP15:
;HTTP_Demo.c,450 :: 		RH=RH/10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _RH+0, 0 
	MOVWF       R0 
	MOVF        _RH+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _RH+0 
	MOVF        R1, 0 
	MOVWF       _RH+1 
;HTTP_Demo.c,451 :: 		}
L_SPI_Ethernet_UserTCP16:
;HTTP_Demo.c,453 :: 		WordToStr(RH, dyna) ;
	MOVF        _RH+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        _RH+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       _dyna+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;HTTP_Demo.c,454 :: 		len += putConstString("var RH=\"") ;
	MOVLW       ?lstr_29_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_29_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_29_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,455 :: 		len += putString(dyna) ;
	MOVLW       _dyna+0
	MOVWF       FARG_SPI_Ethernet_putString_ptr+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_SPI_Ethernet_putString_ptr+1 
	CALL        _SPI_Ethernet_putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,456 :: 		len += putConstString("\";") ;
	MOVLW       ?lstr_30_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_30_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_30_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,458 :: 		len += putConstString("var WD=\"") ;
	MOVLW       ?lstr_31_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_31_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_31_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,460 :: 		switch(WD[0]){
	GOTO        L_SPI_Ethernet_UserTCP17
;HTTP_Demo.c,462 :: 		case '1':  len += putConstString("North") ; break;
L_SPI_Ethernet_UserTCP19:
	MOVLW       ?lstr_32_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_32_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_32_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
	GOTO        L_SPI_Ethernet_UserTCP18
;HTTP_Demo.c,463 :: 		case '2':  len += putConstString("North-East") ; break;
L_SPI_Ethernet_UserTCP20:
	MOVLW       ?lstr_33_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_33_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_33_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
	GOTO        L_SPI_Ethernet_UserTCP18
;HTTP_Demo.c,464 :: 		case '3':  len += putConstString("East") ; break;
L_SPI_Ethernet_UserTCP21:
	MOVLW       ?lstr_34_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_34_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_34_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
	GOTO        L_SPI_Ethernet_UserTCP18
;HTTP_Demo.c,465 :: 		case '4':  len += putConstString("South-East") ; break;
L_SPI_Ethernet_UserTCP22:
	MOVLW       ?lstr_35_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_35_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_35_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
	GOTO        L_SPI_Ethernet_UserTCP18
;HTTP_Demo.c,466 :: 		case '5':  len += putConstString("South") ; break;
L_SPI_Ethernet_UserTCP23:
	MOVLW       ?lstr_36_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_36_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_36_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
	GOTO        L_SPI_Ethernet_UserTCP18
;HTTP_Demo.c,467 :: 		case '6':  len += putConstString("South-West") ; break;
L_SPI_Ethernet_UserTCP24:
	MOVLW       ?lstr_37_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_37_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_37_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
	GOTO        L_SPI_Ethernet_UserTCP18
;HTTP_Demo.c,468 :: 		case '7':  len += putConstString("West") ; break;
L_SPI_Ethernet_UserTCP25:
	MOVLW       ?lstr_38_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_38_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_38_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
	GOTO        L_SPI_Ethernet_UserTCP18
;HTTP_Demo.c,469 :: 		case '8':  len += putConstString("North-West") ; break;
L_SPI_Ethernet_UserTCP26:
	MOVLW       ?lstr_39_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_39_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_39_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
	GOTO        L_SPI_Ethernet_UserTCP18
;HTTP_Demo.c,470 :: 		}
L_SPI_Ethernet_UserTCP17:
	MOVF        _WD+0, 0 
	XORLW       49
	BTFSC       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP19
	MOVF        _WD+0, 0 
	XORLW       50
	BTFSC       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP20
	MOVF        _WD+0, 0 
	XORLW       51
	BTFSC       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP21
	MOVF        _WD+0, 0 
	XORLW       52
	BTFSC       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP22
	MOVF        _WD+0, 0 
	XORLW       53
	BTFSC       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP23
	MOVF        _WD+0, 0 
	XORLW       54
	BTFSC       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP24
	MOVF        _WD+0, 0 
	XORLW       55
	BTFSC       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP25
	MOVF        _WD+0, 0 
	XORLW       56
	BTFSC       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP26
L_SPI_Ethernet_UserTCP18:
;HTTP_Demo.c,472 :: 		len += putConstString("\";") ;
	MOVLW       ?lstr_40_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_40_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_40_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,474 :: 		len += putConstString("var WS=\"") ;
	MOVLW       ?lstr_41_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_41_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_41_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,475 :: 		len += putString(WS) ;
	MOVLW       _WS+0
	MOVWF       FARG_SPI_Ethernet_putString_ptr+0 
	MOVLW       hi_addr(_WS+0)
	MOVWF       FARG_SPI_Ethernet_putString_ptr+1 
	CALL        _SPI_Ethernet_putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,476 :: 		len += putConstString("\";") ;
	MOVLW       ?lstr_42_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_42_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_42_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,478 :: 		len += putConstString("var MNS2=\"") ;
	MOVLW       ?lstr_43_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_43_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_43_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,479 :: 		len += putString(MNS2) ;
	MOVLW       _MNS2+0
	MOVWF       FARG_SPI_Ethernet_putString_ptr+0 
	MOVLW       hi_addr(_MNS2+0)
	MOVWF       FARG_SPI_Ethernet_putString_ptr+1 
	CALL        _SPI_Ethernet_putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,480 :: 		len += putConstString("\";") ;
	MOVLW       ?lstr_44_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_44_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_44_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,482 :: 		len += putConstString("var ST=\"") ;
	MOVLW       ?lstr_45_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_45_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_45_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,483 :: 		len += putString(ST) ;
	MOVLW       _ST+0
	MOVWF       FARG_SPI_Ethernet_putString_ptr+0 
	MOVLW       hi_addr(_ST+0)
	MOVWF       FARG_SPI_Ethernet_putString_ptr+1 
	CALL        _SPI_Ethernet_putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,484 :: 		len += putConstString("\";") ;
	MOVLW       ?lstr_46_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_46_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_46_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,486 :: 		len += putConstString("var BP=\"") ;
	MOVLW       ?lstr_47_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_47_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_47_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,487 :: 		len += putString(BP) ;
	MOVLW       _BP+0
	MOVWF       FARG_SPI_Ethernet_putString_ptr+0 
	MOVLW       hi_addr(_BP+0)
	MOVWF       FARG_SPI_Ethernet_putString_ptr+1 
	CALL        _SPI_Ethernet_putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,488 :: 		len += putConstString("\";") ;
	MOVLW       ?lstr_48_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_48_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_48_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,498 :: 		len += putConstString("var RAD2=\"");
	MOVLW       ?lstr_49_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_49_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_49_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,499 :: 		len += putString(RAD);
	MOVLW       _RAD+0
	MOVWF       FARG_SPI_Ethernet_putString_ptr+0 
	MOVLW       hi_addr(_RAD+0)
	MOVWF       FARG_SPI_Ethernet_putString_ptr+1 
	CALL        _SPI_Ethernet_putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,500 :: 		len += putConstString("\";");
	MOVLW       ?lstr_50_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_50_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_50_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,504 :: 		}
	GOTO        L_SPI_Ethernet_UserTCP27
L_SPI_Ethernet_UserTCP7:
;HTTP_Demo.c,506 :: 		else if(getRequest[5] == 'x')                           // if request path name starts with t, toggle PORTD (LED) bit number that comes after
	MOVF        _getRequest+5, 0 
	XORLW       120
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP28
;HTTP_Demo.c,508 :: 		len = putConstString("Date,AirTemp,SoilTemp,Humidity\n") ;
	MOVLW       ?lstr_51_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_51_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_51_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	MOVWF       SPI_Ethernet_UserTCP_len_L0+0 
	MOVF        R1, 0 
	MOVWF       SPI_Ethernet_UserTCP_len_L0+1 
;HTTP_Demo.c,509 :: 		len += putString(csvbuft) ;
	MOVLW       _csvbuft+0
	MOVWF       FARG_SPI_Ethernet_putString_ptr+0 
	MOVLW       hi_addr(_csvbuft+0)
	MOVWF       FARG_SPI_Ethernet_putString_ptr+1 
	CALL        _SPI_Ethernet_putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,510 :: 		}
	GOTO        L_SPI_Ethernet_UserTCP29
L_SPI_Ethernet_UserTCP28:
;HTTP_Demo.c,512 :: 		else if(getRequest[5] == 'u')
	MOVF        _getRequest+5, 0 
	XORLW       117
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP30
;HTTP_Demo.c,514 :: 		len = putConstString("Slave 1:\n");
	MOVLW       ?lstr_52_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_52_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_52_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	MOVWF       SPI_Ethernet_UserTCP_len_L0+0 
	MOVF        R1, 0 
	MOVWF       SPI_Ethernet_UserTCP_len_L0+1 
;HTTP_Demo.c,515 :: 		len += putString(manch);
	MOVLW       _manch+0
	MOVWF       FARG_SPI_Ethernet_putString_ptr+0 
	MOVLW       hi_addr(_manch+0)
	MOVWF       FARG_SPI_Ethernet_putString_ptr+1 
	CALL        _SPI_Ethernet_putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,516 :: 		len += putConstString("\nSlave 2:\n");
	MOVLW       ?lstr_53_HTTP_Demo+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(?lstr_53_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(?lstr_53_HTTP_Demo+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,517 :: 		len += putString(manch2);
	MOVLW       _manch2+0
	MOVWF       FARG_SPI_Ethernet_putString_ptr+0 
	MOVLW       hi_addr(_manch2+0)
	MOVWF       FARG_SPI_Ethernet_putString_ptr+1 
	CALL        _SPI_Ethernet_putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,518 :: 		}
	GOTO        L_SPI_Ethernet_UserTCP31
L_SPI_Ethernet_UserTCP30:
;HTTP_Demo.c,520 :: 		else if(getRequest[5] == 'g')                           // if request path name starts with t, toggle PORTD (LED) bit number that comes after
	MOVF        _getRequest+5, 0 
	XORLW       103
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP32
;HTTP_Demo.c,522 :: 		len =  putConstString(httpHeader) ;             // HTTP header
	MOVLW       _httpHeader+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(_httpHeader+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(_httpHeader+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	MOVWF       SPI_Ethernet_UserTCP_len_L0+0 
	MOVF        R1, 0 
	MOVWF       SPI_Ethernet_UserTCP_len_L0+1 
;HTTP_Demo.c,523 :: 		len += putConstString(httpMimeTypeHTML) ;       // with HTML MIME type
	MOVLW       _httpMimeTypeHTML+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(_httpMimeTypeHTML+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(_httpMimeTypeHTML+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,524 :: 		len += putConstString(graphPage) ;              // HTML page first part
	MOVF        _graphPage+0, 0 
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVF        _graphPage+1, 0 
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVF        _graphPage+2, 0 
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,525 :: 		}
L_SPI_Ethernet_UserTCP32:
L_SPI_Ethernet_UserTCP31:
L_SPI_Ethernet_UserTCP29:
L_SPI_Ethernet_UserTCP27:
L_SPI_Ethernet_UserTCP6:
;HTTP_Demo.c,526 :: 		if(len == 0)                                            // what do to by default
	MOVLW       0
	XORWF       SPI_Ethernet_UserTCP_len_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SPI_Ethernet_UserTCP95
	MOVLW       0
	XORWF       SPI_Ethernet_UserTCP_len_L0+0, 0 
L__SPI_Ethernet_UserTCP95:
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP33
;HTTP_Demo.c,528 :: 		len =  putConstString(httpHeader) ;             // HTTP header
	MOVLW       _httpHeader+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(_httpHeader+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(_httpHeader+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	MOVWF       SPI_Ethernet_UserTCP_len_L0+0 
	MOVF        R1, 0 
	MOVWF       SPI_Ethernet_UserTCP_len_L0+1 
;HTTP_Demo.c,529 :: 		len += putConstString(httpMimeTypeHTML) ;       // with HTML MIME type
	MOVLW       _httpMimeTypeHTML+0
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVLW       hi_addr(_httpMimeTypeHTML+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVLW       higher_addr(_httpMimeTypeHTML+0)
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,530 :: 		len += putConstString(indexPage) ;              // HTML page first part
	MOVF        _indexPage+0, 0 
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVF        _indexPage+1, 0 
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVF        _indexPage+2, 0 
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,531 :: 		len += putConstString(indexPage2) ;             // HTML page second part
	MOVF        _indexPage2+0, 0 
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVF        _indexPage2+1, 0 
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVF        _indexPage2+2, 0 
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,532 :: 		len += putConstString(indexPage3) ;             // HTML page third part
	MOVF        _indexPage3+0, 0 
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+0 
	MOVF        _indexPage3+1, 0 
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+1 
	MOVF        _indexPage3+2, 0 
	MOVWF       FARG_SPI_Ethernet_putConstString_ptr+2 
	CALL        _SPI_Ethernet_putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;HTTP_Demo.c,533 :: 		}
L_SPI_Ethernet_UserTCP33:
;HTTP_Demo.c,535 :: 		return(len) ;                                          // return to the library with the number of bytes to transmit
	MOVF        SPI_Ethernet_UserTCP_len_L0+0, 0 
	MOVWF       R0 
	MOVF        SPI_Ethernet_UserTCP_len_L0+1, 0 
	MOVWF       R1 
;HTTP_Demo.c,537 :: 		}
	RETURN      0
; end of _SPI_Ethernet_UserTCP

_SPI_Ethernet_UserUDP:

;HTTP_Demo.c,548 :: 		unsigned int  SPI_Ethernet_UserUDP(unsigned char *remoteHost, unsigned int remotePort, unsigned int destPort, unsigned int reqLength, TEthPktFlags *flags)
;HTTP_Demo.c,553 :: 		ByteToStr(remoteHost[0], dyna) ;                // first IP address byte
	MOVFF       FARG_SPI_Ethernet_UserUDP_remoteHost+0, FSR0L
	MOVFF       FARG_SPI_Ethernet_UserUDP_remoteHost+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       _dyna+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;HTTP_Demo.c,554 :: 		dyna[3] = '.' ;
	MOVLW       46
	MOVWF       _dyna+3 
;HTTP_Demo.c,555 :: 		ByteToStr(remoteHost[1], dyna + 4) ;            // second
	MOVLW       1
	ADDWF       FARG_SPI_Ethernet_UserUDP_remoteHost+0, 0 
	MOVWF       FSR0L 
	MOVLW       0
	ADDWFC      FARG_SPI_Ethernet_UserUDP_remoteHost+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       _dyna+4
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(_dyna+4)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;HTTP_Demo.c,556 :: 		dyna[7] = '.' ;
	MOVLW       46
	MOVWF       _dyna+7 
;HTTP_Demo.c,557 :: 		ByteToStr(remoteHost[2], dyna + 8) ;            // third
	MOVLW       2
	ADDWF       FARG_SPI_Ethernet_UserUDP_remoteHost+0, 0 
	MOVWF       FSR0L 
	MOVLW       0
	ADDWFC      FARG_SPI_Ethernet_UserUDP_remoteHost+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       _dyna+8
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(_dyna+8)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;HTTP_Demo.c,558 :: 		dyna[11] = '.' ;
	MOVLW       46
	MOVWF       _dyna+11 
;HTTP_Demo.c,559 :: 		ByteToStr(remoteHost[3], dyna + 12) ;           // fourth
	MOVLW       3
	ADDWF       FARG_SPI_Ethernet_UserUDP_remoteHost+0, 0 
	MOVWF       FSR0L 
	MOVLW       0
	ADDWFC      FARG_SPI_Ethernet_UserUDP_remoteHost+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       _dyna+12
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(_dyna+12)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;HTTP_Demo.c,561 :: 		dyna[15] = ':' ;                                // add separator
	MOVLW       58
	MOVWF       _dyna+15 
;HTTP_Demo.c,564 :: 		WordToStr(remotePort, dyna + 16) ;
	MOVF        FARG_SPI_Ethernet_UserUDP_remotePort+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        FARG_SPI_Ethernet_UserUDP_remotePort+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       _dyna+16
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(_dyna+16)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;HTTP_Demo.c,565 :: 		dyna[21] = '[' ;
	MOVLW       91
	MOVWF       _dyna+21 
;HTTP_Demo.c,566 :: 		WordToStr(destPort, dyna + 22) ;
	MOVF        FARG_SPI_Ethernet_UserUDP_destPort+0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        FARG_SPI_Ethernet_UserUDP_destPort+1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       _dyna+22
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(_dyna+22)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;HTTP_Demo.c,567 :: 		dyna[27] = ']' ;
	MOVLW       93
	MOVWF       _dyna+27 
;HTTP_Demo.c,568 :: 		dyna[28] = 0 ;
	CLRF        _dyna+28 
;HTTP_Demo.c,571 :: 		len = 28 + reqLength;
	MOVLW       28
	ADDWF       FARG_SPI_Ethernet_UserUDP_reqLength+0, 0 
	MOVWF       SPI_Ethernet_UserUDP_len_L0+0 
	MOVLW       0
	ADDWFC      FARG_SPI_Ethernet_UserUDP_reqLength+1, 0 
	MOVWF       SPI_Ethernet_UserUDP_len_L0+1 
;HTTP_Demo.c,574 :: 		SPI_Ethernet_putBytes(dyna, 28) ;
	MOVLW       _dyna+0
	MOVWF       FARG_SPI_Ethernet_putBytes_ptr+0 
	MOVLW       hi_addr(_dyna+0)
	MOVWF       FARG_SPI_Ethernet_putBytes_ptr+1 
	MOVLW       28
	MOVWF       FARG_SPI_Ethernet_putBytes_n+0 
	MOVLW       0
	MOVWF       FARG_SPI_Ethernet_putBytes_n+1 
	CALL        _SPI_Ethernet_putBytes+0, 0
;HTTP_Demo.c,577 :: 		while(reqLength--)
L_SPI_Ethernet_UserUDP34:
	MOVF        FARG_SPI_Ethernet_UserUDP_reqLength+0, 0 
	MOVWF       R0 
	MOVF        FARG_SPI_Ethernet_UserUDP_reqLength+1, 0 
	MOVWF       R1 
	MOVLW       1
	SUBWF       FARG_SPI_Ethernet_UserUDP_reqLength+0, 1 
	MOVLW       0
	SUBWFB      FARG_SPI_Ethernet_UserUDP_reqLength+1, 1 
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserUDP35
;HTTP_Demo.c,579 :: 		SPI_Ethernet_putByte(toupper(SPI_Ethernet_getByte())) ;
	CALL        _SPI_Ethernet_getByte+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_toupper_character+0 
	CALL        _toupper+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_SPI_Ethernet_putByte_v+0 
	CALL        _SPI_Ethernet_putByte+0, 0
;HTTP_Demo.c,580 :: 		}
	GOTO        L_SPI_Ethernet_UserUDP34
L_SPI_Ethernet_UserUDP35:
;HTTP_Demo.c,582 :: 		return(len) ;           // back to the library with the length of the UDP reply
	MOVF        SPI_Ethernet_UserUDP_len_L0+0, 0 
	MOVWF       R0 
	MOVF        SPI_Ethernet_UserUDP_len_L0+1, 0 
	MOVWF       R1 
;HTTP_Demo.c,583 :: 		}
	RETURN      0
; end of _SPI_Ethernet_UserUDP

_Init_Main_RTC:

;HTTP_Demo.c,586 :: 		void Init_Main_RTC() {
;HTTP_Demo.c,588 :: 		TRISB = 0;
	CLRF        TRISB+0 
;HTTP_Demo.c,589 :: 		PORTB = 0xFF;
	MOVLW       255
	MOVWF       PORTB+0 
;HTTP_Demo.c,590 :: 		TRISB = 0xff;
	MOVLW       255
	MOVWF       TRISB+0 
;HTTP_Demo.c,592 :: 		Soft_I2C_Init();           // Initialize Soft I2C communication
	CALL        _Soft_I2C_Init+0, 0
;HTTP_Demo.c,593 :: 		}
	RETURN      0
; end of _Init_Main_RTC

_main:

;HTTP_Demo.c,600 :: 		void    main()
;HTTP_Demo.c,603 :: 		ErrorCount = 0;
	CLRF        _ErrorCount+0 
;HTTP_Demo.c,604 :: 		cnt=0;//358000;
	CLRF        _cnt+0 
	CLRF        _cnt+1 
	CLRF        _cnt+2 
	CLRF        _cnt+3 
;HTTP_Demo.c,605 :: 		manchcnt=0;
	CLRF        _manchcnt+0 
	CLRF        _manchcnt+1 
	CLRF        _manchcnt+2 
	CLRF        _manchcnt+3 
;HTTP_Demo.c,606 :: 		manchcnt2=0;
	CLRF        _manchcnt2+0 
	CLRF        _manchcnt2+1 
	CLRF        _manchcnt2+2 
	CLRF        _manchcnt2+3 
;HTTP_Demo.c,607 :: 		i=0;
	CLRF        _i+0 
	CLRF        _i+1 
;HTTP_Demo.c,609 :: 		memset(csvbuft, 0, 1386);
	MOVLW       _csvbuft+0
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(_csvbuft+0)
	MOVWF       FARG_memset_p1+1 
	CLRF        FARG_memset_character+0 
	MOVLW       106
	MOVWF       FARG_memset_n+0 
	MOVLW       5
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;HTTP_Demo.c,610 :: 		memset(manch,49,14);
	MOVLW       _manch+0
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(_manch+0)
	MOVWF       FARG_memset_p1+1 
	MOVLW       49
	MOVWF       FARG_memset_character+0 
	MOVLW       14
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;HTTP_Demo.c,611 :: 		memset(manch2,49,14);
	MOVLW       _manch2+0
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(_manch2+0)
	MOVWF       FARG_memset_p1+1 
	MOVLW       49
	MOVWF       FARG_memset_character+0 
	MOVLW       14
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;HTTP_Demo.c,612 :: 		memset(WS,0,8);
	MOVLW       _WS+0
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(_WS+0)
	MOVWF       FARG_memset_p1+1 
	CLRF        FARG_memset_character+0 
	MOVLW       8
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;HTTP_Demo.c,613 :: 		memset(WD,0,8);
	MOVLW       _WD+0
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(_WD+0)
	MOVWF       FARG_memset_p1+1 
	CLRF        FARG_memset_character+0 
	MOVLW       8
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;HTTP_Demo.c,614 :: 		memset(ST,0,8);
	MOVLW       _ST+0
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(_ST+0)
	MOVWF       FARG_memset_p1+1 
	CLRF        FARG_memset_character+0 
	MOVLW       8
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;HTTP_Demo.c,615 :: 		memset(BP,0,8);
	MOVLW       _BP+0
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(_BP+0)
	MOVWF       FARG_memset_p1+1 
	CLRF        FARG_memset_character+0 
	MOVLW       8
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;HTTP_Demo.c,616 :: 		memset(MNS2,0,8);
	MOVLW       _MNS2+0
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(_MNS2+0)
	MOVWF       FARG_memset_p1+1 
	CLRF        FARG_memset_character+0 
	MOVLW       8
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;HTTP_Demo.c,617 :: 		memset(RAD,0,8);
	MOVLW       _RAD+0
	MOVWF       FARG_memset_p1+0 
	MOVLW       hi_addr(_RAD+0)
	MOVWF       FARG_memset_p1+1 
	CLRF        FARG_memset_character+0 
	MOVLW       8
	MOVWF       FARG_memset_n+0 
	MOVLW       0
	MOVWF       FARG_memset_n+1 
	CALL        _memset+0, 0
;HTTP_Demo.c,619 :: 		WS[0]=49;
	MOVLW       49
	MOVWF       _WS+0 
;HTTP_Demo.c,620 :: 		WS[1]=49;
	MOVLW       49
	MOVWF       _WS+1 
;HTTP_Demo.c,621 :: 		WD[0]=49;
	MOVLW       49
	MOVWF       _WD+0 
;HTTP_Demo.c,622 :: 		ST[0]=49;
	MOVLW       49
	MOVWF       _ST+0 
;HTTP_Demo.c,623 :: 		ST[1]=49;
	MOVLW       49
	MOVWF       _ST+1 
;HTTP_Demo.c,624 :: 		ST[2]='.';
	MOVLW       46
	MOVWF       _ST+2 
;HTTP_Demo.c,625 :: 		ST[3]=49;
	MOVLW       49
	MOVWF       _ST+3 
;HTTP_Demo.c,626 :: 		BP[0]=49;
	MOVLW       49
	MOVWF       _BP+0 
;HTTP_Demo.c,627 :: 		BP[1]=49;
	MOVLW       49
	MOVWF       _BP+1 
;HTTP_Demo.c,628 :: 		BP[2]=49;
	MOVLW       49
	MOVWF       _BP+2 
;HTTP_Demo.c,629 :: 		BP[3]=49;
	MOVLW       49
	MOVWF       _BP+3 
;HTTP_Demo.c,630 :: 		MNS2[0]=49;
	MOVLW       49
	MOVWF       _MNS2+0 
;HTTP_Demo.c,631 :: 		RAD[0] = 49;
	MOVLW       49
	MOVWF       _RAD+0 
;HTTP_Demo.c,632 :: 		RAD[1] = '.';
	MOVLW       46
	MOVWF       _RAD+1 
;HTTP_Demo.c,633 :: 		RAD[2] = 49;
	MOVLW       49
	MOVWF       _RAD+2 
;HTTP_Demo.c,634 :: 		RAD[3] = 49;
	MOVLW       49
	MOVWF       _RAD+3 
;HTTP_Demo.c,635 :: 		RAD[4] = 0;
	CLRF        _RAD+4 
;HTTP_Demo.c,642 :: 		ADCON1 = 0x0B ;         // ADC convertors will be used with AN2 and AN3
	MOVLW       11
	MOVWF       ADCON1+0 
;HTTP_Demo.c,643 :: 		CMCON  = 0x07 ;         // turn off comparators
	MOVLW       7
	MOVWF       CMCON+0 
;HTTP_Demo.c,648 :: 		TRISA3_bit = 1 ;          // set PORTA as input for ADC
	BSF         TRISA3_bit+0, 3 
;HTTP_Demo.c,649 :: 		TRISA0_bit = 0;
	BCF         TRISA0_bit+0, 0 
;HTTP_Demo.c,650 :: 		TRISA1_bit = 1;           // Input RH
	BSF         TRISA1_bit+0, 1 
;HTTP_Demo.c,651 :: 		TRISA4_bit = 0;
	BCF         TRISA4_bit+0, 4 
;HTTP_Demo.c,652 :: 		TRISA5_bit = 0;
	BCF         TRISA5_bit+0, 5 
;HTTP_Demo.c,653 :: 		PORTD = 0 ;
	CLRF        PORTD+0 
;HTTP_Demo.c,654 :: 		TRISD = 0 ;             // set PORTD as output
	CLRF        TRISD+0 
;HTTP_Demo.c,655 :: 		TRISC = 1;
	MOVLW       1
	MOVWF       TRISC+0 
;HTTP_Demo.c,667 :: 		RA5_bit=1;
	BSF         RA5_bit+0, 5 
;HTTP_Demo.c,668 :: 		RA4_bit=0;
	BCF         RA4_bit+0, 4 
;HTTP_Demo.c,669 :: 		Man_Receive_Init();
	CALL        _Man_Receive_Init+0, 0
;HTTP_Demo.c,670 :: 		Delay_ms(150);
	MOVLW       8
	MOVWF       R11, 0
	MOVLW       157
	MOVWF       R12, 0
	MOVLW       5
	MOVWF       R13, 0
L_main36:
	DECFSZ      R13, 1, 1
	BRA         L_main36
	DECFSZ      R12, 1, 1
	BRA         L_main36
	DECFSZ      R11, 1, 1
	BRA         L_main36
	NOP
	NOP
;HTTP_Demo.c,671 :: 		SPI1_Init();
	CALL        _SPI1_Init+0, 0
;HTTP_Demo.c,672 :: 		SPI_Rd_Ptr = SPI1_Read;
	MOVLW       _SPI1_Read+0
	MOVWF       _SPI_Rd_Ptr+0 
	MOVLW       hi_addr(_SPI1_Read+0)
	MOVWF       _SPI_Rd_Ptr+1 
	MOVLW       FARG_SPI1_Read_buffer+0
	MOVWF       _SPI_Rd_Ptr+2 
	MOVLW       hi_addr(FARG_SPI1_Read_buffer+0)
	MOVWF       _SPI_Rd_Ptr+3 
;HTTP_Demo.c,673 :: 		SPI_Ethernet_Init(myMacAddr, myIpAddr, Spi_Ethernet_FULLDUPLEX) ;
	MOVLW       _myMacAddr+0
	MOVWF       FARG_SPI_Ethernet_Init_mac+0 
	MOVLW       hi_addr(_myMacAddr+0)
	MOVWF       FARG_SPI_Ethernet_Init_mac+1 
	MOVLW       _myIpAddr+0
	MOVWF       FARG_SPI_Ethernet_Init_ip+0 
	MOVLW       hi_addr(_myIpAddr+0)
	MOVWF       FARG_SPI_Ethernet_Init_ip+1 
	MOVLW       1
	MOVWF       FARG_SPI_Ethernet_Init_fullDuplex+0 
	CALL        _SPI_Ethernet_Init+0, 0
;HTTP_Demo.c,675 :: 		SPI_Ethernet_confNetwork(ipMask, gwIpAddr, dnsIpAddr) ;
	MOVLW       _ipMask+0
	MOVWF       FARG_SPI_Ethernet_confNetwork_ipMask+0 
	MOVLW       hi_addr(_ipMask+0)
	MOVWF       FARG_SPI_Ethernet_confNetwork_ipMask+1 
	MOVLW       _gwIpAddr+0
	MOVWF       FARG_SPI_Ethernet_confNetwork_gwIpAddr+0 
	MOVLW       hi_addr(_gwIpAddr+0)
	MOVWF       FARG_SPI_Ethernet_confNetwork_gwIpAddr+1 
	MOVLW       _dnsIpAddr+0
	MOVWF       FARG_SPI_Ethernet_confNetwork_dnsIpAddr+0 
	MOVLW       hi_addr(_dnsIpAddr+0)
	MOVWF       FARG_SPI_Ethernet_confNetwork_dnsIpAddr+1 
	CALL        _SPI_Ethernet_confNetwork+0, 0
;HTTP_Demo.c,678 :: 		Delay_ms(100);                                       // Wait for UART module to stabilize
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_main37:
	DECFSZ      R13, 1, 1
	BRA         L_main37
	DECFSZ      R12, 1, 1
	BRA         L_main37
	DECFSZ      R11, 1, 1
	BRA         L_main37
	NOP
	NOP
;HTTP_Demo.c,684 :: 		Init_Main_RTC();                    // Initialize RTC
	CALL        _Init_Main_RTC+0, 0
;HTTP_Demo.c,686 :: 		RA4_bit=1;
	BSF         RA4_bit+0, 4 
;HTTP_Demo.c,687 :: 		RA5_bit=1;
	BSF         RA5_bit+0, 5 
;HTTP_Demo.c,689 :: 		while(1)    {                        // do foreveryear, csvbuf) ;
L_main38:
;HTTP_Demo.c,692 :: 		cnt=cnt+1;
	MOVLW       1
	ADDWF       _cnt+0, 1 
	MOVLW       0
	ADDWFC      _cnt+1, 1 
	ADDWFC      _cnt+2, 1 
	ADDWFC      _cnt+3, 1 
;HTTP_Demo.c,693 :: 		manchcnt=manchcnt+1;
	MOVLW       1
	ADDWF       _manchcnt+0, 1 
	MOVLW       0
	ADDWFC      _manchcnt+1, 1 
	ADDWFC      _manchcnt+2, 1 
	ADDWFC      _manchcnt+3, 1 
;HTTP_Demo.c,694 :: 		if(cnt==28124000){       //3600000  //18000000  //9008000   //27024000
	MOVF        _cnt+3, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__main96
	MOVF        _cnt+2, 0 
	XORLW       173
	BTFSS       STATUS+0, 2 
	GOTO        L__main96
	MOVF        _cnt+1, 0 
	XORLW       35
	BTFSS       STATUS+0, 2 
	GOTO        L__main96
	MOVF        _cnt+0, 0 
	XORLW       96
L__main96:
	BTFSS       STATUS+0, 2 
	GOTO        L_main40
;HTTP_Demo.c,696 :: 		Soft_I2C_Start();               // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;HTTP_Demo.c,697 :: 		Soft_I2C_Write(0xA0);           // Address PCF8583, see PCF8583 datasheet
	MOVLW       160
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;HTTP_Demo.c,698 :: 		Soft_I2C_Write(2);              // Start from address 2
	MOVLW       2
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;HTTP_Demo.c,699 :: 		Soft_I2C_Start();               // Issue repeated start signal
	CALL        _Soft_I2C_Start+0, 0
;HTTP_Demo.c,700 :: 		Soft_I2C_Write(0xA1);           // Address PCF8583 for reading R/W=1
	MOVLW       161
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;HTTP_Demo.c,702 :: 		seconds = Soft_I2C_Read(1);     // Read seconds byte
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _seconds+0 
	MOVLW       0
	MOVWF       _seconds+1 
;HTTP_Demo.c,703 :: 		minutes = Soft_I2C_Read(1);     // Read minutes byte
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _minutes+0 
	MOVLW       0
	MOVWF       _minutes+1 
;HTTP_Demo.c,704 :: 		hours = 0x3f&Soft_I2C_Read(1);       // Read hours byte
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVLW       63
	ANDWF       R0, 0 
	MOVWF       _hours+0 
	CLRF        _hours+1 
	MOVLW       0
	ANDWF       _hours+1, 1 
	MOVLW       0
	MOVWF       _hours+1 
;HTTP_Demo.c,705 :: 		day = Soft_I2C_Read(1);         // Read year/day byte
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _day+0 
	MOVLW       0
	MOVWF       _day+1 
;HTTP_Demo.c,706 :: 		month = Soft_I2C_Read(0);       // Read weekday/month byte
	CLRF        FARG_Soft_I2C_Read_ack+0 
	CLRF        FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _month+0 
	MOVLW       0
	MOVWF       _month+1 
;HTTP_Demo.c,707 :: 		Soft_I2C_Stop();                // Issue stop signal
	CALL        _Soft_I2C_Stop+0, 0
;HTTP_Demo.c,709 :: 		seconds  =  ((seconds & 0xF0) >> 4)*10 + (seconds & 0x0F);  // Transform seconds
	MOVLW       240
	ANDWF       _seconds+0, 0 
	MOVWF       R3 
	MOVF        _seconds+1, 0 
	MOVWF       R4 
	MOVLW       0
	ANDWF       R4, 1 
	MOVF        R3, 0 
	MOVWF       R0 
	MOVF        R4, 0 
	MOVWF       R1 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVLW       15
	ANDWF       _seconds+0, 0 
	MOVWF       R2 
	MOVF        _seconds+1, 0 
	MOVWF       R3 
	MOVLW       0
	ANDWF       R3, 1 
	MOVF        R2, 0 
	ADDWF       R0, 0 
	MOVWF       _seconds+0 
	MOVF        R3, 0 
	ADDWFC      R1, 0 
	MOVWF       _seconds+1 
;HTTP_Demo.c,710 :: 		minutes  =  ((minutes & 0xF0) >> 4)*10 + (minutes & 0x0F);  // Transform months
	MOVLW       240
	ANDWF       _minutes+0, 0 
	MOVWF       R3 
	MOVF        _minutes+1, 0 
	MOVWF       R4 
	MOVLW       0
	ANDWF       R4, 1 
	MOVF        R3, 0 
	MOVWF       R0 
	MOVF        R4, 0 
	MOVWF       R1 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVLW       15
	ANDWF       _minutes+0, 0 
	MOVWF       R2 
	MOVF        _minutes+1, 0 
	MOVWF       R3 
	MOVLW       0
	ANDWF       R3, 1 
	MOVF        R2, 0 
	ADDWF       R0, 0 
	MOVWF       _minutes+0 
	MOVF        R3, 0 
	ADDWFC      R1, 0 
	MOVWF       _minutes+1 
;HTTP_Demo.c,711 :: 		hours    =  ((hours & 0xF0)  >> 4)*10  + (hours & 0x0F);    // Transform hours
	MOVLW       240
	ANDWF       _hours+0, 0 
	MOVWF       R3 
	MOVF        _hours+1, 0 
	MOVWF       R4 
	MOVLW       0
	ANDWF       R4, 1 
	MOVF        R3, 0 
	MOVWF       R0 
	MOVF        R4, 0 
	MOVWF       R1 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVLW       15
	ANDWF       _hours+0, 0 
	MOVWF       R2 
	MOVF        _hours+1, 0 
	MOVWF       R3 
	MOVLW       0
	ANDWF       R3, 1 
	MOVF        R2, 0 
	ADDWF       R0, 0 
	MOVWF       _hours+0 
	MOVF        R3, 0 
	ADDWFC      R1, 0 
	MOVWF       _hours+1 
;HTTP_Demo.c,712 :: 		year     =   (day & 0xC0) >> 6;                             // Transform year
	MOVLW       192
	ANDWF       _day+0, 0 
	MOVWF       _year+0 
	MOVF        _day+1, 0 
	MOVWF       _year+1 
	MOVLW       0
	ANDWF       _year+1, 1 
	MOVLW       6
	MOVWF       R0 
	MOVF        R0, 0 
L__main97:
	BZ          L__main98
	RRCF        _year+1, 1 
	RRCF        _year+0, 1 
	BCF         _year+1, 7 
	ADDLW       255
	GOTO        L__main97
L__main98:
;HTTP_Demo.c,713 :: 		day      =  ((day & 0x30) >> 4)*10    + (day & 0x0F);       // Transform day
	MOVLW       48
	ANDWF       _day+0, 0 
	MOVWF       R3 
	MOVF        _day+1, 0 
	MOVWF       R4 
	MOVLW       0
	ANDWF       R4, 1 
	MOVF        R3, 0 
	MOVWF       R0 
	MOVF        R4, 0 
	MOVWF       R1 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVLW       15
	ANDWF       _day+0, 0 
	MOVWF       R2 
	MOVF        _day+1, 0 
	MOVWF       R3 
	MOVLW       0
	ANDWF       R3, 1 
	MOVF        R2, 0 
	ADDWF       R0, 0 
	MOVWF       _day+0 
	MOVF        R3, 0 
	ADDWFC      R1, 0 
	MOVWF       _day+1 
;HTTP_Demo.c,714 :: 		month    =  ((month & 0x10)  >> 4)*10 + (month & 0x0F);     // Transform month
	MOVLW       16
	ANDWF       _month+0, 0 
	MOVWF       R3 
	MOVF        _month+1, 0 
	MOVWF       R4 
	MOVLW       0
	ANDWF       R4, 1 
	MOVF        R3, 0 
	MOVWF       R0 
	MOVF        R4, 0 
	MOVWF       R1 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVLW       15
	ANDWF       _month+0, 0 
	MOVWF       R2 
	MOVF        _month+1, 0 
	MOVWF       R3 
	MOVLW       0
	ANDWF       R3, 1 
	MOVF        R2, 0 
	ADDWF       R0, 0 
	MOVWF       _month+0 
	MOVF        R3, 0 
	ADDWFC      R1, 0 
	MOVWF       _month+1 
;HTTP_Demo.c,718 :: 		Ow_Reset(&PORTE, 2);                         // Onewire reset signal
	MOVLW       PORTE+0
	MOVWF       FARG_Ow_Reset_port+0 
	MOVLW       hi_addr(PORTE+0)
	MOVWF       FARG_Ow_Reset_port+1 
	MOVLW       2
	MOVWF       FARG_Ow_Reset_pin+0 
	CALL        _Ow_Reset+0, 0
;HTTP_Demo.c,719 :: 		Ow_Write(&PORTE, 2, 0xCC);                   // Issue command SKIP_ROM
	MOVLW       PORTE+0
	MOVWF       FARG_Ow_Write_port+0 
	MOVLW       hi_addr(PORTE+0)
	MOVWF       FARG_Ow_Write_port+1 
	MOVLW       2
	MOVWF       FARG_Ow_Write_pin+0 
	MOVLW       204
	MOVWF       FARG_Ow_Write_data_+0 
	CALL        _Ow_Write+0, 0
;HTTP_Demo.c,720 :: 		Ow_Write(&PORTE, 2, 0x44);                   // Issue command CONVERT_T
	MOVLW       PORTE+0
	MOVWF       FARG_Ow_Write_port+0 
	MOVLW       hi_addr(PORTE+0)
	MOVWF       FARG_Ow_Write_port+1 
	MOVLW       2
	MOVWF       FARG_Ow_Write_pin+0 
	MOVLW       68
	MOVWF       FARG_Ow_Write_data_+0 
	CALL        _Ow_Write+0, 0
;HTTP_Demo.c,721 :: 		Delay_us(120);
	MOVLW       2
	MOVWF       R12, 0
	MOVLW       141
	MOVWF       R13, 0
L_main41:
	DECFSZ      R13, 1, 1
	BRA         L_main41
	DECFSZ      R12, 1, 1
	BRA         L_main41
	NOP
	NOP
;HTTP_Demo.c,723 :: 		Ow_Reset(&PORTE, 2);
	MOVLW       PORTE+0
	MOVWF       FARG_Ow_Reset_port+0 
	MOVLW       hi_addr(PORTE+0)
	MOVWF       FARG_Ow_Reset_port+1 
	MOVLW       2
	MOVWF       FARG_Ow_Reset_pin+0 
	CALL        _Ow_Reset+0, 0
;HTTP_Demo.c,724 :: 		Ow_Write(&PORTE, 2, 0xCC);                   // Issue command SKIP_ROM
	MOVLW       PORTE+0
	MOVWF       FARG_Ow_Write_port+0 
	MOVLW       hi_addr(PORTE+0)
	MOVWF       FARG_Ow_Write_port+1 
	MOVLW       2
	MOVWF       FARG_Ow_Write_pin+0 
	MOVLW       204
	MOVWF       FARG_Ow_Write_data_+0 
	CALL        _Ow_Write+0, 0
;HTTP_Demo.c,725 :: 		Ow_Write(&PORTE, 2, 0xBE);                   // Issue command READ_SCRATCHPAD
	MOVLW       PORTE+0
	MOVWF       FARG_Ow_Write_port+0 
	MOVLW       hi_addr(PORTE+0)
	MOVWF       FARG_Ow_Write_port+1 
	MOVLW       2
	MOVWF       FARG_Ow_Write_pin+0 
	MOVLW       190
	MOVWF       FARG_Ow_Write_data_+0 
	CALL        _Ow_Write+0, 0
;HTTP_Demo.c,726 :: 		Delay_us(120);
	MOVLW       2
	MOVWF       R12, 0
	MOVLW       141
	MOVWF       R13, 0
L_main42:
	DECFSZ      R13, 1, 1
	BRA         L_main42
	DECFSZ      R12, 1, 1
	BRA         L_main42
	NOP
	NOP
;HTTP_Demo.c,728 :: 		temp =  Ow_Read(&PORTE, 2);
	MOVLW       PORTE+0
	MOVWF       FARG_Ow_Read_port+0 
	MOVLW       hi_addr(PORTE+0)
	MOVWF       FARG_Ow_Read_port+1 
	MOVLW       2
	MOVWF       FARG_Ow_Read_pin+0 
	CALL        _Ow_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _temp+0 
	MOVLW       0
	MOVWF       _temp+1 
;HTTP_Demo.c,729 :: 		temp = (Ow_Read(&PORTE, 2) << 8) + temp;
	MOVLW       PORTE+0
	MOVWF       FARG_Ow_Read_port+0 
	MOVLW       hi_addr(PORTE+0)
	MOVWF       FARG_Ow_Read_port+1 
	MOVLW       2
	MOVWF       FARG_Ow_Read_pin+0 
	CALL        _Ow_Read+0, 0
	MOVF        R0, 0 
	MOVWF       R5 
	CLRF        R4 
	MOVF        _temp+0, 0 
	ADDWF       R4, 0 
	MOVWF       R2 
	MOVF        _temp+1, 0 
	ADDWFC      R5, 0 
	MOVWF       R3 
	MOVF        R2, 0 
	MOVWF       _temp+0 
	MOVF        R3, 0 
	MOVWF       _temp+1 
;HTTP_Demo.c,733 :: 		if (temp & 0x8000) {
	BTFSS       R3, 7 
	GOTO        L_main43
;HTTP_Demo.c,734 :: 		minus = 1;
	MOVLW       1
	MOVWF       _minus+0 
	MOVLW       0
	MOVWF       _minus+1 
;HTTP_Demo.c,735 :: 		temp = ~temp + 1; }
	COMF        _temp+0, 1 
	COMF        _temp+1, 1 
	INFSNZ      _temp+0, 1 
	INCF        _temp+1, 1 
	GOTO        L_main44
L_main43:
;HTTP_Demo.c,737 :: 		minus = 0;
	CLRF        _minus+0 
	CLRF        _minus+1 
;HTTP_Demo.c,738 :: 		}
L_main44:
;HTTP_Demo.c,740 :: 		temp_whole = temp >> RES_SHIFT ;
	MOVF        _temp+0, 0 
	MOVWF       _temp_whole+0 
	MOVF        _temp+1, 0 
	MOVWF       _temp_whole+1 
	RRCF        _temp_whole+1, 1 
	RRCF        _temp_whole+0, 1 
	BCF         _temp_whole+1, 7 
	RRCF        _temp_whole+1, 1 
	RRCF        _temp_whole+0, 1 
	BCF         _temp_whole+1, 7 
	RRCF        _temp_whole+1, 1 
	RRCF        _temp_whole+0, 1 
	BCF         _temp_whole+1, 7 
	RRCF        _temp_whole+1, 1 
	RRCF        _temp_whole+0, 1 
	BCF         _temp_whole+1, 7 
;HTTP_Demo.c,741 :: 		temp_fraction  = temp << (4-RES_SHIFT);
	MOVF        _temp+0, 0 
	MOVWF       _temp_fraction+0 
	MOVF        _temp+1, 0 
	MOVWF       _temp_fraction+1 
;HTTP_Demo.c,743 :: 		RH=ADC_Read(1); //*0.004964;
	MOVLW       1
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _RH+0 
	MOVF        R1, 0 
	MOVWF       _RH+1 
;HTTP_Demo.c,744 :: 		if(RH>=1000) {
	MOVLW       3
	SUBWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main99
	MOVLW       232
	SUBWF       R0, 0 
L__main99:
	BTFSS       STATUS+0, 0 
	GOTO        L_main45
;HTTP_Demo.c,745 :: 		RH=100;
	MOVLW       100
	MOVWF       _RH+0 
	MOVLW       0
	MOVWF       _RH+1 
;HTTP_Demo.c,746 :: 		}
	GOTO        L_main46
L_main45:
;HTTP_Demo.c,748 :: 		RH=RH/10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _RH+0, 0 
	MOVWF       R0 
	MOVF        _RH+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _RH+0 
	MOVF        R1, 0 
	MOVWF       _RH+1 
;HTTP_Demo.c,749 :: 		}
L_main46:
;HTTP_Demo.c,751 :: 		csvbuft[i+0]='2';
	MOVLW       _csvbuft+0
	ADDWF       _i+0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      _i+1, 0 
	MOVWF       FSR1H 
	MOVLW       50
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,752 :: 		csvbuft[i+1]='0';
	MOVLW       1
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       48
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,753 :: 		csvbuft[i+2]='1';
	MOVLW       2
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       49
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,754 :: 		csvbuft[i+3]=year+'0';
	MOVLW       3
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       48
	ADDWF       _year+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,755 :: 		csvbuft[i+4]='-';
	MOVLW       4
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       45
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,756 :: 		csvbuft[i+5]=(month/10)%10 + '0';
	MOVLW       5
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FLOC__main+0 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _month+0, 0 
	MOVWF       R0 
	MOVF        _month+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__main+0, FSR1L
	MOVFF       FLOC__main+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,757 :: 		csvbuft[i+6]=month%10 + '0';
	MOVLW       6
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FLOC__main+0 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _month+0, 0 
	MOVWF       R0 
	MOVF        _month+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__main+0, FSR1L
	MOVFF       FLOC__main+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,758 :: 		csvbuft[i+7]='-';
	MOVLW       7
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       45
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,759 :: 		csvbuft[i+8]=(day/10)%10 + '0';
	MOVLW       8
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FLOC__main+0 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _day+0, 0 
	MOVWF       R0 
	MOVF        _day+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__main+0, FSR1L
	MOVFF       FLOC__main+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,760 :: 		csvbuft[i+9]=day%10 + '0';
	MOVLW       9
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FLOC__main+0 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _day+0, 0 
	MOVWF       R0 
	MOVF        _day+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__main+0, FSR1L
	MOVFF       FLOC__main+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,761 :: 		csvbuft[i+10] = ' ';
	MOVLW       10
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       32
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,762 :: 		csvbuft[i+11] = (hours/10)%10 + '0';
	MOVLW       11
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FLOC__main+0 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _hours+0, 0 
	MOVWF       R0 
	MOVF        _hours+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__main+0, FSR1L
	MOVFF       FLOC__main+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,763 :: 		csvbuft[i+12] = hours%10 + '0';
	MOVLW       12
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FLOC__main+0 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _hours+0, 0 
	MOVWF       R0 
	MOVF        _hours+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__main+0, FSR1L
	MOVFF       FLOC__main+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,764 :: 		csvbuft[i+13] = ':';
	MOVLW       13
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       58
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,765 :: 		csvbuft[i+14] = (minutes/10)%10 + '0';
	MOVLW       14
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FLOC__main+0 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _minutes+0, 0 
	MOVWF       R0 
	MOVF        _minutes+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__main+0, FSR1L
	MOVFF       FLOC__main+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,766 :: 		csvbuft[i+15] = minutes%10 + '0';
	MOVLW       15
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FLOC__main+0 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _minutes+0, 0 
	MOVWF       R0 
	MOVF        _minutes+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__main+0, FSR1L
	MOVFF       FLOC__main+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,767 :: 		csvbuft[i+16] = ':';
	MOVLW       16
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       58
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,768 :: 		csvbuft[i+17] = (seconds/10)%10 + '0';
	MOVLW       17
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FLOC__main+0 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _seconds+0, 0 
	MOVWF       R0 
	MOVF        _seconds+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__main+0, FSR1L
	MOVFF       FLOC__main+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,769 :: 		csvbuft[i+18] = seconds%10 + '0';
	MOVLW       18
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FLOC__main+0 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _seconds+0, 0 
	MOVWF       R0 
	MOVF        _seconds+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__main+0, FSR1L
	MOVFF       FLOC__main+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,770 :: 		csvbuft[i+19] = ',';
	MOVLW       19
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       44
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,771 :: 		if (minus==1){csvbuft[i+20] = '-';}
	MOVLW       0
	XORWF       _minus+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main100
	MOVLW       1
	XORWF       _minus+0, 0 
L__main100:
	BTFSS       STATUS+0, 2 
	GOTO        L_main47
	MOVLW       20
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       45
	MOVWF       POSTINC1+0 
	GOTO        L_main48
L_main47:
;HTTP_Demo.c,772 :: 		else {csvbuft[i+20] = '+';}
	MOVLW       20
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       43
	MOVWF       POSTINC1+0 
L_main48:
;HTTP_Demo.c,773 :: 		csvbuft[i+21] = (temp_whole/10)%10 + '0';
	MOVLW       21
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FLOC__main+0 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _temp_whole+0, 0 
	MOVWF       R0 
	MOVF        _temp_whole+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__main+0, FSR1L
	MOVFF       FLOC__main+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,774 :: 		csvbuft[i+22] = temp_whole%10 + '0';
	MOVLW       22
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FLOC__main+0 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _temp_whole+0, 0 
	MOVWF       R0 
	MOVF        _temp_whole+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__main+0, FSR1L
	MOVFF       FLOC__main+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,775 :: 		csvbuft[i+23] = '.';
	MOVLW       23
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       46
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,776 :: 		csvbuft[i+24] = temp_fraction%10 + '0';
	MOVLW       24
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FLOC__main+0 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _temp_fraction+0, 0 
	MOVWF       R0 
	MOVF        _temp_fraction+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__main+0, FSR1L
	MOVFF       FLOC__main+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,777 :: 		csvbuft[i+25] = (temp_fraction/10)%10 + '0';
	MOVLW       25
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FLOC__main+0 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _temp_fraction+0, 0 
	MOVWF       R0 
	MOVF        _temp_fraction+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__main+0, FSR1L
	MOVFF       FLOC__main+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,778 :: 		csvbuft[i+26] = ',';
	MOVLW       26
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       44
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,779 :: 		csvbuft[i+27] = MNS2[0];
	MOVLW       27
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        _MNS2+0, 0 
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,780 :: 		csvbuft[i+28] = ST[0];
	MOVLW       28
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        _ST+0, 0 
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,781 :: 		csvbuft[i+29] = ST[1];
	MOVLW       29
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        _ST+1, 0 
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,782 :: 		csvbuft[i+30] = '.';
	MOVLW       30
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       46
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,783 :: 		csvbuft[i+31] = ST[3];
	MOVLW       31
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        _ST+3, 0 
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,784 :: 		csvbuft[i+32] = ',';
	MOVLW       32
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       44
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,785 :: 		csvbuft[i+33] = (RH/10)%10 + '0';
	MOVLW       33
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FLOC__main+0 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _RH+0, 0 
	MOVWF       R0 
	MOVF        _RH+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__main+0, FSR1L
	MOVFF       FLOC__main+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,786 :: 		csvbuft[i+34] = RH%10 + '0';
	MOVLW       34
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FLOC__main+0 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        _RH+0, 0 
	MOVWF       R0 
	MOVF        _RH+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__main+0, FSR1L
	MOVFF       FLOC__main+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,787 :: 		csvbuft[i+35] = '\n';
	MOVLW       35
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVLW       _csvbuft+0
	ADDWF       R0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_csvbuft+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       10
	MOVWF       POSTINC1+0 
;HTTP_Demo.c,788 :: 		i=i+36;
	MOVLW       36
	ADDWF       _i+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      _i+1, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       _i+0 
	MOVF        R2, 0 
	MOVWF       _i+1 
;HTTP_Demo.c,789 :: 		if (i==1368){
	MOVF        R2, 0 
	XORLW       5
	BTFSS       STATUS+0, 2 
	GOTO        L__main101
	MOVLW       88
	XORWF       R1, 0 
L__main101:
	BTFSS       STATUS+0, 2 
	GOTO        L_main49
;HTTP_Demo.c,790 :: 		i=0;
	CLRF        _i+0 
	CLRF        _i+1 
;HTTP_Demo.c,791 :: 		}
L_main49:
;HTTP_Demo.c,792 :: 		cnt=0;
	CLRF        _cnt+0 
	CLRF        _cnt+1 
	CLRF        _cnt+2 
	CLRF        _cnt+3 
;HTTP_Demo.c,793 :: 		}
L_main40:
;HTTP_Demo.c,795 :: 		if (manchcnt==2000000){
	MOVF        _manchcnt+3, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__main102
	MOVF        _manchcnt+2, 0 
	XORLW       30
	BTFSS       STATUS+0, 2 
	GOTO        L__main102
	MOVF        _manchcnt+1, 0 
	XORLW       132
	BTFSS       STATUS+0, 2 
	GOTO        L__main102
	MOVF        _manchcnt+0, 0 
	XORLW       128
L__main102:
	BTFSS       STATUS+0, 2 
	GOTO        L_main50
;HTTP_Demo.c,797 :: 		m=0;
	CLRF        _m+0 
	CLRF        _m+1 
;HTTP_Demo.c,798 :: 		RA5_bit=1;
	BSF         RA5_bit+0, 5 
;HTTP_Demo.c,799 :: 		RA4_bit=0;
	BCF         RA4_bit+0, 4 
;HTTP_Demo.c,800 :: 		Delay_ms(10);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main51:
	DECFSZ      R13, 1, 1
	BRA         L_main51
	DECFSZ      R12, 1, 1
	BRA         L_main51
	NOP
	NOP
;HTTP_Demo.c,801 :: 		while (1) {
L_main52:
;HTTP_Demo.c,802 :: 		tempman = Man_Receive(&error);               // Attempt byte receive
	MOVLW       _error+0
	MOVWF       FARG_Man_Receive_error+0 
	MOVLW       hi_addr(_error+0)
	MOVWF       FARG_Man_Receive_error+1 
	CALL        _Man_Receive+0, 0
	MOVF        R0, 0 
	MOVWF       _tempman+0 
;HTTP_Demo.c,803 :: 		if (tempman == 0x0B)                         // "Start" byte, see Transmitter example
	MOVF        R0, 0 
	XORLW       11
	BTFSS       STATUS+0, 2 
	GOTO        L_main54
;HTTP_Demo.c,804 :: 		break;                                  // We got the starting sequence
	GOTO        L_main53
L_main54:
;HTTP_Demo.c,805 :: 		if (error)                                // Exit so we do not loop forever
	MOVF        _error+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main55
;HTTP_Demo.c,806 :: 		break;
	GOTO        L_main53
L_main55:
;HTTP_Demo.c,807 :: 		}
	GOTO        L_main52
L_main53:
;HTTP_Demo.c,809 :: 		do
L_main56:
;HTTP_Demo.c,811 :: 		tempman = Man_Receive(&error);             // Attempt byte receive
	MOVLW       _error+0
	MOVWF       FARG_Man_Receive_error+0 
	MOVLW       hi_addr(_error+0)
	MOVWF       FARG_Man_Receive_error+1 
	CALL        _Man_Receive+0, 0
	MOVF        R0, 0 
	MOVWF       _tempman+0 
;HTTP_Demo.c,812 :: 		if (error) {                            // If error occured
	MOVF        _error+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main59
;HTTP_Demo.c,813 :: 		ErrorCount++;                         // Update error counter
	INCF        _ErrorCount+0, 1 
;HTTP_Demo.c,814 :: 		if (ErrorCount > 20) {                // In case of multiple errors
	MOVF        _ErrorCount+0, 0 
	SUBLW       20
	BTFSC       STATUS+0, 0 
	GOTO        L_main60
;HTTP_Demo.c,815 :: 		tempman = Man_Synchro();               // Try to synchronize again
	CALL        _Man_Synchro+0, 0
	MOVF        R0, 0 
	MOVWF       _tempman+0 
;HTTP_Demo.c,816 :: 		Man_Receive_Init();               // Alternative, try to Initialize Receiver again
	CALL        _Man_Receive_Init+0, 0
;HTTP_Demo.c,817 :: 		ErrorCount = 0;                     // Reset error counter
	CLRF        _ErrorCount+0 
;HTTP_Demo.c,818 :: 		}
L_main60:
;HTTP_Demo.c,819 :: 		}
	GOTO        L_main61
L_main59:
;HTTP_Demo.c,821 :: 		if (tempman != 0x0E)
	MOVF        _tempman+0, 0 
	XORLW       14
	BTFSC       STATUS+0, 2 
	GOTO        L_main62
;HTTP_Demo.c,822 :: 		manch[m]=tempman;                     // If "End" byte was received(see Transmitter example)
	MOVLW       _manch+0
	ADDWF       _m+0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_manch+0)
	ADDWFC      _m+1, 0 
	MOVWF       FSR1H 
	MOVF        _tempman+0, 0 
	MOVWF       POSTINC1+0 
L_main62:
;HTTP_Demo.c,823 :: 		m++;
	INFSNZ      _m+0, 1 
	INCF        _m+1, 1 
;HTTP_Demo.c,824 :: 		}
L_main61:
;HTTP_Demo.c,825 :: 		Delay_ms(25);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       69
	MOVWF       R12, 0
	MOVLW       169
	MOVWF       R13, 0
L_main63:
	DECFSZ      R13, 1, 1
	BRA         L_main63
	DECFSZ      R12, 1, 1
	BRA         L_main63
	DECFSZ      R11, 1, 1
	BRA         L_main63
	NOP
	NOP
;HTTP_Demo.c,828 :: 		while (tempman != 0x0E) ;                      // If "End" byte was received exit do loop
	MOVF        _tempman+0, 0 
	XORLW       14
	BTFSS       STATUS+0, 2 
	GOTO        L_main56
;HTTP_Demo.c,829 :: 		m=0;
	CLRF        _m+0 
	CLRF        _m+1 
;HTTP_Demo.c,830 :: 		manchcnt=0;
	CLRF        _manchcnt+0 
	CLRF        _manchcnt+1 
	CLRF        _manchcnt+2 
	CLRF        _manchcnt+3 
;HTTP_Demo.c,831 :: 		manch[9]=0;
	CLRF        _manch+9 
;HTTP_Demo.c,834 :: 		if((manch[0]==49) && ((manch[0] + manch[1] + manch[2] + manch[3] + manch[4] + manch[5] + manch[6] + manch[7])%2)+48==manch[8]){
	MOVF        _manch+0, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_main66
	MOVF        _manch+1, 0 
	ADDWF       _manch+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        _manch+2, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        _manch+3, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        _manch+4, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        _manch+5, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        _manch+6, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        _manch+7, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       2
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       R2 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       R3 
	MOVLW       0
	XORWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main103
	MOVF        _manch+8, 0 
	XORWF       R2, 0 
L__main103:
	BTFSS       STATUS+0, 2 
	GOTO        L_main66
L__main86:
;HTTP_Demo.c,836 :: 		WD[0]=manch[3];
	MOVF        _manch+3, 0 
	MOVWF       _WD+0 
;HTTP_Demo.c,837 :: 		WD[1]=0;
	CLRF        _WD+1 
;HTTP_Demo.c,839 :: 		WS[0]=manch[1];
	MOVF        _manch+1, 0 
	MOVWF       _WS+0 
;HTTP_Demo.c,840 :: 		WS[1]=manch[2];
	MOVF        _manch+2, 0 
	MOVWF       _WS+1 
;HTTP_Demo.c,841 :: 		WS[2]=0;
	CLRF        _WS+2 
;HTTP_Demo.c,843 :: 		MNS2[0]=manch[4];
	MOVF        _manch+4, 0 
	MOVWF       _MNS2+0 
;HTTP_Demo.c,844 :: 		MNS2[1]=0;
	CLRF        _MNS2+1 
;HTTP_Demo.c,846 :: 		ST[0]=manch[5];
	MOVF        _manch+5, 0 
	MOVWF       _ST+0 
;HTTP_Demo.c,847 :: 		ST[1]=manch[6];
	MOVF        _manch+6, 0 
	MOVWF       _ST+1 
;HTTP_Demo.c,848 :: 		ST[2]='.';
	MOVLW       46
	MOVWF       _ST+2 
;HTTP_Demo.c,849 :: 		ST[3]=manch[7];
	MOVF        _manch+7, 0 
	MOVWF       _ST+3 
;HTTP_Demo.c,850 :: 		ST[4]=0;
	CLRF        _ST+4 
;HTTP_Demo.c,852 :: 		RA4_bit=1;
	BSF         RA4_bit+0, 4 
;HTTP_Demo.c,853 :: 		RA5_bit=1;
	BSF         RA5_bit+0, 5 
;HTTP_Demo.c,854 :: 		Delay_ms(25);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       69
	MOVWF       R12, 0
	MOVLW       169
	MOVWF       R13, 0
L_main67:
	DECFSZ      R13, 1, 1
	BRA         L_main67
	DECFSZ      R12, 1, 1
	BRA         L_main67
	DECFSZ      R11, 1, 1
	BRA         L_main67
	NOP
	NOP
;HTTP_Demo.c,855 :: 		}
L_main66:
;HTTP_Demo.c,856 :: 		}
L_main50:
;HTTP_Demo.c,857 :: 		manchcnt2++;
	MOVLW       1
	ADDWF       _manchcnt2+0, 1 
	MOVLW       0
	ADDWFC      _manchcnt2+1, 1 
	ADDWFC      _manchcnt2+2, 1 
	ADDWFC      _manchcnt2+3, 1 
;HTTP_Demo.c,858 :: 		if(manchcnt2==3200000){
	MOVF        _manchcnt2+3, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__main104
	MOVF        _manchcnt2+2, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L__main104
	MOVF        _manchcnt2+1, 0 
	XORLW       212
	BTFSS       STATUS+0, 2 
	GOTO        L__main104
	MOVF        _manchcnt2+0, 0 
	XORLW       0
L__main104:
	BTFSS       STATUS+0, 2 
	GOTO        L_main68
;HTTP_Demo.c,859 :: 		RA4_bit=1;
	BSF         RA4_bit+0, 4 
;HTTP_Demo.c,860 :: 		RA5_bit=0;
	BCF         RA5_bit+0, 5 
;HTTP_Demo.c,861 :: 		Delay_ms(10);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main69:
	DECFSZ      R13, 1, 1
	BRA         L_main69
	DECFSZ      R12, 1, 1
	BRA         L_main69
	NOP
	NOP
;HTTP_Demo.c,863 :: 		while (1) {
L_main70:
;HTTP_Demo.c,864 :: 		tempman = Man_Receive(&error);               // Attempt byte receive
	MOVLW       _error+0
	MOVWF       FARG_Man_Receive_error+0 
	MOVLW       hi_addr(_error+0)
	MOVWF       FARG_Man_Receive_error+1 
	CALL        _Man_Receive+0, 0
	MOVF        R0, 0 
	MOVWF       _tempman+0 
;HTTP_Demo.c,865 :: 		if (tempman == 0x0B)                         // "Start" byte, see Transmitter example
	MOVF        R0, 0 
	XORLW       11
	BTFSS       STATUS+0, 2 
	GOTO        L_main72
;HTTP_Demo.c,866 :: 		break;                                  // We got the starting sequence
	GOTO        L_main71
L_main72:
;HTTP_Demo.c,867 :: 		if (error)                                // Exit so we do not loop forever
	MOVF        _error+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main73
;HTTP_Demo.c,868 :: 		break;
	GOTO        L_main71
L_main73:
;HTTP_Demo.c,869 :: 		}
	GOTO        L_main70
L_main71:
;HTTP_Demo.c,871 :: 		do
L_main74:
;HTTP_Demo.c,873 :: 		tempman = Man_Receive(&error);             // Attempt byte receive
	MOVLW       _error+0
	MOVWF       FARG_Man_Receive_error+0 
	MOVLW       hi_addr(_error+0)
	MOVWF       FARG_Man_Receive_error+1 
	CALL        _Man_Receive+0, 0
	MOVF        R0, 0 
	MOVWF       _tempman+0 
;HTTP_Demo.c,874 :: 		if (error) {                            // If error occured
	MOVF        _error+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main77
;HTTP_Demo.c,875 :: 		ErrorCount++;                         // Update error counter
	INCF        _ErrorCount+0, 1 
;HTTP_Demo.c,876 :: 		if (ErrorCount > 20) {                // In case of multiple errors
	MOVF        _ErrorCount+0, 0 
	SUBLW       20
	BTFSC       STATUS+0, 0 
	GOTO        L_main78
;HTTP_Demo.c,877 :: 		tempman = Man_Synchro();               // Try to synchronize again
	CALL        _Man_Synchro+0, 0
	MOVF        R0, 0 
	MOVWF       _tempman+0 
;HTTP_Demo.c,878 :: 		Man_Receive_Init();               // Alternative, try to Initialize Receiver again
	CALL        _Man_Receive_Init+0, 0
;HTTP_Demo.c,879 :: 		ErrorCount = 0;                     // Reset error counter
	CLRF        _ErrorCount+0 
;HTTP_Demo.c,880 :: 		}
L_main78:
;HTTP_Demo.c,881 :: 		}
	GOTO        L_main79
L_main77:
;HTTP_Demo.c,883 :: 		if (tempman != 0x0E)
	MOVF        _tempman+0, 0 
	XORLW       14
	BTFSC       STATUS+0, 2 
	GOTO        L_main80
;HTTP_Demo.c,884 :: 		manch2[m]=tempman;                     // If "End" byte was received(see Transmitter example)
	MOVLW       _manch2+0
	ADDWF       _m+0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_manch2+0)
	ADDWFC      _m+1, 0 
	MOVWF       FSR1H 
	MOVF        _tempman+0, 0 
	MOVWF       POSTINC1+0 
L_main80:
;HTTP_Demo.c,885 :: 		m++;
	INFSNZ      _m+0, 1 
	INCF        _m+1, 1 
;HTTP_Demo.c,886 :: 		}
L_main79:
;HTTP_Demo.c,887 :: 		Delay_ms(25);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       69
	MOVWF       R12, 0
	MOVLW       169
	MOVWF       R13, 0
L_main81:
	DECFSZ      R13, 1, 1
	BRA         L_main81
	DECFSZ      R12, 1, 1
	BRA         L_main81
	DECFSZ      R11, 1, 1
	BRA         L_main81
	NOP
	NOP
;HTTP_Demo.c,890 :: 		while (tempman != 0x0E) ;                      // If "End" byte was received exit do loop
	MOVF        _tempman+0, 0 
	XORLW       14
	BTFSS       STATUS+0, 2 
	GOTO        L_main74
;HTTP_Demo.c,891 :: 		m=0;
	CLRF        _m+0 
	CLRF        _m+1 
;HTTP_Demo.c,892 :: 		manchcnt2=0;
	CLRF        _manchcnt2+0 
	CLRF        _manchcnt2+1 
	CLRF        _manchcnt2+2 
	CLRF        _manchcnt2+3 
;HTTP_Demo.c,893 :: 		manch2[9]=0;
	CLRF        _manch2+9 
;HTTP_Demo.c,894 :: 		if((manch2[0]=='1') && ((manch2[0] + manch2[1] + manch2[2] + manch2[3] + manch2[4] + manch2[5] + manch2[6] + manch2[7])%2)+48==manch2[8]){
	MOVF        _manch2+0, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_main84
	MOVF        _manch2+1, 0 
	ADDWF       _manch2+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        _manch2+2, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        _manch2+3, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        _manch2+4, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        _manch2+5, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        _manch2+6, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        _manch2+7, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       2
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       R2 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       R3 
	MOVLW       0
	XORWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main105
	MOVF        _manch2+8, 0 
	XORWF       R2, 0 
L__main105:
	BTFSS       STATUS+0, 2 
	GOTO        L_main84
L__main85:
;HTTP_Demo.c,895 :: 		BP[0]=manch2[1];
	MOVF        _manch2+1, 0 
	MOVWF       _BP+0 
;HTTP_Demo.c,896 :: 		BP[1]=manch2[2];
	MOVF        _manch2+2, 0 
	MOVWF       _BP+1 
;HTTP_Demo.c,897 :: 		BP[2]=manch2[3];
	MOVF        _manch2+3, 0 
	MOVWF       _BP+2 
;HTTP_Demo.c,898 :: 		BP[3]=manch2[4];
	MOVF        _manch2+4, 0 
	MOVWF       _BP+3 
;HTTP_Demo.c,899 :: 		BP[4]=0;
	CLRF        _BP+4 
;HTTP_Demo.c,901 :: 		RAD[0] = manch2[5];
	MOVF        _manch2+5, 0 
	MOVWF       _RAD+0 
;HTTP_Demo.c,902 :: 		RAD[1] = '.' ;
	MOVLW       46
	MOVWF       _RAD+1 
;HTTP_Demo.c,903 :: 		RAD[2] = manch2[6];
	MOVF        _manch2+6, 0 
	MOVWF       _RAD+2 
;HTTP_Demo.c,904 :: 		RAD[3] = manch2[7];
	MOVF        _manch2+7, 0 
	MOVWF       _RAD+3 
;HTTP_Demo.c,905 :: 		RAD[4] = 0;
	CLRF        _RAD+4 
;HTTP_Demo.c,907 :: 		RA5_bit=1;
	BSF         RA5_bit+0, 5 
;HTTP_Demo.c,908 :: 		RA4_bit=1;
	BSF         RA4_bit+0, 4 
;HTTP_Demo.c,909 :: 		}
L_main84:
;HTTP_Demo.c,910 :: 		}
L_main68:
;HTTP_Demo.c,912 :: 		SPI_Ethernet_doPacket() ;   // process incoming Ethernet packets
	CALL        _SPI_Ethernet_doPacket+0, 0
;HTTP_Demo.c,914 :: 		}
	GOTO        L_main38
;HTTP_Demo.c,917 :: 		}
	GOTO        $+0
; end of _main
