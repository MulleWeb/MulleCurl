# MulleCurl

#### 🥌 HTTP client library for mulle-objc

Uses [libcurl](https://curl.haxx.se) to GET and POST `NSData` from URLs.
It uses the **easy**  interface of libcurl. The curl library is compiled
for HTTP(S) only.

Written in and for [mulle-objc](//mulle-objc.github.io).

### You are here

```
  .------------------------------------------------.
  | MulleWebClient                                 |
  '------------------------------------------------'
                    .------------..----------------.
                    | JSMN       || HTTP           |
                    '------------''----------------'
  .================..------------..----------------.
  | Curl           || Plist      || Inet           |
  '================''------------''----------------'
  .---------..-----------------------------.
  | Zlib    || Standard                    |
  '---------''-----------------------------'
  .----------------------------------------..------.
  | Value                                  || Lock |
  '----------------------------------------''------'
```

## Usage


This example fetches a text file and prints it out.

```
#import <MulleCurl/MulleCurl.h>

#include <stdio.h>

static NSString   *URL = @"https://www.mulle-kybernetik.com/weblog/2019/mulle_objc_0_16_release.html";


int  main( void)
{
   MulleCurl   *curl;
   NSURL       *url;
   NSData      *data;
   NSError     *error;

   curl = [[MulleCurl new] autorelease];
   [curl setOptions:@{
                       @"CURLOPT_SSL_VERIFYPEER": @(NO),
                       @"CURLOPT_SSL_VERIFYHOST": @(NO)
                     }];
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

Notable is the simple interface. Instead of `-dataWithContentsOfURL:error:` it
is just `-dataWithContentsOfURLWithString:`. You don't have to wrap the string
into an NSURL and the NSError can be retrieved later if desired.

[MulleWeb](/MulleWeb/MulleWeb) adds a `NSURL` interface for convenience.


## Add

Use [mulle-sde](//github.com/mulle-sde) to add MulleCurl to your project:

```
mulle-sde dependency add --objc --github MulleWeb MulleCurl
```

## Install

Use [mulle-sde](//github.com/mulle-sde) to build and install MulleCurl and
all its dependencies:

```
mulle-sde install --objc --prefix /usr/local \
   https://github.com/MulleWeb/MulleCurl/archive/latest.tar.gz
```


## Acknowledgements

Parts of this library are from [libcurl(https://curl.haxx.se/libcurl/), which has this license:

```
COPYRIGHT AND PERMISSION NOTICE

Copyright (c) 1996 - 2019, Daniel Stenberg, daniel@haxx.se, and many contributors, see the THANKS file.

All rights reserved.

Permission to use, copy, modify, and distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF THIRD PARTY RIGHTS. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Except as contained in this notice, the name of a copyright holder shall not be used in advertising or otherwise to promote the sale, use or other dealings in this Software without prior written authorization of the copyright holder.
```

## Authors

[Nat!](//www.mulle-kybernetik.com/weblog) for
[Mulle kybernetiK](//www.mulle-kybernetik.com) and
[Codeon GmbH](//www.codeon.de)

