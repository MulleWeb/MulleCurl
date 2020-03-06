#
# cmake/_Headers.cmake is generated by `mulle-sde`. Edits will be lost.
#
if( MULLE_TRACE_INCLUDE)
   MESSAGE( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

set( INCLUDE_DIRS
src
)

set( PRIVATE_HEADERS
src/MulleCurl+Private.h
src/import-private.h
)

set( PUBLIC_HEADERS
src/MulleCurlFoundation.h
src/MulleCurlParser.h
src/MulleCurl.h
src/MulleHTTPHeaderParser.h
src/MulleObjCLoader+MulleCurl.h
src/NSMutableData+MulleCurlParser.h
src/import.h
)

