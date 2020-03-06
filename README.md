# MulleCurl

#### 🥌 HTTP client library for the MulleFoundation based on libcurl

A library on top of the MulleFoundation.


Uses [libcurl](https://curl.haxx.se) to GET and POST `NSData` from URLs.
It uses the **easy**  interface of libcurl. The curl library is compiled
for HTTP(S) only.

Written in and for [mulle-objc](//mulle-objc.github.io).


Build Status | Release Version
-------------|-----------------------------------
[![Build Status](https://travis-ci.org/MulleWeb/MulleCurl.svg?branch=release)](https://travis-ci.org/MulleWeb/MulleCurl) | ![Mulle kybernetiK tag](https://img.shields.io/github/tag/MulleWeb/MulleCurl.svg) [![Build Status](https://travis-ci.org/MulleWeb/MulleCurl.svg?branch=release)](https://travis-ci.org/MulleWeb/MulleCurl)



## Usage


This example fetches a text file and prints it out.

```
#import <MulleCurl/MulleCurl.h>

#include <stdio.h>

static NSString   *URL = @"https://www.mulle-kybernetik.com/weblog/2019/mulle_objc_0_16_release.html";


int  main( void)
{
   MulleCurl   *curl;
   NSURL           *url;
   NSData          *data;
   NSError         *error;

   curl = [[MulleCurl new] autorelease];
   [curl setOptions:@{
                       @"CURLOPT_SSL_VERIFYPEER": @(NO),
                       @"CURLOPT_SSL_VERIFYHOST": @(NO)
                     }];
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
```

Notable is the simple interface. Instead of `-dataWithContentsOfURL:error:` it
is just `-dataWithContentsOfURLWithString:`. You don't have to wrap the string
into an NSURL and the NSError can be retrieved later
if required.

[MulleWeb](/MulleWeb/MulleWeb) adds a `NSURL` interface for convenience.


## Build

This is a [mulle-sde](https://mulle-sde.github.io/) project.

It has it's own virtual environment, that will be automatically setup for you
once you enter it with:

```
mulle-sde MulleCurl
```

Now you can let **mulle-sde** fetch the required dependencies and build the
project for you:

```
mulle-sde craft
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

