//
//  MulleCurl-Private.h
//  MulleCurl
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
#ifdef OBJECTPOINT
# undef OBJECTPOINT
#endif
#ifdef STRINGPOINT
# undef STRINGPOINT
#endif
#ifdef FUNCTIONPOINT
# undef FUNCTIONPOINT
#endif
#ifdef SLISTPOINT
# undef SLISTPOINT
#endif
#ifdef OFF_T
# undef OFF_T
#endif

enum mulle_curl_option_type
{
   FUNCTIONPOINT = 1,
   OBJECTPOINT,
   SLISTPOINT,
   STRINGPOINT,
   LONG,
   OFF_T
};


MULLE_C_NONNULL_RETURN
NSMapTable   *MulleCurlOptionLookupTable( void);

char   *MulleCurlDefaultUserAgent( void);

@interface MulleCurl( Private)

+ (NSMapTable *) optionLookupTable;

@end


