# This must be called before AC_PROG_CC
AC_DEFUN([CHECK_OS_OPTIONS], [

CFLAGS="$CFLAGS -Wall -std=gnu99 -fno-strict-aliasing"

case $host_os in
	*aix*)
		HOST_OS=aix
		if test "`echo $CC | cut -d ' ' -f 1`" != "gcc" ; then
			CFLAGS="-qnoansialias $USER_CFLAGS"
		fi
		AC_SUBST([PLATFORM_LDADD], ['-lperfstat -lpthread'])
		;;
	*cygwin*)
		HOST_OS=cygwin
		;;
	*darwin*)
		BUILD_NC=yes
		HOST_OS=darwin
		HOST_ABI=macosx
		AC_SUBST([PROG_LDADD], ['-lresolv'])
		;;
	*freebsd*)
		HOST_OS=freebsd
		HOST_ABI=elf
		AC_SUBST([PROG_LDADD], ['-lthr'])
		;;
	*hpux*)
		HOST_OS=hpux;
		if test "`echo $CC | cut -d ' ' -f 1`" = "gcc" ; then
			CFLAGS="$CFLAGS -mlp64"
		else
			CFLAGS="-g -O2 +DD64 +Otype_safety=off $USER_CFLAGS"
		fi
		CPPFLAGS="$CPPFLAGS -D_XOPEN_SOURCE=600 -D__STRICT_ALIGNMENT"
		AC_SUBST([PLATFORM_LDADD], ['-lpthread'])
		;;
	*linux*)
		BUILD_NC=yes
		HOST_OS=linux
		HOST_ABI=elf
		CPPFLAGS="$CPPFLAGS -D_DEFAULT_SOURCE -D_BSD_SOURCE -D_POSIX_SOURCE -D_GNU_SOURCE"
		AC_SUBST([PROG_LDADD], ['-lresolv'])
		;;
	*netbsd*)
		HOST_OS=netbsd
		CPPFLAGS="$CPPFLAGS -D_OPENBSD_SOURCE"
		;;
	*openbsd* | *bitrig*)
		BUILD_NC=yes
		HOST_OS=openbsd
		HOST_ABI=elf
		AC_DEFINE([HAVE_ATTRIBUTE__BOUNDED__], [1], [OpenBSD gcc has bounded])
		;;
	*mingw*)
		HOST_OS=win
		CPPFLAGS="$CPPFLAGS -D_GNU_SOURCE -D_POSIX -D_POSIX_SOURCE -D__USE_MINGW_ANSI_STDIO"
		CPPFLAGS="$CPPFLAGS -D_REENTRANT -D_POSIX_THREAD_SAFE_FUNCTIONS"
		CPPFLAGS="$CPPFLAGS -DWIN32_LEAN_AND_MEAN -D_WIN32_WINNT=0x0501"
		CPPFLAGS="$CPPFLAGS -DOPENSSL_NO_SPEED"
		CFLAGS="$CFLAGS -static-libgcc"
		LDFLAGS="$LDFLAGS -static-libgcc"
		AC_SUBST([PLATFORM_LDADD], ['-lws2_32'])
		;;
	*solaris*)
		HOST_OS=solaris
		HOST_ABI=elf
		CPPFLAGS="$CPPFLAGS -D__EXTENSIONS__ -D_XOPEN_SOURCE=600 -DBSD_COMP"
		AC_SUBST([PLATFORM_LDADD], ['-lnsl -lsocket'])
		;;
	*) ;;
esac

AM_CONDITIONAL([BUILD_NC],     [test x$BUILD_NC = xyes])
AM_CONDITIONAL([HOST_AIX],     [test x$HOST_OS = xaix])
AM_CONDITIONAL([HOST_CYGWIN],  [test x$HOST_OS = xcygwin])
AM_CONDITIONAL([HOST_DARWIN],  [test x$HOST_OS = xdarwin])
AM_CONDITIONAL([HOST_FREEBSD], [test x$HOST_OS = xfreebsd])
AM_CONDITIONAL([HOST_HPUX],    [test x$HOST_OS = xhpux])
AM_CONDITIONAL([HOST_LINUX],   [test x$HOST_OS = xlinux])
AM_CONDITIONAL([HOST_NETBSD],  [test x$HOST_OS = xnetbsd])
AM_CONDITIONAL([HOST_OPENBSD], [test x$HOST_OS = xopenbsd])
AM_CONDITIONAL([HOST_SOLARIS], [test x$HOST_OS = xsolaris])
AM_CONDITIONAL([HOST_WIN],     [test x$HOST_OS = xwin])
])
