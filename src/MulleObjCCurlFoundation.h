#ifndef mulle_objc_curl_foundation_h__
#define mulle_objc_curl_foundation_h__

#import "import.h"

#include <stdint.h>

/*
 *  (c) 2019 nat ORGANIZATION
 *
 *  version:  major, minor, patch
 */
#define MULLE_OBJC_CURL_FOUNDATION_VERSION  ((0 << 20) | (7 << 8) | 56)


static inline unsigned int   MulleObjCCurlFoundation_get_version_major( void)
{
   return( MULLE_OBJC_CURL_FOUNDATION_VERSION >> 20);
}


static inline unsigned int   MulleObjCCurlFoundation_get_version_minor( void)
{
   return( (MULLE_OBJC_CURL_FOUNDATION_VERSION >> 8) & 0xFFF);
}


static inline unsigned int   MulleObjCCurlFoundation_get_version_patch( void)
{
   return( MULLE_OBJC_CURL_FOUNDATION_VERSION & 0xFF);
}


extern uint32_t   MulleObjCCurlFoundation_get_version( void);


#import "MulleObjCCurl.h"
#import "MulleObjCHTTPHeaderParser.h"

#endif
