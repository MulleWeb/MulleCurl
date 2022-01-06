# This file will be regenerated by `mulle-match-to-cmake` via
# `mulle-sde reflect` and any edits will be lost.
#
# This file will be included by cmake/share/Headers.cmake
#
if( MULLE_TRACE_INCLUDE)
   MESSAGE( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

#
# contents are derived from the file locations

set( INCLUDE_DIRS
src
src/reflect
)

#
# contents selected with patternfile ??-header--private-generated-headers
#
set( PRIVATE_GENERATED_HEADERS
src/reflect/_MulleCurl-import-private.h
src/reflect/_MulleCurl-include-private.h
)

#
# contents selected with patternfile ??-header--private-generic-headers
#
set( PRIVATE_GENERIC_HEADERS
src/import-private.h
)

#
# contents selected with patternfile ??-header--private-headers
#
set( PRIVATE_HEADERS
src/MulleCurl+Private.h
)

#
# contents selected with patternfile ??-header--public-generated-headers
#
set( PUBLIC_GENERATED_HEADERS
src/reflect/_MulleCurl-export.h
src/reflect/_MulleCurl-import.h
src/reflect/_MulleCurl-include.h
src/reflect/_MulleCurl-provide.h
)

#
# contents selected with patternfile ??-header--public-generic-headers
#
set( PUBLIC_GENERIC_HEADERS
src/import.h
)

#
# contents selected with patternfile ??-header--public-headers
#
set( PUBLIC_HEADERS
src/MulleCurlParser.h
src/MulleCurl.h
src/MulleObjCLoader+MulleCurl.h
src/NSMutableData+MulleCurlParser.h
src/reflect/_MulleCurl-versioncheck.h
)

