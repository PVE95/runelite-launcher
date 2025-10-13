#!/bin/bash

set -e

echo Launcher sha256sum
sha256sum build/libs/LuzoxPK.jar

pushd native
cmake -DCMAKE_TOOLCHAIN_FILE=arm64-linux-gcc.cmake -B build-aarch64 .
cmake --build build-aarch64 --config Release
popd

umask 022

source .jdk-versions.sh

rm -rf build/linux-aarch64
mkdir -p build/linux-aarch64

if ! [ -f linux_aarch64_jre.tar.gz ] ; then
    curl -Lo linux_aarch64_jre.tar.gz $LINUX_AARCH64_LINK
fi

echo "$LINUX_AARCH64_CHKSUM linux_aarch64_jre.tar.gz" | sha256sum -c

# Note: Host umask may have checked out this directory with g/o permissions blank
chmod -R u=rwX,go=rX appimage
# ...ditto for the build process
chmod 644 build/libs/LuzoxPK.jar

cp native/build-aarch64/src/LuzoxPK build/linux-aarch64/
cp build/libs/LuzoxPK.jar build/linux-aarch64/
cp packr/linux-aarch64-config.json build/linux-aarch64/config.json
cp build/filtered-resources/runelite.desktop build/linux-aarch64/
cp appimage/runelite.png build/linux-aarch64/
mkdir -p build/linux-aarch64/usr/share/icons/hicolor/128x128/apps/
cp appimage/runelite.png build/linux-aarch64/usr/share/icons/hicolor/128x128/apps/

tar zxf linux_aarch64_jre.tar.gz
mv jdk-$LINUX_AMD64_VERSION-jre build/linux-aarch64/jre

pushd build/linux-aarch64
mkdir -p jre/lib/amd64/server/
ln -s ../../server/libjvm.so jre/lib/amd64/server/ # packr looks for libjvm at this hardcoded path

# Symlink AppRun -> LuzoxPK
ln -s LuzoxPK AppRun

# Ensure LuzoxPK is executable to all users
chmod 755 LuzoxPK
popd

curl -z appimagetool-x86_64.AppImage -o appimagetool-x86_64.AppImage -L https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage
curl -z runtime-aarch64 -o runtime-aarch64 -L https://github.com/AppImage/type2-runtime/releases/download/continuous/runtime-aarch64

chmod +x appimagetool-x86_64.AppImage

./appimagetool-x86_64.AppImage \
	--runtime-file runtime-aarch64 \
	build/linux-aarch64/ \
	LuzoxPK-aarch64.AppImage