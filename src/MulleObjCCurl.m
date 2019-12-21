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

   _headerValueDescriptionMethod = @selector( description);

   return( self);
}


- (void) finalize
{
   [super finalize];

   if( _chunk)
   {
      curl_slist_free_all( _chunk);
      _chunk = NULL;
   }

   if( _connection)
   {
      curl_easy_cleanup( _connection);
      _connection = NULL;
   }
}


- (void) reset
{
   _headerValueDescriptionMethod = @selector( description);

   [self setParser:nil];
   [self setHeaderParser:nil];
   [self setUserInfo:nil];
   [self setErrorDomain:nil];
   [self setErrorCode:0];

   if( _chunk)
   {
      curl_slist_free_all( _chunk);
      _chunk = NULL;
   }

   // this wipes all the options!
   curl_easy_reset( _connection);
   // this gets out defaults back
   [self setDefaultOptions];
}


/*
 * Headers like "Accept:"
 */

// these overwrite previous headers
- (void) setRequestHeaders:(NSDictionary *) headers
{
   struct mulle_buffer   buffer;
   auto char             space[ 256];
   size_t                size;
   size_t                length;
   NSString              *key;
   id                    value;

   if( _chunk)
      curl_slist_free_all( _chunk);
   _chunk = NULL;

   mulle_buffer_init_with_static_bytes( &buffer, space, sizeof( space), NULL);
   {
      for( key in headers)
      {
         NSParameterAssert( ! [key hasSuffix:@":"]);

         value = [headers :key];
         // transform value to string (should format NSDate) properly
         // for the intended recipient
         value = [value performSelector:_headerValueDescriptionMethod];

         mulle_buffer_remove_all( &buffer);
         mulle_sprintf( &buffer,
                        "%s: %s",
                        [key UTF8String],
                        [value UTF8String]);
         mulle_buffer_add_byte( &buffer, 0);

         _chunk = curl_slist_append( _chunk, mulle_buffer_get_bytes( &buffer));
      }
   }
   mulle_buffer_done( &buffer);

   curl_easy_setopt( _connection, CURLOPT_HTTPHEADER, _chunk);
}


/*
 * Options and internal mechanix
 */
static size_t  receive_curl_bytes( MulleObjCCurl *self,
                                   void *contents,
                                   size_t sz,
                                   size_t nmemb,
                                   id <MulleObjCCurlParser>  parser)
{
   unsigned long long   size;

   size = (unsigned long long ) sz * nmemb;
   if( (NSUInteger) size != size)
      [NSException raise:NSInternalInconsistencyException
                  format:@"Size %ld*%ld is excessive", sz, nmemb];

   if( ! [parser curl:self
           parseBytes:contents
               length:(NSUInteger) size])
   {
      return( 0);  // indicate an error, assume CURL aborts ?
   }
   return( (size_t) size);
}


static size_t   receive_curl_header_bytes( char *buffer,
                                           size_t size,
                                           size_t nitems,
                                           void *ctx)
{
   MulleObjCCurl   *self = ctx;

   return( receive_curl_bytes( self, buffer, size, nitems, [self headerParser]));
}


static size_t   receive_curl_body_bytes( void *contents,
                                         size_t sz,
                                         size_t nmemb,
                                         void *ctx)
{
   MulleObjCCurl   *self = ctx;

   return( receive_curl_bytes( self, contents, sz, nmemb, [self parser]));
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
   curl_easy_setopt( _connection, CURLOPT_FOLLOWLOCATION, YES);

   curl_easy_setopt( _connection, CURLOPT_WRITEFUNCTION, receive_curl_body_bytes);
   curl_easy_setopt( _connection, CURLOPT_WRITEDATA, self);
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

- (void) setNoBodyOptions
{
   curl_easy_setopt( _connection, CURLOPT_NOBODY, 1);  // useful for header only
}


- (void) setOptions:(NSDictionary *) options
{
   CURLcode     rval;
   id           value;
   int          type;
   intptr_t     option;
   NSMapTable   *optionLookupTable;
   NSString     *key;

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
         rval = curl_easy_setopt( _connection, option, [value longValue]);
         break;

      case OFF_T  :
         rval = curl_easy_setopt( _connection, option, (curl_off_t) [value longLongValue]);
         break;

      case STRINGPOINT  :
         rval = curl_easy_setopt( _connection, option, [value UTF8String]);
         break;

      default :
         [NSException raise:NSInvalidArgumentException
                     format:@"curl option type for %@ is unsupported", key];
      }

      if( rval)
         [NSException raise:NSInvalidArgumentException
                     format:@"curl option %@ could not be set: \"%s\"",
                              curl_easy_strerror( rval)];
   }
}


- (NSString *) errorDomain
{
   return( _errorDomain ? _errorDomain : MulleObjCCurlErrorDomain);
}


- (void) setErrorDomain:(NSString *) s
{
   [_errorDomain autorelease];
   _errorDomain = [s isEqualToString:MulleObjCCurlErrorDomain] ? nil : [s copy];
}


- (void) setHeaderParser:(NSObject <MulleObjCCurlParser> *) parser
{
   if( _headerParser && ! parser)
   {
      curl_easy_setopt( _connection, CURLOPT_HEADERFUNCTION, NULL);
      curl_easy_setopt( _connection, CURLOPT_HEADERDATA, NULL);
   }

   [_headerParser autorelease];
   _headerParser = [parser retain];

   if( parser)
   {
      curl_easy_setopt( _connection, CURLOPT_HEADERFUNCTION, receive_curl_header_bytes);
      curl_easy_setopt( _connection, CURLOPT_HEADERDATA, self);
   }
}


/*
 * The actual response/request
 */
- (id) _parseContentsOfURLString:(NSString *) url
                   byPostingData:(NSData *) data
{
   CURLcode   res;
   char       *s;

   NSParameterAssert( [url isKindOfClass:[NSString class]]);

   if( ! _parser)
      [NSException raise:NSInternalInconsistencyException
                  format:@"You must have set the parser before calling %s", __FUNCTION__];
   if( ! [url length])
      [NSException raise:NSInvalidArgumentException
                  format:@"empty URL"];

   curl_easy_setopt( _connection, CURLOPT_URL, [url UTF8String]);
   if( data)
   {
      curl_easy_setopt( _connection, CURLOPT_POSTFIELDS, [data bytes]);
      curl_easy_setopt( _connection, CURLOPT_POSTFIELDSIZE_LARGE, (curl_off_t) [data length]);
   }
   else
      curl_easy_setopt( _connection, CURLOPT_POST, 0);

   res = curl_easy_perform( _connection);
   if( res != CURLE_OK)
   {
      // allow parser to use his own errors
      if( ! _errorDomain)
         errno = res;
      else
         errno = [_parser errorCodeWithCurl:self];
      return( NULL);
   }

   return( [_parser parsedObjectWithCurl:self]);
}



- (id) parseContentsOfURLString:(NSString *) url
{
   return( [self _parseContentsOfURLString:url
                             byPostingData:nil]);
}


- (id) parseContentsOfURLString:(NSString *) url
                  byPostingData:(NSData *) data
{
   NSParameterAssert( ! data || [data isKindOfClass:[NSData class]]);

   return( [self _parseContentsOfURLString:url
                             byPostingData:data]);
}


- (NSData *) dataWithContentsOfURLString:(NSString *) url
{
   id   plist;

   [self setParser:[NSMutableData data]];
   {
      plist = [self _parseContentsOfURLString:url
                                byPostingData:nil];
   }
   [self setParser:nil];

   return( plist);
}


- (NSData *) dataWithContentsOfURLString:(NSString *) url
                           byPostingData:(NSData *) data
{
   id   plist;

   [self setParser:[NSMutableData data]];
   {
      plist = [self _parseContentsOfURLString:url
                                byPostingData:data];
   }
   [self setParser:nil];

   return( plist);
}


/*
 * Lazy option table setup
 */
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

/*
 * Interface MulleObjCCurlErrorDomain with NSError
 */
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


@implementation NSMutableData( MulleObjCCurlParser)

- (BOOL) curl:(MulleObjCCurl *) curl
   parseBytes:(void *) bytes
       length:(NSUInteger) length
 {
   [self appendBytes:bytes
              length:length];
   return( YES);  // always happy
}


- (id) parsedObjectWithCurl:(MulleObjCCurl *) curl
{
   return( self);
}

@end
