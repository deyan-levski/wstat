/*******************************************************************************
PROTOTYPE       : unsigned char SPI_Ethernet_readPacket()
PARAMETERS      : none
RETURNS         : nothing
DESCRIPTION     : process next packet available in ENC RAM buffer
REQUIRES        : SPI_Ethernet_init must have been called before
                  ERDPT must be correctly set either by SPI_Ethernet_init, or previous call to readPacket()
EXAMPLE         : SPI_Ethernet_readPacket()
*******************************************************************************/
unsigned char    SPI_Ethernet_readPacket();


/*******************************************************************************
PROTOTYPE       : void    SPI_Ethernet_doTCP(unsigned int start, unsigned int ipHeaderLen, unsigned int payloadAddr)
PARAMETERS      :
        start           : address of incoming packet in ENC receive buffer
        idHeaderLen     : size of IP header
        payLoadAddr     : address of payload in ENC transmit buffer
RETURNS         : nothing
DESCRIPTION     : handles an unframented, single-packet TCP/IP request
REQUIRES        : this function must be called only from SPI_Ethernet_readPacket()
EXAMPLE         :
*******************************************************************************/
void    SPI_Ethernet_doTCP(unsigned int start, unsigned int ipHeaderLen, unsigned int payloadAddr);


/*******************************************************************************
PROTOTYPE       : void SPI_Ethernet_doUDP(unsigned int start, unsigned char ipHeaderLen, unsigned int payloadAddr)
PARAMETERS      :
        start           : address of incoming packet in ENC receive buffer
        idHeaderLen     : size of IP header
        payLoadAddr     : address of payload in ENC transmit buffer
RETURNS         : nothing
DESCRIPTION     : reply to an UDP/IP request
REQUIRES        : this function must be called only from SPI_Ethernet_readPacket()
EXAMPLE         :
*******************************************************************************/
void SPI_Ethernet_doUDP(unsigned int start, unsigned char ipHeaderLen, unsigned int payloadAddr);
char SPI_Ethernet_sendUDP2(unsigned char *destMAC, unsigned char *destIP, unsigned int sourcePort, unsigned int destPort, unsigned int pktLen);

/*******************************************************************************
PROTOTYPE       : void SPI_Ethernet_doDHCP()
PARAMETERS      : none
RETURNS         : nothing
DESCRIPTION     : services dhcp
REQUIRES        : this function must be called only from SPI_Ethernet_readPacket()
EXAMPLE         :
*******************************************************************************/
void SPI_Ethernet_doDHCP();
unsigned char SPI_Ethernet_DHCPReceive(void);
unsigned char SPI_Ethernet_DHCPmsg(unsigned char  messageType, unsigned char renewFlag);


/*******************************************************************************
PROTOTYPE       : void SPI_Ethernet_doDNS()
PARAMETERS      : none
RETURNS         : nothing
DESCRIPTION     : services DNS
REQUIRES        : this function must be called only from SPI_Ethernet_readPacket()
EXAMPLE         :
*******************************************************************************/
void SPI_Ethernet_doDNS();

/*******************************************************************************
PROTOTYPE       : void SPI_Ethernet_doARP()
PARAMETERS      : none
RETURNS         : nothing
DESCRIPTION     : services ARP
REQUIRES        : this function must be called only from SPI_Ethernet_readPacket()
EXAMPLE         :
*******************************************************************************/
void SPI_Ethernet_doARP();

/*******************************************************************************
PROTOTYPE       : SPI_Ethernet_checksum(unsigned int start, unsigned int l)
PARAMETERS      :
        start           address of first byte in ENC memory
        l               number of bytes to include in checksum calculation
RETURNS         : nothing (result is in ENC EDMACS[H:L] registers)
DESCRIPTION     : ENC performs DMA checksum of l bytes starting from start addr
REQUIRES        : SPI_Ethernet_init must have been called
EXAMPLE         : SPI_Ethernet_checksum(0x1000, 60)
*******************************************************************************/
void    SPI_Ethernet_checksum(unsigned int start, unsigned int l);


/*******************************************************************************
PROTOTYPE       : SPI_Ethernet_RAMcopy(unsigned int start, unsigned int stop, unsigned int dest, unsigned char w)
PARAMETERS      :
        start           address of first source byte (included) in ENC memory to copy
        stop            address of last source byte (not included) in ENC memory to copy
        dest            address of first destination byte in ENC memroy
        v               mode : 0 = no wrap (copy from transmit buffer), 1 = wrap (copy from receive buffer)
RETURNS         : nothing
DESCRIPTION     : ENC performs DMA memory copy from start to dest.
                  if wrap is allowed, performs correct operation to avoid ENC hang on circular buffer
REQUIRES        : SPI_Ethernet_init must have been called before
EXAMPLE         : SPI_Ethernet_RAMcopy(0x500, 0x600, 0x1400, 1)
*******************************************************************************/
void    SPI_Ethernet_RAMcopy(unsigned int start, unsigned int stop, unsigned int dest, unsigned char w);


/*******************************************************************************
PROTOTYPE       : SPI_Ethernet_MACswap()
PARAMETERS      : none
RETURNS         : nothing
DESCRIPTION     : swap MAC addresses in ETH transmit buffer
REQUIRES        : SPI_Ethernet_init must have been called before
EXAMPLE         : SPI_Ethernet_MACswap()
*******************************************************************************/
void    SPI_Ethernet_MACswap();


/*******************************************************************************
PROTOTYPE       : SPI_Ethernet_IPswap()
PARAMETERS      : none
RETURNS         : nothing
DESCRIPTION     : swap IP addresses in IP transmit buffer
REQUIRES        : SPI_Ethernet_init must have been called before
EXAMPLE         : SPI_Ethernet_IPswap()
*******************************************************************************/
void    SPI_Ethernet_IPswap(void);


/*******************************************************************************
PROTOTYPE       : SPI_Ethernet_TXpacket(unsigned int l)
PARAMETERS      : length in bytes of packet to transmit
RETURNS         : 0 on error, 1 otherwise
DESCRIPTION     : send packet over wires
REQUIRES        : SPI_Ethernet_init must have been called before
EXAMPLE         : SPI_Ethernet_TXpacket(60)
*******************************************************************************/
unsigned char SPI_Ethernet_TXpacket(unsigned int l);


/*******************************************************************************
PROTOTYPE       : unsigned char   SPI_Ethernet_memcmp(unsigned int addr, unsigned char *s, unsigned char l)
PARAMETERS      :
        addr    : address of first byte in ENC RAM to compare
        s       : pointer to first byte of PIC RAM to compare
        l       : length in bytes of memory to compare
RETURNS         : 0 if compare matches, > 0 otherwise
DESCRIPTION     : compares ENC RAM to PIC RAM
REQUIRES        : SPI_Ethernet_init must have been called before
EXAMPLE         : SPI_Ethernet_memcmp(0x0600, "TEST", 4)
*******************************************************************************/
unsigned char   SPI_Ethernet_memcmp(unsigned int addr, unsigned char *s, unsigned char l);


/*******************************************************************************
PROTOTYPE       : void SPI_Ethernet_memcpy(unsigned int addr, unsigned char *s, unsigned int l)
PARAMETERS      :
        addr    : destination address of first byte in ENC RAM
        s       : pointer to first byte of PIC RAM to copy to ENC
        l       : length in bytes of memory to copy
RETURNS         : nothing
DESCRIPTION     : copy PIC memory to ENC RAM.
REQUIRES        : SPI_Ethernet_init must have been called before
EXAMPLE         : SPI_Ethernet_memcpy(0x0600, "TEST", 4)
*******************************************************************************/
void SPI_Ethernet_memcpy(unsigned int addr, unsigned char *s, unsigned int l);


/*******************************************************************************
PROTOTYPE       : void SPI_Ethernet_writeMemory(unsigned int addr, unsigned char v1, unsigned char v2, unsigned char bis)
PARAMETERS      :
        addr    : destination address of first byte in ENC RAM
        v1      : value to store @ addr
        v2      : value to store @ addr + 1 if bis is set
        bis     : if 0, store only v1, otherwise store also v2
RETURNS         : nothing
DESCRIPTION     : store one or two chars to ENC RAM
REQUIRES        : SPI_Ethernet_init must have been called before
EXAMPLE         : SPI_Ethernet_writeMemory(0x100, 12, 0, 0)
*******************************************************************************/
void SPI_Ethernet_writeMemory(unsigned int addr, unsigned char v1, unsigned char v2);


/*******************************************************************************
PROTOTYPE       : void SPI_Ethernet_writeMemory2(unsigned int v)
PARAMETERS      :
        v       : two byte value to be stored @ enc memory locations pointed to by
                  current/current+1 write pointer (WRPTL). High byte is written
                  to lower address (high byte first).
RETURNS         : nothing
DESCRIPTION     : store two chars to ENC RAM
REQUIRES        : SPI_Ethernet_init must have been called before
EXAMPLE         : SPI_Ethernet_writeMemory2(0x100)
*******************************************************************************/
void SPI_Ethernet_writeMemory2(unsigned int v);


/*******************************************************************************
PROTOTYPE       : void SPI_Ethernet_writeMem(unsigned int addr, unsigned char v1);
PARAMETERS      :
        addr    : destination address in ENC RAM
        v1      : value to store @ addr
RETURNS         : nothing
DESCRIPTION     : store one char to ENC RAM
REQUIRES        : SPI_Ethernet_init must have been called before
EXAMPLE         : SPI_Ethernet_writeMem(0x100, 12)
*******************************************************************************/
void SPI_Ethernet_writeMem(unsigned int addr, unsigned char v1);


/*******************************************************************************
PROTOTYPE       : unsigned char   SPI_Ethernet_readMem(unsigned int addr)
PARAMETERS      :
        addr    : address of first byte to read
RETURNS         : value of byte @ addr
DESCRIPTION     : read one byte from ENC RAM
REQUIRES        : SPI_Ethernet_init must have been called before
EXAMPLE         : b = SPI_Ethernet_readMem(0x0250);
*******************************************************************************/
unsigned char   SPI_Ethernet_readMem(unsigned int addr);


/*******************************************************************************
PROTOTYPE       : unsigned char   SPI_Ethernet_readReg(unsigned char addr)
PARAMETERS      :
        addr    : address of ENC register to read
RETURNS         : value of register @ addr in current bank selection
DESCRIPTION     : read an ENC register
REQUIRES        : SPI_Ethernet_init must have been called before
                  bank selection is supposed to be already made
EXAMPLE         : b = SPI_Ethernet_readReg(0x10);
*******************************************************************************/
unsigned char   SPI_Ethernet_readReg(unsigned char addr);


/*******************************************************************************
PROTOTYPE       : void    SPI_Ethernet_writeReg(unsigned char addr, unsigned short v)
PARAMETERS      :
        addr    : address of ENC register to write in current bank selection
        v       : value to write
RETURNS         : nothing
DESCRIPTION     : writes a byte to an ENC register
REQUIRES        : SPI_Ethernet_init must have been called before
                  bank selection is supposed to be already made
EXAMPLE         : SPI_Ethernet_writeReg(0w0400, 0x10);
*******************************************************************************/
void    SPI_Ethernet_writeReg(unsigned char addr, unsigned short v);


/*******************************************************************************
PROTOTYPE       : void    SPI_Ethernet_setBitReg(unsigned char addr, unsigned char mask)
PARAMETERS      :
        addr    : address of ENC register
        mask    : bit mask of bits to set
RETURNS         : nothing
DESCRIPTION     : ENC register is ORed with mask
REQUIRES        : SPI_Ethernet_init must have been called before
                  bank selection is supposed to be already made
EXAMPLE         : SPI_Ethernet_setBitReg(0x12, 0b00010010);
*******************************************************************************/
void    SPI_Ethernet_setBitReg(unsigned char addr, unsigned char mask);


/*******************************************************************************
PROTOTYPE       : void    SPI_Ethernet_clearBitReg(unsigned char addr, unsigned char mask)
PARAMETERS      :
        addr    : address of ENC register
        mask    : bit mask of bits to clear
RETURNS         : nothing
DESCRIPTION     : ENC register is ANDed with complement of mask
REQUIRES        : SPI_Ethernet_init must have been called before
                  bank selection is supposed to be already made
EXAMPLE         : SPI_Ethernet_clearBitReg(0x12, 0b00010010);
*******************************************************************************/
void    SPI_Ethernet_clearBitReg(unsigned char addr, unsigned char mask);


/*******************************************************************************
PROTOTYPE       : void SPI_Ethernet_setRxReadAddress(unsigned addr)
PARAMETERS      :
        addr    : absolute address (not taking care of wrapping) in enc receive buffer
RETURNS         : nothing
DESCRIPTION     : adjusts given enc buffer address taking care of receive buffer wrapping and
                  writes it into rx buffer read pointer (ERDPT)
REQUIRES        : SPI_Ethernet_init must have been called before
                  bank selection is supposed to be already made
EXAMPLE         : SPI_Ethernet_setRxReadAddress(0x1000);
*******************************************************************************/
void SPI_Ethernet_setRxReadAddress(unsigned addr);


/*******************************************************************************
PROTOTYPE       : void    SPI_Ethernet_writeAddr(unsigned char addr, unsigned int v)
PARAMETERS      :
        addr    : address of ENC register to write in current bank selection
        v       : value to write
RETURNS         : nothing
DESCRIPTION     : writes an ENC register with high and low part
REQUIRES        : SPI_Ethernet_init must have been called before
                  bank selection is supposed to be already made
EXAMPLE         : SPI_Ethernet_writeReg(0w0400, 0x1000);
*******************************************************************************/
void    SPI_Ethernet_writeAddr(unsigned char addr, unsigned int v);


/*******************************************************************************
PROTOTYPE       : void    SPI_Ethernet_writePHY(unsigned char reg, unsigned short h, unsigned short l)
PARAMETERS      :
        reg     : address of ENC PHY
        h       : high byte to write to register
        l       : low byte to write to register
RETURNS         : nothing
DESCRIPTION     : writes high and low bytes to PHY register
REQUIRES        : SPI_Ethernet_init must have been called before
EXAMPLE         : SPI_Ethernet_writePHY(3, 0, 0)
*******************************************************************************/
void    SPI_Ethernet_writePHY(unsigned char reg, unsigned short h, unsigned short l);


/*******************************************************************************
PROTOTYPE       : void    SPI_Ethernet_readPHY(unsigned char reg, unsigned char *h, unsigned char *l)
PARAMETERS      :
        reg     : address of ENC PHY
        h       : pointer to high byte storage location
        l       : pointer to low byte storage location
RETURNS         : nothing
DESCRIPTION     : reads high and low bytes from PHY register
REQUIRES        : SPI_Ethernet_init must have been called before
EXAMPLE         : SPI_Ethernet_readPHY(3, &h, &l);
*******************************************************************************/
void    SPI_Ethernet_readPHY(unsigned char reg, unsigned char *h, unsigned char *l);


/*******************************************************************************
PROTOTYPE       : void    SPI_Ethernet_delay()
PARAMETERS      : None
RETURNS         : nothing
DESCRIPTION     : 200ms delay; used here for accessing enc PHY level registers
                               while initializing enc module
REQUIRES        : nothing
EXAMPLE         : SPI_Ethernet_delay();
*******************************************************************************/
void    SPI_Ethernet_delay();

/*******************************************************************************
PROTOTYPE       : SPI_Ethernet_Init2(unsigned char fullDuplex)
PARAMETERS      :
    fullDuplex  : full/half duplex switch
RETURNS         : nothing
DESCRIPTION     : this is part of SPI_Ethernet_Init routine. For better linkage
                  due to pic16 flash paging, initialization routine was splited
                  into two smaller routines. This routine handles initialization
                  phases 2-10 as described in enc datasheet.
REQUIRES        : nothing
EXAMPLE         : SPI_Ethernet_delay();
*******************************************************************************/
void    SPI_Ethernet_Init2(unsigned char fullDuplex);

extern  unsigned int    SPI_Ethernet_pktLen;               // size of last packet received (CRC non included)
