#!/bin/sh
set -e

if [ $# -ne 1 ]; then
	echo "usage: $0 <SMOLBSD_DIR>"
	echo
	echo "Clones smolBSD project into SMOLBSD_DIR and fetches the kernel"
	echo
	exit 1
fi

SMOLDIR="$1"
OS=$(uname -s)

# select a MAKE
if [ -z "$MAKE" ]; then
	case "$OS" in
	NetBSD)
		MAKE=make
		;;
	*)
		MAKE=bmake
		;;
	esac
fi

# clone repo if it does not exit
if [ ! -d smolBSD ]; then
	git clone --depth 1 https://github.com/NetBSDfr/smolBSD.git $SMOLDIR
fi

# fetch kernel
$MAKE -C $SMOLDIR kernfetch
