#
# cmake/reflect/_Headers.cmake is generated by `mulle-sde reflect`. Edits will be lost.
#
if( MULLE_TRACE_INCLUDE)
   MESSAGE( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

set( INCLUDE_DIRS
src
src/reflect
)

set( PRIVATE_GENERATED_HEADERS
src/reflect/_MulleCurl-import-private.h
src/reflect/_MulleCurl-include-private.h
)

set( PRIVATE_HEADERS
src/MulleCurl+Private.h
src/import-private.h
)

set( PUBLIC_GENERATED_HEADERS
src/reflect/_MulleCurl-import.h
src/reflect/_MulleCurl-include.h
)

set( PUBLIC_HEADERS
src/MulleCurlParser.h
src/MulleCurl.h
src/MulleObjCLoader+MulleCurl.h
src/NSMutableData+MulleCurlParser.h
src/import.h
)
