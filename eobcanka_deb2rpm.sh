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

# Replace upstream libcrypto library with a symlink to system one to avoid error:
#     symbol lookup error: /lib64/libk5crypto.so.3: undefined symbol: EVP_KDF_ctrl, version OPENSSL_1_1_1b
# See: https://forum.mojefedora.cz/t/eobcanka/7941/8 or https://bugzilla.redhat.com/show_bug.cgi?id=1829790#c9
rm "opt/eObcanka/lib/openssl1.1/libcrypto.so.1.1"
sed -i '/^%postun/ i ln -fs /usr/lib64/libcrypto.so.1.1 /opt/eObcanka/lib/openssl1.1/libcrypto.so.1.1' "$SPEC"
sed -i 's/^\(".*\/libcrypto.so.1.1"\)$/%ghost \1/' "$SPEC"

# Require Czech locale package and remove Debian-specific local-gen
sed -i '/^Group:/ a Requires: glibc-langpack-cs' "$SPEC"
sed -i '/##CZ/{:a;N;/utf8\nfi/!ba};//d' "$SPEC"

rpm -ql filesystem | sed 's/^/%dir "/; s/$/\/"/; s,//,/,;' >"$FS_DIRS"

# remove standard dirs from package
grep -vxf "$FS_DIRS" "$SPEC" >"$SPEC.nodirs"

sed '1i \
# remove requires/provides from bundled libs \
%global __requires_exclude ^(libQt5|libicu|libcmprovp11|libcryptoui|libcrypto|libssl|libeop2v1czep11|libeopczep11|libeopproxyp11|libsa2v1czep11).*$ \
%global __provides_exclude ^(libQt5|libicu|libcmprovp11|libcryptoui|libcrypto|libssl|libeop2v1czep11|libeopczep11|libeopproxyp11|libsa2v1czep11).*$\n' \
        "$SPEC.nodirs" >"$SPEC"

rm "$SPEC.nodirs"

rpmbuild -bb --define "buildroot $PWD" "$SPEC"

_cleanup
