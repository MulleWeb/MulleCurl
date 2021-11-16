# This file will be regenerated by `mulle-sourcetree-to-cmake` via
# `mulle-sde reflect` and any edits will be lost.
#
# This file will be included by cmake/share/Files.cmake
#
# Disable generation of this file with:
#
# mulle-sde environment set MULLE_SOURCETREE_TO_CMAKE_DEPENDENCIES_FILE DISABLE
#
if( MULLE_TRACE_INCLUDE)
   message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

#
# Generated from sourcetree: 78cfb19c-00ec-4df6-9c13-00a6aa134000;curl;no-all-load,no-import;Release:curl,Debug:curl-d
# Disable with : `mulle-sourcetree mark curl no-link`
# Disable for this platform: `mulle-sourcetree mark curl no-cmake-platform-${MULLE_UNAME}`
#
if( NOT CURL_LIBRARY)
   if( "${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
      find_library( CURL_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}curl-d${CMAKE_STATIC_LIBRARY_SUFFIX} curl-d NO_CMAKE_SYSTEM_PATH NO_SYSTEM_ENVIRONMENT_PATH)
   endif()
   if( NOT CURL_LIBRARY)
      find_library( CURL_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}curl${CMAKE_STATIC_LIBRARY_SUFFIX} curl NO_CMAKE_SYSTEM_PATH NO_SYSTEM_ENVIRONMENT_PATH)
   endif()
   message( STATUS "CURL_LIBRARY is ${CURL_LIBRARY}")
   #
   # The order looks ascending, but due to the way this file is read
   # it ends up being descending, which is what we need.
   #
   if( CURL_LIBRARY)
      #
      # Add CURL_LIBRARY to DEPENDENCY_LIBRARIES list.
      # Disable with: `mulle-sourcetree mark curl no-cmake-add`
      #
      set( DEPENDENCY_LIBRARIES
         ${DEPENDENCY_LIBRARIES}
         ${CURL_LIBRARY}
         CACHE INTERNAL "need to cache this"
      )
      #
      # Inherit information from dependency.
      # Encompasses: no-cmake-searchpath,no-cmake-dependency,no-cmake-loader
      # Disable with: `mulle-sourcetree mark curl no-cmake-inherit`
      #
      # temporarily expand CMAKE_MODULE_PATH
      get_filename_component( _TMP_CURL_ROOT "${CURL_LIBRARY}" DIRECTORY)
      get_filename_component( _TMP_CURL_ROOT "${_TMP_CURL_ROOT}" DIRECTORY)
      #
      #
      # Search for "DependenciesAndLibraries.cmake" to include.
      # Disable with: `mulle-sourcetree mark curl no-cmake-dependency`
      #
      foreach( _TMP_CURL_NAME "curl" "curl-d")
         set( _TMP_CURL_DIR "${_TMP_CURL_ROOT}/include/${_TMP_CURL_NAME}/cmake")
         # use explicit path to avoid "surprises"
         if( EXISTS "${_TMP_CURL_DIR}/DependenciesAndLibraries.cmake")
            unset( CURL_DEFINITIONS)
            list( INSERT CMAKE_MODULE_PATH 0 "${_TMP_CURL_DIR}")
            # we only want top level INHERIT_OBJC_LOADERS, so disable them
            if( NOT NO_INHERIT_OBJC_LOADERS)
               set( NO_INHERIT_OBJC_LOADERS OFF)
            endif()
            list( APPEND _TMP_INHERIT_OBJC_LOADERS ${NO_INHERIT_OBJC_LOADERS})
            set( NO_INHERIT_OBJC_LOADERS ON)
            #
            include( "${_TMP_CURL_DIR}/DependenciesAndLibraries.cmake")
            #
            list( GET _TMP_INHERIT_OBJC_LOADERS -1 NO_INHERIT_OBJC_LOADERS)
            list( REMOVE_AT _TMP_INHERIT_OBJC_LOADERS -1)
            #
            list( REMOVE_ITEM CMAKE_MODULE_PATH "${_TMP_CURL_DIR}")
            set( INHERITED_DEFINITIONS
               ${INHERITED_DEFINITIONS}
               ${CURL_DEFINITIONS}
               CACHE INTERNAL "need to cache this"
            )
            break()
         else()
            message( STATUS "${_TMP_CURL_DIR}/DependenciesAndLibraries.cmake not found")
         endif()
      endforeach()
   else()
      # Disable with: `mulle-sourcetree mark curl no-require-link`
      message( FATAL_ERROR "CURL_LIBRARY was not found")
   endif()
endif()


#
# Generated from sourcetree: CD2DD14F-0BE9-4304-9520-04508C7787FB;MulleObjCStandardFoundation;no-singlephase;
# Disable with : `mulle-sourcetree mark MulleObjCStandardFoundation no-link`
# Disable for this platform: `mulle-sourcetree mark MulleObjCStandardFoundation no-cmake-platform-${MULLE_UNAME}`
#
if( NOT MULLE_OBJC_STANDARD_FOUNDATION_LIBRARY)
   find_library( MULLE_OBJC_STANDARD_FOUNDATION_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}MulleObjCStandardFoundation${CMAKE_STATIC_LIBRARY_SUFFIX} MulleObjCStandardFoundation NO_CMAKE_SYSTEM_PATH NO_SYSTEM_ENVIRONMENT_PATH)
   message( STATUS "MULLE_OBJC_STANDARD_FOUNDATION_LIBRARY is ${MULLE_OBJC_STANDARD_FOUNDATION_LIBRARY}")
   #
   # The order looks ascending, but due to the way this file is read
   # it ends up being descending, which is what we need.
   #
   if( MULLE_OBJC_STANDARD_FOUNDATION_LIBRARY)
      #
      # Add MULLE_OBJC_STANDARD_FOUNDATION_LIBRARY to ALL_LOAD_DEPENDENCY_LIBRARIES list.
      # Disable with: `mulle-sourcetree mark MulleObjCStandardFoundation no-cmake-add`
      #
      set( ALL_LOAD_DEPENDENCY_LIBRARIES
         ${ALL_LOAD_DEPENDENCY_LIBRARIES}
         ${MULLE_OBJC_STANDARD_FOUNDATION_LIBRARY}
         CACHE INTERNAL "need to cache this"
      )
      #
      # Inherit information from dependency.
      # Encompasses: no-cmake-searchpath,no-cmake-dependency,no-cmake-loader
      # Disable with: `mulle-sourcetree mark MulleObjCStandardFoundation no-cmake-inherit`
      #
      # temporarily expand CMAKE_MODULE_PATH
      get_filename_component( _TMP_MULLE_OBJC_STANDARD_FOUNDATION_ROOT "${MULLE_OBJC_STANDARD_FOUNDATION_LIBRARY}" DIRECTORY)
      get_filename_component( _TMP_MULLE_OBJC_STANDARD_FOUNDATION_ROOT "${_TMP_MULLE_OBJC_STANDARD_FOUNDATION_ROOT}" DIRECTORY)
      #
      #
      # Search for "DependenciesAndLibraries.cmake" to include.
      # Disable with: `mulle-sourcetree mark MulleObjCStandardFoundation no-cmake-dependency`
      #
      foreach( _TMP_MULLE_OBJC_STANDARD_FOUNDATION_NAME "MulleObjCStandardFoundation")
         set( _TMP_MULLE_OBJC_STANDARD_FOUNDATION_DIR "${_TMP_MULLE_OBJC_STANDARD_FOUNDATION_ROOT}/include/${_TMP_MULLE_OBJC_STANDARD_FOUNDATION_NAME}/cmake")
         # use explicit path to avoid "surprises"
         if( EXISTS "${_TMP_MULLE_OBJC_STANDARD_FOUNDATION_DIR}/DependenciesAndLibraries.cmake")
            unset( MULLE_OBJC_STANDARD_FOUNDATION_DEFINITIONS)
            list( INSERT CMAKE_MODULE_PATH 0 "${_TMP_MULLE_OBJC_STANDARD_FOUNDATION_DIR}")
            #
            include( "${_TMP_MULLE_OBJC_STANDARD_FOUNDATION_DIR}/DependenciesAndLibraries.cmake")
            #
            #
            list( REMOVE_ITEM CMAKE_MODULE_PATH "${_TMP_MULLE_OBJC_STANDARD_FOUNDATION_DIR}")
            set( INHERITED_DEFINITIONS
               ${INHERITED_DEFINITIONS}
               ${MULLE_OBJC_STANDARD_FOUNDATION_DEFINITIONS}
               CACHE INTERNAL "need to cache this"
            )
            break()
         else()
            message( STATUS "${_TMP_MULLE_OBJC_STANDARD_FOUNDATION_DIR}/DependenciesAndLibraries.cmake not found")
         endif()
      endforeach()
      #
      # Search for "MulleObjCLoader+<name>.h" in include directory.
      # Disable with: `mulle-sourcetree mark MulleObjCStandardFoundation no-cmake-loader`
      #
      if( NOT NO_INHERIT_OBJC_LOADERS)
         foreach( _TMP_MULLE_OBJC_STANDARD_FOUNDATION_NAME "MulleObjCStandardFoundation")
            set( _TMP_MULLE_OBJC_STANDARD_FOUNDATION_FILE "${_TMP_MULLE_OBJC_STANDARD_FOUNDATION_ROOT}/include/${_TMP_MULLE_OBJC_STANDARD_FOUNDATION_NAME}/MulleObjCLoader+${_TMP_MULLE_OBJC_STANDARD_FOUNDATION_NAME}.h")
            if( EXISTS "${_TMP_MULLE_OBJC_STANDARD_FOUNDATION_FILE}")
               set( INHERITED_OBJC_LOADERS
                  ${INHERITED_OBJC_LOADERS}
                  ${_TMP_MULLE_OBJC_STANDARD_FOUNDATION_FILE}
                  CACHE INTERNAL "need to cache this"
               )
               break()
            endif()
         endforeach()
      endif()
   else()
      # Disable with: `mulle-sourcetree mark MulleObjCStandardFoundation no-require-link`
      message( FATAL_ERROR "MULLE_OBJC_STANDARD_FOUNDATION_LIBRARY was not found")
   endif()
endif()


#
# Generated from sourcetree: f3c54219-3d56-4d37-8e04-2aed97ace766;MulleZlib;no-singlephase;
# Disable with : `mulle-sourcetree mark MulleZlib no-link`
# Disable for this platform: `mulle-sourcetree mark MulleZlib no-cmake-platform-${MULLE_UNAME}`
#
if( NOT MULLE_ZLIB_LIBRARY)
   find_library( MULLE_ZLIB_LIBRARY NAMES ${CMAKE_STATIC_LIBRARY_PREFIX}MulleZlib${CMAKE_STATIC_LIBRARY_SUFFIX} MulleZlib NO_CMAKE_SYSTEM_PATH NO_SYSTEM_ENVIRONMENT_PATH)
   message( STATUS "MULLE_ZLIB_LIBRARY is ${MULLE_ZLIB_LIBRARY}")
   #
   # The order looks ascending, but due to the way this file is read
   # it ends up being descending, which is what we need.
   #
   if( MULLE_ZLIB_LIBRARY)
      #
      # Add MULLE_ZLIB_LIBRARY to ALL_LOAD_DEPENDENCY_LIBRARIES list.
      # Disable with: `mulle-sourcetree mark MulleZlib no-cmake-add`
      #
      set( ALL_LOAD_DEPENDENCY_LIBRARIES
         ${ALL_LOAD_DEPENDENCY_LIBRARIES}
         ${MULLE_ZLIB_LIBRARY}
         CACHE INTERNAL "need to cache this"
      )
      #
      # Inherit information from dependency.
      # Encompasses: no-cmake-searchpath,no-cmake-dependency,no-cmake-loader
      # Disable with: `mulle-sourcetree mark MulleZlib no-cmake-inherit`
      #
      # temporarily expand CMAKE_MODULE_PATH
      get_filename_component( _TMP_MULLE_ZLIB_ROOT "${MULLE_ZLIB_LIBRARY}" DIRECTORY)
      get_filename_component( _TMP_MULLE_ZLIB_ROOT "${_TMP_MULLE_ZLIB_ROOT}" DIRECTORY)
      #
      #
      # Search for "DependenciesAndLibraries.cmake" to include.
      # Disable with: `mulle-sourcetree mark MulleZlib no-cmake-dependency`
      #
      foreach( _TMP_MULLE_ZLIB_NAME "MulleZlib")
         set( _TMP_MULLE_ZLIB_DIR "${_TMP_MULLE_ZLIB_ROOT}/include/${_TMP_MULLE_ZLIB_NAME}/cmake")
         # use explicit path to avoid "surprises"
         if( EXISTS "${_TMP_MULLE_ZLIB_DIR}/DependenciesAndLibraries.cmake")
            unset( MULLE_ZLIB_DEFINITIONS)
            list( INSERT CMAKE_MODULE_PATH 0 "${_TMP_MULLE_ZLIB_DIR}")
            #
            include( "${_TMP_MULLE_ZLIB_DIR}/DependenciesAndLibraries.cmake")
            #
            #
            list( REMOVE_ITEM CMAKE_MODULE_PATH "${_TMP_MULLE_ZLIB_DIR}")
            set( INHERITED_DEFINITIONS
               ${INHERITED_DEFINITIONS}
               ${MULLE_ZLIB_DEFINITIONS}
               CACHE INTERNAL "need to cache this"
            )
            break()
         else()
            message( STATUS "${_TMP_MULLE_ZLIB_DIR}/DependenciesAndLibraries.cmake not found")
         endif()
      endforeach()
      #
      # Search for "MulleObjCLoader+<name>.h" in include directory.
      # Disable with: `mulle-sourcetree mark MulleZlib no-cmake-loader`
      #
      if( NOT NO_INHERIT_OBJC_LOADERS)
         foreach( _TMP_MULLE_ZLIB_NAME "MulleZlib")
            set( _TMP_MULLE_ZLIB_FILE "${_TMP_MULLE_ZLIB_ROOT}/include/${_TMP_MULLE_ZLIB_NAME}/MulleObjCLoader+${_TMP_MULLE_ZLIB_NAME}.h")
            if( EXISTS "${_TMP_MULLE_ZLIB_FILE}")
               set( INHERITED_OBJC_LOADERS
                  ${INHERITED_OBJC_LOADERS}
                  ${_TMP_MULLE_ZLIB_FILE}
                  CACHE INTERNAL "need to cache this"
               )
               break()
            endif()
         endforeach()
      endif()
   else()
      # Disable with: `mulle-sourcetree mark MulleZlib no-require-link`
      message( FATAL_ERROR "MULLE_ZLIB_LIBRARY was not found")
   endif()
endif()
