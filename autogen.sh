#! /bin/sh
# autogen.sh - usage: ./autogen.sh [CONFIGURE-OPTIONS]

test -n "$srcdir" || srcdir=`dirname "$0"`
test -n "$srcdir" || srcdir=.
(
  cd "$srcdir" &&
  autoreconf --force --verbose --install
) || exit
test -n "$NOCONFIGURE" || "$srcdir/configure" "$@"
