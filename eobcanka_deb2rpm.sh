#!/bin/bash

DEB=$1

ALIEN_OUT=$(mktemp)
alien --to-rpm --scripts --generate "$DEB" >$ALIEN_OUT

SPEC_DIR=$(awk '/Directory/ {print $2}' $ALIEN_OUT)


pushd $SPEC_DIR

FS_DIRS=$(mktemp)
SPEC=$(ls *.spec)

rpm -ql filesystem | sed 's/^/%dir "/; s/$/\/"/; s,//,/,;' >$FS_DIRS

# remove standard dirs from package
grep -vxf $FS_DIRS $SPEC >$SPEC.nodirs

sed '/^Group:/ a \
# remove requires/provides from bundled libs \
%global __requires_exclude ^(libQt5|libicu|libcmprovp11|libcryptoui|libcrypto|libssl|libeop2v1czep11|libeopczep11|libeopproxyp11|libsa2v1czep11).*$ \
%global __provides_exclude ^(libQt5|libicu|libcmprovp11|libcryptoui|libcrypto|libssl|libeop2v1czep11|libeopczep11|libeopproxyp11|libsa2v1czep11).*$' \
        $SPEC.nodirs >$SPEC

rpmbuild -bb --define "buildroot $PWD" $SPEC

rm -f $FS_DIRS $ALIEN_OUT
