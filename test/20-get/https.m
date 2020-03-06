#import <MulleCurl/MulleCurl.h>

#include <stdio.h>

static NSString   *URL = @"https://www.mulle-kybernetik.com/jagdox/dehtmlify.sh";


int  main( void)
{
   MulleCurl   *curl;
   NSData          *data;
   NSError         *error;

   curl = [MulleCurl object];

   // for testing turn off https certi checks, which are not ez
   // crossplatform wise
   [curl setOptions:@{
                       @"CURLOPT_SSL_VERIFYPEER": @(NO),
                       @"CURLOPT_SSL_VERIFYHOST": @(NO)
                     }];
   [curl setDesktopTimeoutOptions];
   data = [curl dataWithContentsOfURLWithString:URL];
   if( ! data)
   {
      error = [NSError mulleCurrentErrorWithDomain:MulleCurlErrorDomain];
      fprintf( stderr, "%s\n", [[error description] UTF8String]);
      return( 1);
   }

   printf( "%.*s", (int) [data length], [data bytes]);
   return( 0);
}
