/*
 *   This file will be regenerated by `mulle-project-versioncheck`.
 *   Any edits will be lost.
 */
#ifndef mulle_curl_versioncheck_h__
#define mulle_curl_versioncheck_h__

#if defined( MULLE_FOUNDATION_BASE_VERSION)
# ifndef MULLE_FOUNDATION_BASE_VERSION_MIN
#  define MULLE_FOUNDATION_BASE_VERSION_MIN  ((0UL << 20) | (22 << 8) | 0)
# endif
# ifndef MULLE_FOUNDATION_BASE_VERSION_MAX
#  define MULLE_FOUNDATION_BASE_VERSION_MAX  ((0UL << 20) | (23 << 8) | 0)
# endif
# if MULLE_FOUNDATION_BASE_VERSION < MULLE_FOUNDATION_BASE_VERSION_MIN
#  error "MulleFoundationBase is too old"
# endif
# if MULLE_FOUNDATION_BASE_VERSION >= MULLE_FOUNDATION_BASE_VERSION_MAX
#  error "MulleFoundationBase is too new"
# endif
#endif

#if defined( MULLE_ZLIB_VERSION)
# ifndef MULLE_ZLIB_VERSION_MIN
#  define MULLE_ZLIB_VERSION_MIN  ((0UL << 20) | (15 << 8) | 10)
# endif
# ifndef MULLE_ZLIB_VERSION_MAX
#  define MULLE_ZLIB_VERSION_MAX  ((0UL << 20) | (16 << 8) | 0)
# endif
# if MULLE_ZLIB_VERSION < MULLE_ZLIB_VERSION_MIN
#  error "MulleZlib is too old"
# endif
# if MULLE_ZLIB_VERSION >= MULLE_ZLIB_VERSION_MAX
#  error "MulleZlib is too new"
# endif
#endif

#endif
