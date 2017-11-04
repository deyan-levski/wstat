/*
 * file         : httpUtils.h
 * project      : HTTP utils
 * author       : Bruno Gavand
 * compiler     : mikroC V6.2
 * date         : july 1rst 2007
 *
 * description  :
                HTTP utils mini-library header
 *
 * target device :
 *              PIC18 family, should work also on PIC16 with reduced possibilities
 *
 * Licence :
 *      Feel free to use this source code at your own risks.
 *
 * history :
 *      created january 2007
 *
 * see more details on http://www.micro-examples.com/
 */

/*
 * maximum length of username:password (arbitrary)
 */
#define LOGINPASSWD_MAXLENGTH   30

/*
 * function prototypes
 */
unsigned char   HTTP_basicRealm(unsigned int l, unsigned char *passwd) ;
unsigned char   HTTP_getRequest(unsigned char *ptr, unsigned int *len, unsigned int max) ;
unsigned int    HTTP_accessDenied(const unsigned char *zn, const unsigned char *m) ;
unsigned int    http_putString(char *s) ;
unsigned int    http_putConstString(const char *s) ;
unsigned int    http_putConstData(const char *s, unsigned int l) ;
unsigned int    HTTP_redirect(unsigned char *url) ;
unsigned int    HTTP_html(const unsigned char *html) ;
unsigned int    HTTP_imageGIF(const unsigned char *img, unsigned int l) ;
unsigned int    HTTP_error() ;
