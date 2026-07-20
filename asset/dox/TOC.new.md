# MulleCurl Library Documentation for AI
<!-- Keywords: http, curl, objc, parser, network, data -->

## 1. Introduction & Purpose

- MulleCurl is a small Objective‑C HTTP client that wraps libcurl (easy interface) to fetch or post NSData and optionally parse content incrementally.
- Solves: simple, script‑like HTTP GET/POST from mulle-objc projects without NSURL; provides parser hooks to stream-parse results.
- Key features: synchronous convenience methods, parser protocol for incremental parsing, header handling, curl option mapping, simple NSError integration.
- Relationship: Built for mulle-objc; depends on libcurl, OpenSSL (platform), and MulleFoundationBase.

## 2. Key Concepts & Design Philosophy

- Thin wrapper around libcurl easy API: expose curl options via NSDictionary using CURLOPT_* names.
- Streaming/incremental parsing: parser objects receive parseBytes:length: callbacks; allows lower-latency parsing for large payloads.
- Minimal coupling: avoids NSURL; keeps API simple and Objective‑C idiomatic for mulle-objc projects.
- Explicit lifecycle: create MulleCurl objects, set parser(s)/options, perform request, inspect result or error, then reset/destroy.

## 3. Core API & Data Structures

### 3.1. [MulleCurl.h]

struct / class: MulleCurl (NSObject)
- Purpose: Primary object to perform HTTP(S) requests and manage curl connection + parser state.
- Key ivars/props:
   - void *connection;           // underlying CURL * (assign)
   - NSUInteger validResponseCode; // 0 = ignore, otherwise require response code (default 0)
   - NSObject<MulleCurlParser> *parser;       // content parser (retain)
   - NSObject<MulleCurlParser> *headerParser; // header parser (retain)
   - SEL headerValueDescriptionMethod;       // selector used to describe header values
   - id userInfo;                             // arbitrary pointer for parser use
- Lifecycle:
   - Create: [[MulleCurl new] autorelease] (or alloc/init if desired)
   - Reset/cleanup: -reset clears parser(s), userInfo and resets curl options; dealloc as usual for objc objects.
- Core operations:
   - - (void) setRequestHeaders:(NSDictionary *)headers;
     Overwrite request headers. Keys must be HTTP header names (no ':'), values described via headerValueDescriptionMethod.
   - - (void) setOptions:(NSDictionary *)options;
     Map NSString keys like @"CURLOPT_VERBOSE" to NSNumber/NSString values and call curl_easy_setopt.
   - - (void) setNoBodyOptions;
   - - (void) setDesktopTimeoutOptions; - (void) setMobileTimeoutOptions;
   - - (void) setConnectTimeout:(NSTimeInterval)interval; - (void) setLowSpeedTimeOut:(NSTimeInterval)interval minBitsPerSecond:(NSUInteger)speedLimit;
   - - (void) setDefaultOptions; // default safe options
   - - (void) setDebugOptions;   // re-enable verbose/progress
   - - (void) reset;             // reset to default + remove parsers/userInfo
- Convenience request methods (synchronous):
   - - (NSData *) dataWithContentsOfURLWithString:(NSString *)url;
   - - (NSData *) dataWithContentsOfURLWithString:(NSString *)url byPostingData:(NSData *)data;
- Parser-based methods (incremental parse):
   - - (id) parseContentsOfURLWithString:(NSString *)url;
   - - (id) parseContentsOfURLWithString:(NSString *)url byPostingData:(NSData *)data;
- Inspection:
   - - (NSUInteger) lastResponseCode;
- Class methods:
   - + (void) setDefaultUserAgent:(NSString *)agent;
   - + (NSString *) defaultUserAgent;
- Errors & Version:
   - extern NSString *MulleCurlErrorDomain; and version macros: MULLE_CURL_VERSION and helpers MulleCurl_get_version_*.

### 3.2. [MulleCurlParser.h]

@protocol MulleCurlParser
- - (BOOL) curl:(MulleCurl *) curl parseBytes:(void *) bytes length:(NSUInteger) length;
  Called repeatedly with chunks of body bytes. Return YES on success/continue, NO on fatal parse error.
- - (id) parsedObjectWithCurl:(MulleCurl *) curl;
  Called to retrieve the final parsed object (e.g., NSDictionary from JSON parser).

### 3.3. [NSMutableData+MulleCurlParser.h]

- Convenience adapter: NSMutableData implements MulleCurlParser by appending bytes; parsedObjectWithCurl: returns the NSData/NSMutableData instance.
- Useful as simple headerParser or body parser when raw data accumulation is desired.

## 4. Performance Characteristics

- Network-bound: latency and throughput dominated by libcurl and network. CPU parsing cost proportional to payload size (O(n)).
- Incremental parsing reduces peak memory and can reduce latency for large payloads.
- Overhead: Objective‑C message dispatch around curl callbacks is small compared to IO cost.
- Complexity:
   - Setting/getting properties & options: O(1).
   - Parsing/reading response: O(n) where n = response size.
- Threading: Not thread-safe. Instances are not thread-local; external locking required for shared use. Curl global init handled by build/runtime; instantiating MulleCurl per thread is recommended.

## 5. AI Usage Recommendations & Patterns

- Best practices:
   - Always use provided lifecycle functions: create MulleCurl, setDefaultOptions, set parser/headerParser as needed, perform request, then reset.
   - Use setOptions: to pass libcurl options via NSString keys matching CURLOPT names.
   - For JSON or streamable formats, set parser to an incremental parser (conforms to MulleCurlParser) before calling parseContentsOfURLWithString: to reduce latency.
   - Inspect lastResponseCode and use validResponseCode to enforce expected HTTP codes.
   - Retrieve NSError via MulleObjCExtractError() if data-returning methods return nil.
- Common pitfalls:
   - Do not assume thread-safety; do not share one MulleCurl across threads without locking.
   - Header keys must not contain ':' characters.
   - setOptions expects meaningful types for each CURLOPT (NSNumber for numeric options, NSString for string options).

## 6. Integration Examples

### Example 1: Creating and Fetching Data

```objc
#import <MulleCurl/MulleCurl.h>
#include <stdio.h>

static NSString *URL = @"https://example.com/data.txt";

int
main( void)
{
   MulleCurl  *curl;
   NSData     *data;
   NSError    *error;

   curl = [[MulleCurl new] autorelease];
   [curl setOptions:@{ @"CURLOPT_SSL_VERIFYPEER": @(NO),
                       @"CURLOPT_SSL_VERIFYHOST": @(NO) }];
   data = [curl dataWithContentsOfURLWithString:URL];
   if( ! data)
   {
      error = [NSError mulleExtractError];
      fprintf( stderr, "%s\n", [[error description] UTF8String]);
      return( 1);
   }

   printf( "%.*s", (int) [data length], [data bytes]);
   return( 0);
}
```

### Example 2: Using Incremental Parser (NSMutableData adapter)

```objc
#import <MulleCurl/MulleCurl.h>

MulleCurl  *curl;
NSMutableData  *accum;

curl = [[MulleCurl new] autorelease];
accum = [[NSMutableData new] autorelease];

[ curl setParser:accum ];           // accum implements MulleCurlParser
id result = [ curl parseContentsOfURLWithString:@"https://example.com/large.json" ];
// result is the NSMutableData instance containing the raw bytes
```

## 7. Dependencies

- libcurl (curl) — used via easy interface
- OpenSSL (for HTTPS on many Linux distros)
- MulleFoundationBase (mulle-objc foundation amalgam)
- MulleZlib (optional for compression support)


---

Notes for the AI: prioritize header files and the test/ examples when answering API questions. Use parser protocol and NSMutableData adapter as canonical examples for incremental parsing.
