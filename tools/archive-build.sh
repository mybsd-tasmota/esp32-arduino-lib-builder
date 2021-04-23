#!/bin/bash

IDF_COMMIT=$(git -C "$IDF_PATH" rev-parse --short HEAD)
IDF_BRANCH=$(git -C "$IDF_PATH" symbolic-ref --short HEAD)

idf_version_string=${IDF_BRANCH//\//_}"-$IDF_COMMIT"
archive_path="dist/arduino-esp32-libs-$idf_version_string.tar.gz"
build_archive_path="dist/arduino-esp32-build-$idf_version_string.tar.gz"
pio_archive_path="dist/framework-arduinoespressif32-$idf_version_string.tar.gz"

mkdir -p dist && rm -rf "$archive_path" "$build_archive_path"

if [ -d "out" ]; then
    cd out
    #echo "Show files folder: esp32-arduino-lib-builder/components/arduino/tools/sdk"
    #ls -R /home/runner/work/esp32-arduino-lib-builder/esp32-arduino-lib-builder/components/arduino/tools/sdk
    echo "Creating framework-arduinoespressif32"
    git clone https://github.com/espressif/arduino-esp32
    rm -rf arduino-esp32/tools/sdk
    rm -rf arduino-esp32/docs
    cp -Rf /home/runner/work/esp32-arduino-lib-builder/esp32-arduino-lib-builder/components/arduino/tools/sdk arduino-esp32/tools/sdk
    cp ../core_version.h arduino-esp32/cores/esp32/core_version.h
    mv arduino-esp32/ framework-arduinoespressif32/
    tar --exclude=.* -zcf ../$pio_archive_path framework-arduinoespressif32/
    cd ..
fi
