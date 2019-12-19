//
//  MulleObjCCurl.h
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

#import "import.h"


@interface MulleObjCCurl : NSObject
{
   NSMutableData   *_data;  // receive buffer
}

@property void *   connection;  // CURL *


//
// Objc interface to curl options, you could also just get
// then connection and do curl_easy_setopt yourself
// use the name of the curl option like @"CURLOPT_VERBOSE"
// key and an appropriate NSString or NSNumber for value.
// See. https://curl.haxx.se/libcurl/c/curl_easy_setopt.html
// for a list of options.
//
- (void) setOptions:(NSDictionary *) options;

// choose either one for a somewhat better experience, the
// default is neither!
- (void) setDesktopTimeoutOptions;
- (void) setMobileTimeoutOptions;

- (void) setDefaultOptions;
- (void) setDebugOptions;

//
// call this if you want to to return to curl standard options +
// setDefaultOptions (as if you ran -init again)
//
- (void) reset;

// if these return NULL, and error occurred. You can retrieve the
// appropriate NSError with:
//
//    MulleObjCErrorGetCurrentErrorWithDomain( MulleObjCCurlErrorDomain)
// or
//    +[NSError mulleCurrentErrorWithDomain:MulleObjCCurlErrorDomain]
//
- (NSData *) dataWithContentsOfURLString:(NSString *) url;
- (NSData *) dataWithContentsOfURLString:(NSString *) url
                           byPostingData:(NSData *) data;

@end

extern NSString   *MulleObjCCurlErrorDomain; // = @"MulleObjCCurlError";


// move this where ??
@interface MulleObjCCurl( NSURL)

- (NSData *) dataWithContentsOfURL:(NSURL *) url;
- (NSData *) dataWithContentsOfURL:(NSURL *) url
                     byPostingData:(NSData *) data;

@end

