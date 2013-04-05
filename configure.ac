AC_PREREG([2.69])

m4_define([t4_major_version], [0])
m4_define([t4_minor_version], [0])
m4_define([t4_micro_version], [1])
m4_define([t4_version],
          [t4_major_version.t4_minor_version.t4_micro_version])

AC_INIT([t4],
	[t4_version],
	[chrisc.101@gmail.com])

AC_SUBST([T4_VERSION_MAJOR], [t4_major_version])
AC_SUBST([T4_VERSION_MINOR], [t4_minor_version])
AC_SUBST([T4_VERSION_MICRO], [t4_micro_version])
AC_SUBST([T4_VERSION], [t4_version])

if test "x$prefix" = "xNONE" ; then
  prefix="/usr/local"
fi
if test "x$exec_prefix" = "xNONE" ; then
  exec_prefix=$prefix
fi
PREFIX=$prefix
AC_SUBST([PREFIX])

DATE="$(date +'%B %d, %Y')"
AC_SUBST([DATE])

AM_INIT_AUTOMAKE([1.11 foreign -Wall -Werror -Wno-portability])

AC_OUTPUT([
README
Makefile
Documentation/Makefile
examples/Makefile
t4c.sh
t4.m4
])
