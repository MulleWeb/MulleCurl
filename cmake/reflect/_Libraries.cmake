# This file will be regenerated by `mulle-sourcetree-to-cmake` via
# `mulle-sde reflect` and any edits will be lost.
#
# This file will be included by cmake/share/Files.cmake
#
# Disable generation of this file with:
#
# mulle-sde environment set MULLE_SOURCETREE_TO_CMAKE_LIBRARIES_FILE DISABLE
#
if( MULLE_TRACE_INCLUDE)
   message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

#
# Generated from sourcetree: EE48C273-5D2B-49DC-ADC6-627F85AA4C59;ssl;no-all-load,no-build,no-cmake-inherit,no-delete,no-dependency,no-fs,no-import,no-share,no-update;
# Disable with : `mulle-sourcetree mark ssl `
# Disable for this platform: `mulle-sourcetree mark ssl no-cmake-platform-${MULLE_UNAME}`
# Disable for a sdk: `mulle-sourcetree mark ssl no-cmake-sdk-<name>`
#
if( COLLECT_OS_SPECIFIC_LIBRARIES_AS_NAMES)
   list( APPEND OS_SPECIFIC_LIBRARIES "ssl")
else()
   if( NOT SSL_LIBRARY)
      find_library( SSL_LIBRARY NAMES
         ssl
      )
      message( STATUS "SSL_LIBRARY is ${SSL_LIBRARY}")
      #
      # The order looks ascending, but due to the way this file is read
      # it ends up being descending, which is what we need.
      #
      if( SSL_LIBRARY)
         #
         # Add SSL_LIBRARY to OS_SPECIFIC_LIBRARIES list.
         # Disable with: `mulle-sourcetree mark ssl no-cmake-add`
         #
         list( APPEND OS_SPECIFIC_LIBRARIES ${SSL_LIBRARY})
         # intentionally left blank
      else()
         # Disable with: `mulle-sourcetree mark ssl no-require-link`
         message( SEND_ERROR "SSL_LIBRARY was not found")
      endif()
   endif()
endif()


#
# Generated from sourcetree: 4BFC2752-5817-46EF-9979-D8C9529144F0;crypto;no-all-load,no-build,no-cmake-inherit,no-delete,no-dependency,no-fs,no-header,no-import,no-share,no-update;
# Disable with : `mulle-sourcetree mark crypto `
# Disable for this platform: `mulle-sourcetree mark crypto no-cmake-platform-${MULLE_UNAME}`
# Disable for a sdk: `mulle-sourcetree mark crypto no-cmake-sdk-<name>`
#
if( COLLECT_OS_SPECIFIC_LIBRARIES_AS_NAMES)
   list( APPEND OS_SPECIFIC_LIBRARIES "crypto")
else()
   if( NOT CRYPTO_LIBRARY)
      find_library( CRYPTO_LIBRARY NAMES
         crypto
      )
      message( STATUS "CRYPTO_LIBRARY is ${CRYPTO_LIBRARY}")
      #
      # The order looks ascending, but due to the way this file is read
      # it ends up being descending, which is what we need.
      #
      if( CRYPTO_LIBRARY)
         #
         # Add CRYPTO_LIBRARY to OS_SPECIFIC_LIBRARIES list.
         # Disable with: `mulle-sourcetree mark crypto no-cmake-add`
         #
         list( APPEND OS_SPECIFIC_LIBRARIES ${CRYPTO_LIBRARY})
         # intentionally left blank
      else()
         # Disable with: `mulle-sourcetree mark crypto no-require-link`
         message( SEND_ERROR "CRYPTO_LIBRARY was not found")
      endif()
   endif()
endif()
