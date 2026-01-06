# MulleCurl Library Documentation for AI

## 1. Introduction & Purpose

**MulleCurl** is a high-level Objective-C wrapper around libcurl, providing convenient HTTP/HTTPS client functionality for MulleFoundation applications. It abstracts away low-level curl complexity while exposing powerful options for advanced use cases.

This library is particularly useful for:
- Fetching data from HTTP/HTTPS URLs with minimal boilerplate
- Streaming large responses via parser protocol
- Building REST clients
- Custom HTTP request configuration
- Error handling with NSError integration

## 2. Key Concepts & Design Philosophy

- **Simplified curl API**: Objective-C convenience methods wrapping libcurl's C API
- **Parser Protocol**: Pluggable `MulleCurlParser` for streaming/incremental parsing
- **Options Dictionary**: Set arbitrary libcurl options via `CURLOPT_*` style keys
- **Response Codes**: Validate HTTP responses and extract error details
- **Timeout Flexibility**: Preset timeout profiles (desktop/mobile) or custom settings
- **Header Handling**: Set custom headers and parse response headers independently

## 3. Core API & Data Structures

### 3.1 Main Class: `MulleCurl`

#### Properties
- `@property (assign) void *connection` → `CURL *`
  - Direct access to underlying libcurl handle for advanced use cases
- `@property (assign) NSUInteger validResponseCode`
  - Expected HTTP response code (0 = don't validate, 200 = HTTP OK, default is 0)
  - If set and response doesn't match, convenience methods return nil
- `@property (retain) NSObject<MulleCurlParser> *parser`
  - Parser for response body (processes data incrementally during download)
- `@property (retain) NSObject<MulleCurlParser> *headerParser`
  - Separate parser for HTTP response headers
- `@property (assign) SEL headerValueDescriptionMethod`
  - Custom selector for formatting header values (default: `-description`)
- `@property (retain) id userInfo`
  - Arbitrary user data for parser callbacks

#### Request Configuration

- `- (void) setRequestHeaders:(NSDictionary *)headers`
  - Set HTTP request headers as key-value pairs
  - Key must not contain ':' and must be proper HTTP header key (e.g., "Accept", "User-Agent")
  - Value will be formatted via `headerValueDescriptionMethod`
  - **Example**: `@{ @"Accept": @"application/json", @"Authorization": @"Bearer token123" }`

- `- (void) setOptions:(NSDictionary *)options`
  - Set arbitrary libcurl options using `CURLOPT_*` names as keys
  - Value should be NSString or NSNumber as appropriate for the option
  - See https://curl.haxx.se/libcurl/c/curl_easy_setopt.html for complete option list
  - **Example**: `@{ @"CURLOPT_VERBOSE": @"1", @"CURLOPT_TIMEOUT": @"30" }`

#### Timeout Presets

- `- (void) setDefaultOptions`
  - Reset to curl defaults + MulleCurl standard options
  - Enables `-L` (follow redirects), disables signals, disables verbose
  - Called automatically on init and reset

- `- (void) setDesktopTimeoutOptions`
  - Preset timeouts suitable for desktop applications (longer)
  - Higher connect/transfer timeouts

- `- (void) setMobileTimeoutOptions`
  - Preset timeouts suitable for mobile/flaky networks (shorter, retry-friendly)
  - Lower thresholds for timeout triggers

- `- (void) setConnectTimeout:(NSTimeInterval)interval`
  - Set connection timeout in seconds
  - Timeout if connection not established within this time

- `- (void) setLowSpeedTimeOut:(NSTimeInterval)interval minBitsPerSecond:(NSUInteger)speedLimit`
  - Set timeout if transfer speed drops below threshold
  - **interval**: Duration to monitor speed
  - **speedLimit**: Minimum bits/sec required

#### Special Options

- `- (void) setNoBodyOptions`
  - Configure for HEAD requests (download headers only, no body)

- `- (void) setDebugOptions`
  - Enable progress and verbose output (useful for debugging)

- `- (void) reset`
  - Return to default state as if freshly initialized
  - Clears parser, headerParser, userInfo, and options

#### Response Data Retrieval (Convenience Methods)

- `- (NSData *) dataWithContentsOfURLWithString:(NSString *)url`
  - Simple GET request, returns response body as NSData
  - Returns nil on error; use `[NSError mulleExtract]` or `MulleObjCExtractError()` for error details
  - Resets parser

- `- (NSData *) dataWithContentsOfURLWithString:(NSString *)url byPostingData:(NSData *)data`
  - POST request with data
  - Must set Content-Type header appropriately before calling (e.g., "application/json", "application/x-www-form-urlencoded")
  - Data sent "as-is"; no automatic encoding
  - Returns nil on error

- `- (NSUInteger) lastResponseCode`
  - HTTP response code from last request (e.g., 200, 404, 500)

#### Streaming Response (Parser Protocol)

- `- (id) parseContentsOfURLWithString:(NSString *)url`
  - GET request with pluggable response parser
  - Must set parser before calling
  - Parser receives data incrementally via `parseBytes:length:`
  - Returns `[parser parsedObjectWithCurl:]` (e.g., parsed NSDictionary for JSON)
  - Returns nil if validResponseCode set and doesn't match
  - Resets parser when complete

- `- (id) parseContentsOfURLWithString:(NSString *)url byPostingData:(NSData *)data`
  - POST request with parser
  - Same behavior as GET variant

### 3.2 Parser Protocol: `MulleCurlParser`

Implement this to handle streaming responses:

```objc
@protocol MulleCurlParser

// Called repeatedly with chunks of response data
// Return YES to continue, NO to abort
- (BOOL) curl:(MulleCurl *)curl
   parseBytes:(void *)bytes
       length:(NSUInteger) length;

// Called at end; return parsed result (e.g., NSDictionary, NSArray)
- (id) parsedObjectWithCurl:(MulleCurl *)curl;

@end
```

### 3.3 Class Methods: `MulleCurl( ClassMethods)`

- `+ (void) setDefaultUserAgent:(NSString *)agent`
  - Set global default User-Agent header for all MulleCurl instances
  - Applies to new instances created after this call

- `+ (NSString *) defaultUserAgent`
  - Get current global default User-Agent

### 3.4 Error Information

- `extern NSString *MulleCurlErrorDomain` = `@"MulleCurlError"`
  - Error domain for curl-related errors
  - Use with `[NSError mulleGenericErrorWithDomain:...]` or similar

## 4. Performance Characteristics

- **Simple GET**: O(n) where n = response size; typical: 10-500ms depending on network
- **Streaming Parse**: O(n) total; data processed incrementally, reduces latency vs. buffering entire response
- **Memory**: ~10-50KB base overhead per MulleCurl instance; response buffering depends on parser
- **Concurrent Requests**: Each MulleCurl instance can handle one request at a time; create multiple instances for concurrency
- **Connection Pooling**: Not built-in; reuse single MulleCurl instance for sequential requests to benefit from curl's keep-alive

## 5. AI Usage Recommendations & Patterns

### Pattern 1: Simple HTTP GET
Fetch data from URL with minimal setup:

```objc
MulleCurl *curl = [[MulleCurl new] autorelease];
NSData *data = [curl dataWithContentsOfURLWithString:@"http://api.example.com/data"];
if (!data) {
    NSError *error = [NSError mulleExtract];
    NSLog(@"Error: %@", error);
}
```

### Pattern 2: Validated Response Codes
Ensure response is successful before processing:

```objc
MulleCurl *curl = [[MulleCurl new] autorelease];
curl.validResponseCode = 200; // Only accept 200 OK
NSData *data = [curl dataWithContentsOfURLWithString:@"http://api.example.com/data"];
if (!data) {
    // Response was not 200; already failed gracefully
    NSLog(@"Request failed or non-200 response");
}
```

### Pattern 3: POST Request with Custom Headers
Send data with authentication:

```objc
MulleCurl *curl = [[MulleCurl new] autorelease];

// Set headers
[curl setRequestHeaders:@{
    @"Content-Type": @"application/json",
    @"Authorization": @"Bearer mytoken123"
}];

// Set timeout
[curl setDesktopTimeoutOptions];

// POST data
NSData *jsonPayload = [NSJSONSerialization dataWithJSONObject:@{@"key": @"value"} options:0 error:nil];
NSData *response = [curl dataWithContentsOfURLWithString:@"http://api.example.com/submit" byPostingData:jsonPayload];
```

### Pattern 4: Streaming JSON Parser
Parse large JSON responses without buffering entire response:

```objc
@interface JSONParser : NSMutableData <MulleCurlParser>
@end

@implementation JSONParser
- (BOOL) curl:(MulleCurl *)curl parseBytes:(void *)bytes length:(NSUInteger)length {
    [self appendBytes:bytes length:length];
    return YES; // Continue
}

- (id) parsedObjectWithCurl:(MulleCurl *)curl {
    return [NSJSONSerialization JSONObjectWithData:self options:0 error:nil];
}
@end

// Usage:
MulleCurl *curl = [[MulleCurl new] autorelease];
curl.parser = [[[JSONParser new] autorelease];
NSDictionary *result = [curl parseContentsOfURLWithString:@"http://api.example.com/large.json"];
```

### Pattern 5: Response Header Parsing
Extract headers from response separately from body:

```objc
// Assuming MulleHTTPHeaderParser exists (from MulleObjCHTTPFoundation)
MulleCurl *curl = [[MulleCurl new] autorelease];

// Create header parser (wraps NSMutableData + parsing logic)
MulleHTTPHeaderParser *headerParser = [[MulleHTTPHeaderParser new] autorelease];
curl.headerParser = headerParser;

// Fetch data
NSData *data = [curl dataWithContentsOfURLWithString:@"http://example.com"];

// Extract headers
NSDictionary *headers = [headerParser headers];
NSLog(@"Content-Type: %@", headers[@"Content-Type"]);
NSLog(@"Last-Modified: %@", headers[@"Last-Modified"]);
```

### Pattern 6: Custom libcurl Options
Access advanced curl functionality via options:

```objc
MulleCurl *curl = [[MulleCurl new] autorelease];

[curl setOptions:@{
    @"CURLOPT_VERBOSE": @"1",       // Enable verbose output
    @"CURLOPT_TIMEOUT": @"60",      // 60 second timeout
    @"CURLOPT_MAXREDIRS": @"5",     // Follow max 5 redirects
    @"CURLOPT_SSL_VERIFYPEER": @"0" // Disable SSL verification (dangerous!)
}];

NSData *data = [curl dataWithContentsOfURLWithString:@"https://api.example.com"];
```

### Common Pitfalls
- **Not checking for nil return**: Always validate returned data
- **Forgetting Content-Type on POST**: Set header before posting
- **Parser memory growth**: Don't accumulate unbounded data in parser
- **Reusing MulleCurl for concurrent requests**: Create separate instances for parallel requests
- **Ignoring response codes**: Use `validResponseCode` to automatically validate

## 6. Integration Examples

### Example 1: Simple URL Fetch
```objc
#import <MulleCurl/MulleCurl.h>

int main() {
    @autoreleasepool {
        MulleCurl *curl = [[MulleCurl new] autorelease];
        [curl setDesktopTimeoutOptions];
        
        NSData *data = [curl dataWithContentsOfURLWithString:@"http://www.example.com"];
        if (data) {
            printf("Fetched %lu bytes\n", [data length]);
            printf("%.*s\n", (int)[data length], (char *)[data bytes]);
        } else {
            fprintf(stderr, "Failed to fetch URL\n");
        }
    }
    return 0;
}
```

### Example 2: REST API Client
```objc
@interface RESTClient : NSObject
- (NSDictionary *) fetchJSONFromURL:(NSString *)url;
- (BOOL) postJSON:(NSDictionary *)json toURL:(NSString *)url;
@end

@implementation RESTClient
- (NSDictionary *) fetchJSONFromURL:(NSString *)url {
    MulleCurl *curl = [[MulleCurl new] autorelease];
    curl.validResponseCode = 200;
    [curl setDesktopTimeoutOptions];
    [curl setRequestHeaders:@{@"Accept": @"application/json"}];
    
    MulleJSMNParser *parser = [[MulleJSMNParser new] autorelease];
    curl.parser = parser;
    
    id result = [curl parseContentsOfURLWithString:url];
    return [result isKindOfClass:[NSDictionary class]] ? result : nil;
}

- (BOOL) postJSON:(NSDictionary *)json toURL:(NSString *)url {
    MulleCurl *curl = [[MulleCurl new] autorelease];
    curl.validResponseCode = 201;
    [curl setDesktopTimeoutOptions];
    [curl setRequestHeaders:@{@"Content-Type": @"application/json"}];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
    NSData *response = [curl dataWithContentsOfURLWithString:url byPostingData:jsonData];
    
    return response != nil;
}
@end
```

### Example 3: Retry Logic with Exponential Backoff
```objc
- (NSData *) fetchWithRetries:(NSString *)urlString maxRetries:(NSUInteger)maxRetries {
    NSUInteger retryDelay = 1; // seconds
    
    for (NSUInteger attempt = 0; attempt < maxRetries; attempt++) {
        MulleCurl *curl = [[MulleCurl new] autorelease];
        [curl setDesktopTimeoutOptions];
        [curl setConnectTimeout:10];
        
        NSData *data = [curl dataWithContentsOfURLWithString:urlString];
        if (data) return data;
        
        // Exponential backoff
        if (attempt < maxRetries - 1) {
            sleep(retryDelay);
            retryDelay *= 2;
        }
    }
    
    return nil;
}
```

### Example 4: Streaming Large File Download
```objc
@interface FileDownloadParser : NSMutableData <MulleCurlParser>
@property (retain) NSFileHandle *fileHandle;
@end

@implementation FileDownloadParser
- (BOOL) curl:(MulleCurl *)curl parseBytes:(void *)bytes length:(NSUInteger)length {
    // Write to disk immediately instead of buffering
    [self.fileHandle writeData:[NSData dataWithBytesNoCopy:bytes length:length freeWhenDone:NO]];
    return YES;
}

- (id) parsedObjectWithCurl:(MulleCurl *)curl {
    [self.fileHandle closeFile];
    return self.fileHandle; // Return handle as result
}
@end

// Usage:
FileDownloadParser *parser = [[FileDownloadParser new] autorelease];
parser.fileHandle = [NSFileHandle fileHandleForWritingAtPath:@"/tmp/largefile.bin"];

MulleCurl *curl = [[MulleCurl new] autorelease];
curl.parser = parser;
[curl parseContentsOfURLWithString:@"http://example.com/largefile.iso"];
```

### Example 5: HEAD Request to Check URL
```objc
- (BOOL) urlExists:(NSString *)url {
    MulleCurl *curl = [[MulleCurl new] autorelease];
    [curl setNoBodyOptions];
    [curl setConnectTimeout:5];
    
    NSData *data = [curl dataWithContentsOfURLWithString:url];
    NSUInteger code = [curl lastResponseCode];
    
    return code == 200 && data != nil;
}
```

### Example 6: HTTPS with Custom Certificate Validation
```objc
MulleCurl *curl = [[MulleCurl new] autorelease];

[curl setOptions:@{
    @"CURLOPT_SSL_VERIFYPEER": @"1",
    @"CURLOPT_SSL_VERIFYHOST": @"2",
    @"CURLOPT_CAINFO": @"/path/to/custom/ca-bundle.crt"
}];

NSData *data = [curl dataWithContentsOfURLWithString:@"https://api.example.com/secure"];
```

## 7. Dependencies

- **MulleFoundation** - NSString, NSData, NSDictionary, NSError, NSFileHandle
- **libcurl** - Embedded HTTP client library (C)
- **mulle-objc** (runtime) - Objective-C runtime support
- **Standard C library**

## 8. Version Information

MulleCurl version macro: `MULLE_CURL_VERSION`
- Format: `(major << 20) | (minor << 8) | patch`
- Current: 0.18.4
- Reflects both MulleCurl wrapper and bundled libcurl versions
- No unbounded allocations in normal operation
- Follows mulle-objc conventions for efficiency

## 5. AI Usage Recommendations & Patterns

### Best Practices

- Use factory methods for object creation
- Follow mulle-objc reference counting (retain/release/autorelease)
- Prefer immutable variants when available
- Check return values for error conditions

### Common Pitfalls

- Don't bypass public APIs; use documented interfaces
- Remember to release retained objects
- Validate input parameters when appropriate
- Check for nil returns from factory methods

### Integration Pattern

```objc
// Typical usage pattern
id obj = [[ClassName alloc] initWithParameter:value];
// Use obj...
[obj release];
```

## 6. Integration Examples

See test directory for practical compilable examples:
- `test/` directory contains usage demonstrations
- Examples show initialization, usage, and cleanup patterns
- Test assertions illustrate expected behavior

## 7. Dependencies

- MulleObjC (core runtime)
- MulleFoundationBase
- MulleObjCStandardFoundation and related components
- See project .mulle/etc/sourcetree/config for exact dependencies
