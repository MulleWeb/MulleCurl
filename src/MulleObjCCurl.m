//
//  MulleObjCCurl.m
//  MulleObjCCurlFoundation
//
//  Copyright (C) 2019 Nat!, Mulle kybernetiK.
//  Copyright (c) 2019 Codeon GmbH.
//  All rights reserved.
//
//  Coded by Nat!
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
#import "MulleObjCCurl.h"

#import "import-private.h"

#import "MulleObjCCurl+Private.h"


@interface MulleObjCCurl( Private)

+ (NSMapTable *) optionLookupTable;

@end


NSString   *MulleObjCCurlErrorDomain = @"MulleObjCCurlError";


@implementation MulleObjCCurl

//
// limited by internal memory, which is what we want in the simple
// interface
//
static size_t  receive_bytes( void *contents, size_t sz, size_t nmemb, void *ctx)
{
   NSMutableData        **p_data = ctx;
   unsigned long long   size;

   size = sz * nmemb;
   if( (NSUInteger) size != size)
      [NSException raise:NSInternalInconsistencyException
                  format:@"Size %ld*%ld is excessive", sz, nmemb];

   if( ! *p_data)
      *p_data = [[NSMutableData alloc] initWithCapacity:(NSUInteger) size];
   [*p_data appendBytes:contents
                 length:size];

   fprintf( stderr, "received: %.*s\n", (int) size, contents);
   return( (size_t) size);
}


- (void) setDebugOptions
{
   // only display curl output in debug mode
   curl_easy_setopt( _connection, CURLOPT_VERBOSE, YES);
   curl_easy_setopt( _connection, CURLOPT_NOPROGRESS, NO);
}


- (void) setDefaultOptions
{
   // only display curl output in debug mode
   curl_easy_setopt( _connection, CURLOPT_VERBOSE, NO);
   curl_easy_setopt( _connection, CURLOPT_NOPROGRESS, YES);

   // settings for programmatic I/O
   curl_easy_setopt( _connection, CURLOPT_NOSIGNAL, YES);
   curl_easy_setopt( _connection, CURLOPT_WILDCARDMATCH, NO);
   curl_easy_setopt( _connection, CURLOPT_VERBOSE, NO);
   curl_easy_setopt( _connection, CURLOPT_FOLLOWLOCATION, YES);

   curl_easy_setopt( _connection, CURLOPT_WRITEFUNCTION, receive_bytes);
   curl_easy_setopt( _connection, CURLOPT_WRITEDATA, &_data);
   curl_easy_setopt( _connection, CURLOPT_PRIVATE, self);
}

- (void) setDesktopTimeoutOptions
{
   // some default timeout settings
   // could tweak this for mobile or so
   curl_easy_setopt( _connection, CURLOPT_CONNECTTIMEOUT_MS, 500);     // rather retry  (IMO)
   curl_easy_setopt( _connection, CURLOPT_LOW_SPEED_TIME, 60L);        // 30s @
   curl_easy_setopt( _connection, CURLOPT_LOW_SPEED_LIMIT, 32000/8); // 32 kbps min
}


- (void) setMobileTimeoutOptions
{
   // some default timeout settings
   // could tweak this for mobile or so
   curl_easy_setopt( _connection, CURLOPT_CONNECTTIMEOUT_MS, 5000);  //
   curl_easy_setopt( _connection, CURLOPT_LOW_SPEED_TIME, 120L);     // 30s @
   curl_easy_setopt( _connection, CURLOPT_LOW_SPEED_LIMIT, 2400/8); // 2400 bps min
}


- (id) init
{
   CURLcode   status;

   _connection = curl_easy_init();
   if( ! _connection)
   {
      [self release];
      return( self);
   }

   [self setDefaultOptions];

   return( self);
}


- (void) dealloc
{
   [_data release];
   [super dealloc];
}


- (void) setOptions:(NSDictionary *) options
{
   NSString      *key;
   intptr_t      option;
   id            value;
   NSMapTable    *optionLookupTable;
   int           type;

   optionLookupTable = [MulleObjCCurl optionLookupTable];

   for( key in options)
   {
      value  = [options :key];
      option = (intptr_t) NSMapGet( optionLookupTable, key);
      if( ! option)
         [NSException raise:NSInvalidArgumentException
                     format:@"unknown curl option %@", key];
      type     = option & 0xF;
      option >>= 4;
      switch( type)
      {
      case LONG  :
         curl_easy_setopt( _connection, option, [value longValue]);
         break;

      case OFF_T  :
         curl_easy_setopt( _connection, option, (curl_off_t) [value longLongValue]);
         break;

      case STRINGPOINT  :
         curl_easy_setopt( _connection, option, [value UTF8String]);
         break;

      default :
         [NSException raise:NSInvalidArgumentException
                     format:@"curl option type for %@ is unsupported", key];
      }
   }
}


- (NSData *) dataWithContentsOfURLString:(NSString *) url
{
   CURLcode   res;
   NSData     *data;

   NSParameterAssert( [url isKindOfClass:[NSString class]]);

   assert( !_data);
   if( ! [url length])
    [NSException raise:NSInvalidArgumentException
                format:@"empty URL"];

   curl_easy_setopt( _connection, CURLOPT_URL, [url UTF8String]);
   curl_easy_setopt( _connection, CURLOPT_POST, 0);

   res = curl_easy_perform( _connection);

   data  = [_data autorelease];
   _data = nil;

   if( res != CURLE_OK)
   {
      errno = res;
      return( NULL);
   }

   return( data ? data : [NSData data]);
}


- (NSData *) dataWithContentsOfURLString:(NSString *) url
                           byPostingData:(NSData *) data
{
   CURLcode   res;
   NSData     *data;

   NSParameterAssert( [url isKindOfClass:[NSString class]]);
   NSParameterAssert( [data isKindOfClass:[NSData class]]);

   assert( !_data);
   if( ! [url length])
    [NSException raise:NSInvalidArgumentException
                format:@"empty URL"];

   curl_easy_setopt( _connection, CURLOPT_URL, [url UTF8String]);
   curl_easy_setopt( _connection, CURLOPT_POSTFIELDS, [data bytes]);
   curl_easy_setopt( _connection, CURLOPT_POSTFIELDSIZE_LARGE, (curl_off_t) [data length]);

   res = curl_easy_perform( _connection);
   data  = [_data autorelease];
   _data = nil;

   if( res != CURLE_OK)
   {
      errno = res;
      return( NULL);
   }

   return( data ? data : [NSData data]);
}


- (void) reset
{

   [_data autorelease];
   _data = nil;

   // this wipes all the options!
   curl_easy_reset( _connection);
   // this gets out defaults back
   [self setDefaultOptions];
}


- (void) finalize
{
   if( _connection)
   {
      curl_easy_cleanup( _connection);
      _connection = NULL;
   }
   [super finalize];
}



static struct
{
   mulle_atomic_pointer_t  _optionLookupTable;
} Self;


+ (NSMapTable *) optionLookupTable
{
   NSMapTable   *table;

   for(;;)
   {
      table = _mulle_atomic_pointer_read( &Self._optionLookupTable);
      if( table)
         return( table);

      table = MulleObjCCurlOptionLookupTable();
      if( _mulle_atomic_pointer_cas( &Self._optionLookupTable, table, NULL))
         return( table);
      NSFreeMapTable( table);
   }

   return( Self._optionLookupTable);
}


static NSString *  translate_curl_errno( NSInteger code)
{
   char  *s;

   s = (char *) curl_easy_strerror( code);
   if( ! s)
      return( nil);
   return( [NSString stringWithUTF8String:s]);
}


+ (void) initialize
{
   curl_global_init( CURL_GLOBAL_DEFAULT);
   // crazy clang cast
   [NSError registerErrorDomain:MulleObjCCurlErrorDomain
            errorStringFunction:(NSString *(*)(NSInteger)) translate_curl_errno];
}


+ (void) unload
{
   curl_global_cleanup();

   if( Self._optionLookupTable)
      NSFreeMapTable( Self._optionLookupTable);
   //Self._optionLookupTable = NULL;
}

@end


@implementation MulleObjCCurl( NSURL)

- (NSData *) dataWithContentsOfURL:(NSURL *) url
{
   return( [self dataWithContentsOfURLString:[url absoluteString]]);
}


- (NSData *) dataWithContentsOfURL:(NSURL *) url
                     byPostingData:(NSData *) data;
{
   return( [self dataWithContentsOfURLString:[url absoluteString]
                               byPostingData:data]);
}

@end

