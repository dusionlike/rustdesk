#! /usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 OLD_VERSION NEW_VERSION" >&2
    exit 2
fi

old_version=$1
new_version=$2
old_version_re=$(printf '%s' "$old_version" | sed 's/[.[\*^$()+?{|\\]/\\&/g')

# Update application metadata only; dependency versions must remain unchanged.
sed -i -E "s/^(Version:[[:space:]]*)${old_version_re}$/\1${new_version}/" res/*spec
sed -i -E "s/^(pkgver=)${old_version_re}$/\1${new_version}/" res/PKGBUILD
sed -i -E "s/^(version: )${old_version_re}(\+[0-9]+)?$/\1${new_version}\2/" flutter/pubspec.yaml
sed -i -E "s/^(version = \")${old_version_re}(\")$/\1${new_version}\2/" Cargo.toml libs/portable/Cargo.toml
sed -i -E \
    -e "/^name = \"rustdesk\"$/,/^$/ s/^(version = \")${old_version_re}(\")$/\1${new_version}\2/" \
    -e "/^name = \"rustdesk-portable-packer\"$/,/^$/ s/^(version = \")${old_version_re}(\")$/\1${new_version}\2/" \
    Cargo.lock
sed -i -E "s/^([[:space:]]*VERSION:[[:space:]]*\")${old_version_re}(\")$/\1${new_version}\2/" .github/workflows/*yml
sed -i -E "s/^([[:space:]]+version:[[:space:]]*)${old_version_re}$/\1${new_version}/" appimage/*yml
sed -i -E "s/(\"version\"[[:space:]]*:[[:space:]]*\")${old_version_re}(\")/\1${new_version}\2/" flatpak/*json
