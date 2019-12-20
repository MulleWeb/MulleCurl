#import <MulleObjCCurlFoundation/MulleObjCCurlFoundation.h>

#include <stdio.h>

static NSString   *URL = @"http://www.mulle-kybernetik.com/jagdox/dehtmlify.sh";


int  main( void)
{
   MulleObjCCurl               *curl;
   MulleObjCHTTPHeaderParser   *headerParser;
   NSURL                       *url;
   NSData                      *data;
   NSError                     *error;
   NSArray                     *order;
   NSDictionary                *headers;

   curl         = [[MulleObjCCurl new] autorelease];
   headerParser = [[MulleObjCHTTPHeaderParser new] autorelease];
   [headerParser setRecordsOrder:YES];

   [curl setDesktopTimeoutOptions];
   [curl setHeaderParser:headerParser];
//   [curl setNoBodyOptions];

   data = [curl dataWithContentsOfURLString:URL];
   if( ! data)
   {
      error = [NSError mulleCurrentErrorWithDomain:MulleObjCCurlErrorDomain];
      fprintf( stderr, "%s\n", [[error description] UTF8String]);
      return( 1);
   }

   order   = [headerParser order];
   headers = [headerParser headers];

   printf( "%s\n", [[headerParser response] UTF8String]);
   printf( "%s\n", [[order description] UTF8String]);
   printf( "%ld headers\n", (long) [headers count]);
   printf( "%ld bytes in body\ns", [data length]);

   return( 0);
}
