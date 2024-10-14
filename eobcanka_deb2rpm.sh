#!/bin/bash

set -eu
set -o pipefail

if [ "$#" -ne 1 ]
then
    echo "Usage: sudo $0 <deb file>" >&2
    echo >&2
    exit 1
fi

DEB=$1

ALIEN_OUT=$(mktemp)
FS_DIRS=$(mktemp)

_cleanup() {
    cd /
    rm -f "$FS_DIRS" "$ALIEN_OUT"
}

trap _cleanup INT TERM EXIT

alien --to-rpm --scripts --generate "$DEB" >"$ALIEN_OUT"

SPEC_DIR=$(awk '/Directory/ {print $2}' "$ALIEN_OUT")


pushd "$SPEC_DIR" > /dev/null

SPEC=$(ls ./*.spec)

# Require a Czech locale package and remove the use of a Debian-specific locale-gen utility.
# The piece of code we want to remove from the spec file is:
# ```
# ##CZ language support
# ISLANGCSACTIVE=$(/usr/bin/locale -a|grep cs_CZ)
#
# if [ -z $ISLANGCSACTIVE ] ; then
#    locale-gen cs_CZ.utf8
# fi
# ```
sed -i '/^Group:/ a Requires: glibc-langpack-cs' "$SPEC"
sed -i '/##CZ/{:a;N;/utf8\nfi/!ba};//d' "$SPEC"

rpm -ql filesystem | sed 's/^/%dir "/; s/$/\/"/; s,//,/,;' >"$FS_DIRS"

# remove standard dirs from package
grep -vxf "$FS_DIRS" "$SPEC" >"$SPEC.nodirs"

sed '1i \
# remove requires/provides from bundled libs \
%global __requires_exclude ^(libQt6|libeop2v1czep11|libeopczep11|libeopproxyp11|libsa2v1czep11).*$\n' \
        "$SPEC.nodirs" >"$SPEC"

rm "$SPEC.nodirs"

rpmbuild -bb --define "buildroot $PWD" "$SPEC"

_cleanup
