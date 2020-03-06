#import <MulleCurl/MulleCurl.h>

#include <stdio.h>

static NSString   *URL = @"http://www.mulle-kybernetik.com/jagdox/dehtmlify.sh";


int  main( void)
{
   MulleCurl               *curl;
   MulleHTTPHeaderParser   *headerParser;
   NSURL                       *url;
   NSData                      *data;
   NSError                     *error;
   NSArray                     *order;
   NSDictionary                *headers;

   curl         = [[MulleCurl new] autorelease];
   headerParser = [[MulleHTTPHeaderParser new] autorelease];
   [headerParser setRecordsOrder:YES];

   [curl setDesktopTimeoutOptions];
   [curl setHeaderParser:headerParser];
//   [curl setNoBodyOptions];

   data = [curl dataWithContentsOfURLWithString:URL];
   if( ! data)
   {
      error = [NSError mulleCurrentErrorWithDomain:MulleCurlErrorDomain];
      fprintf( stderr, "%s\n", [[error description] UTF8String]);
      return( 1);
   }

   order   = [headerParser order];
   headers = [headerParser headers];

   printf( "%s\n", [[headerParser response] UTF8String]);
   printf( "%s\n", [[order description] UTF8String]);
   printf( "%ld headers\n", (long) [headers count]);
   printf( "%ld bytes in body\n", [data length]);

   return( 0);
}
