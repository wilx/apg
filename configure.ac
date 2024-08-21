#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([apg], [2.4.0], [https://github.com/wilx/apg])
AC_CONFIG_SRCDIR([apg.c])
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_HEADERS([config.h])
AM_INIT_AUTOMAKE([1.14 foreign subdir-objects -Wall])
AM_MAINTAINER_MODE([enable])

# Checks for programs.
AC_PROG_AWK
AC_PROG_INSTALL

AC_PROG_CC
AC_USE_SYSTEM_EXTENSIONS
AX_COMPILER_VENDOR

AS_CASE([$ax_cv_c_compiler_vendor],
    dnl Skip all warnings detection for Solaris Studio compilers. It
    dnl adds the -v option and that breaks PIC support detection.
    [sun], [],
    [AX_CFLAGS_WARN_ALL])

# Checks for header files.

AC_CHECK_HEADERS([arpa/inet.h netinet/in.h stdlib.h string.h strings.h])
AC_CHECK_HEADERS([sys/socket.h sys/time.h syslog.h unistd.h])
AC_CHECK_HEADERS([crypt.h pwd.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_TYPE_SIZE_T

# Checks for libraries.
AC_SEARCH_LIBS([crypt], [crypt])
AC_SEARCH_LIBS([sin], [m])
AC_SEARCH_LIBS([gethostbyname], [nsl network net])
AC_SEARCH_LIBS([setsockopt], [socket network net])
AC_SEARCH_LIBS([strerror], [cposix])

# Checks for library functions.
AC_CHECK_FUNCS([getpass gettimeofday inet_ntoa memset strchr strerror])
AC_CHECK_FUNCS([crypt])

LT_PREREQ([2.4.2])
LT_INIT([win32-dll disable-static pic-only])

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
