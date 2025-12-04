#!/bin/sh
set -ex

# usage: $0 <IMAGE> [<FILE>]...

IMG=$1
shift

dd if=/dev/zero of=$IMG bs=1M count=16
mkfs.fat -F 16 $IMG
IMG=$(readlink -f $IMG)

# on linux require mtools: apt install mtools
#

MTOOLSRC=$HOME/.mtoolsrc

# save current state of MTOOLSRC
if [ -f $MTOOLSRC ]; then
	cp $MTOOLSRC $MTOOLSRC.bak
fi

echo "drive x: file=\"$IMG\"" > $MTOOLSRC
for f in $@; do
	echo "copying $f"
	mcopy $f x:/
done

# restore current state of MTOOLSRC
if [ -f $MTOOLSRC.bak ]; then
	mv $MTOOLSRC.bak $MTOOLSRC
fi
