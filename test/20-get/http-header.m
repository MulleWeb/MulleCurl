#import <MulleCurl/MulleCurl.h>
#import <MulleObjCHTTPFoundation/MulleObjCHTTPFoundation.h>

#include <stdio.h>

static NSString   *URL = @"http://www.mulle-kybernetik.com/jagdox/dehtmlify.sh";

@interface MulleHTTPHeaderParser( MulleCurlParser) <MulleCurlParser>
@end


@implementation MulleHTTPHeaderParser( MulleCurlParser)

//
// we don't bail if we can 't parse a header, but the header will be "nil"
//
- (BOOL) curl:(MulleCurl *) curl
   parseBytes:(void *) bytes
       length:(NSUInteger) length
{
   [_data appendBytes:bytes
               length:length];
   [self parse];

   return( YES);
}


- (id) parsedObjectWithCurl:(MulleCurl *) curl
{
   return( _headers);
}

@end



int  main( void)
{
   MulleCurl               *curl;
   MulleHTTPHeaderParser   *headerParser;
   NSURL                   *url;
   NSData                  *data;
   NSError                 *error;
   NSArray                 *order;
   NSDictionary            *headers;

   curl         = [MulleCurl object];
   headerParser = [MulleHTTPHeaderParser object];
   [headerParser setRecordsOrder:YES];

   [curl setDesktopTimeoutOptions];
   [curl setHeaderParser:headerParser];
//   [curl setNoBodyOptions];

   data = [curl dataWithContentsOfURLWithString:URL];
   if( ! data)
   {
      error = [NSError mulleGenericErrorWithDomain:MulleCurlErrorDomain
                              localizedDescription:@"???"];
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
