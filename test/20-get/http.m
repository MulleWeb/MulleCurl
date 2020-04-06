#import <MulleCurl/MulleCurl.h>

#include <stdio.h>

static NSString   *URL = @"http://www.mulle-kybernetik.com/jagdox/dehtmlify.sh";


int  main( void)
{
   MulleCurl   *curl;
   NSURL           *url;
   NSData          *data;
   NSError         *error;

   curl = [[MulleCurl new] autorelease];
   [curl setDesktopTimeoutOptions];
   data = [curl dataWithContentsOfURLWithString:URL];
   if( ! data)
   {
      error = [NSError mulleExtract];
      fprintf( stderr, "%s\n", [[error description] UTF8String]);
      return( 1);
   }

   printf( "%.*s", (int) [data length], [data bytes]);
   return( 0);
}
