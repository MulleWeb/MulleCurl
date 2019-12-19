#import <MulleObjCCurlFoundation/MulleObjCCurlFoundation.h>

#include <stdio.h>

static NSString   *URL = @"https://www.mulle-kybernetik.com/jagdox/dehtmlify.sh";


int  main( void)
{
   MulleObjCCurl   *curl;
   NSURL           *url;
   NSData          *data;
   NSError         *error;

   curl = [[MulleObjCCurl new] autorelease];
   [curl setOptions:@{
                       @"CURLOPT_SSL_VERIFYPEER": @(NO),
                       @"CURLOPT_SSL_VERIFYHOST": @(NO)
                     }];
   [curl setDesktopTimeoutOptions];
   url  = [NSURL URLWithString:URL];
   data = [curl dataWithContentsOfURL:url];
   if( ! data)
   {
      error = [NSError mulleCurrentErrorWithDomain:MulleObjCCurlErrorDomain];
      fprintf( stderr, "%s\n", [[error description] UTF8String]);
      return( 1);
   }

   printf( "%.*s", (int) [data length], [data bytes]);
   return( 0);
}
