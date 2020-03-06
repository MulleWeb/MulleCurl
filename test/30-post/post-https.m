#import <MulleCurl/MulleCurl.h>
#import <MulleObjCJSMNFoundation/MulleObjCJSMNFoundation.h>

#include <stdio.h>
#include <stdlib.h>


static NSString   *URL = @"https://httpbin.org/post";

// Expected result:
//
// {
//   "args": {},
//   "data": "",
//   "files": {},
//   "form": {
//     "VfL Bochum 1848": ""
//   },
//   "headers": {
//     "Accept": "*/*",
//     "Content-Length": "15",
//     "Content-Type": "application/x-www-form-urlencoded",
//     "Host": "httpbin.org",
//     "X-Amzn-Trace-Id": "Root=1-5e61102f-9011fce1058cfaf9c8a8eb81"
//   },
//   "json": null,
//   "origin": "94.114.3.142",
//   "url": "https://httpbin.org/post"
// }


@interface MulleJSMNParser( MulleCurlParser) < MulleCurlParser>
@end


@implementation MulleJSMNParser( MulleCurlParser)

- (BOOL) curl:(MulleCurl *) curl
   parseBytes:(void *) bytes
       length:(NSUInteger) length
{
   fprintf( stderr, "~~~ Received: %.*s\n", (int) length, bytes);

   [self parseBytes:bytes
             length:length];

   return( YES);
}

// the parsed result
- (id) parsedObjectWithCurl:(MulleCurl *) curl
{
   return( [self object]);
}


// errorCode will be asked if you change the errorDomain of the parser
- (NSUInteger) errorCodeWithCurl:(MulleCurl *) curl
{
   return( errno);
}

@end




//
// nc -kdl localhost 8181
//
int  main( void)
{
   MulleCurl            *curl;
   NSData               *postData;
   NSError              *error;
   NSDictionary         *dictionary;
   NSMutableDictionary  *censored;

   fprintf( stderr, "Curl up...\n");
   curl = [[MulleCurl new] autorelease];
   [curl setConnectTimeout:8.0];  // 8s
   [curl setDebugOptions];
   [curl setParser:[MulleJSMNParser object]];

   postData = [NSData dataWithBytes:"VfL Bochum 1848"
                             length:15];

   dictionary = [curl parseContentsOfURLWithString:URL
                                     byPostingData:postData];
   fprintf( stderr, "Curl down...\n");

   if( ! dictionary)
   {
      error = [NSError mulleCurrentErrorWithDomain:MulleCurlErrorDomain];
      fprintf( stderr, "%s\n", [[error description] UTF8String]);
      return( 1);
   }

   // get rid off "X-Amzn-Trace-Id"
   // get rif off "origin"
   // could use JSON parser here,
   censored = [NSMutableDictionary dictionaryWithDictionary:dictionary];
   [censored removeObjectForKey:@"origin"];
   [censored removeObjectForKey:@"headers"];

   printf( "%s\n", [censored cStringDescription]);

   return( 0);
}
