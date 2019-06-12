#!/bin/bash


cd usr/lib/${MULTIARCH}
SYMLINK_LIBS=$(ls -la | grep '^l' | sed -E -e 's/[[:blank:]]+/,/g' | grep ',->,/')

set -e

for lib in ${SYMLINK_LIBS}; do
    SRC=$(echo ${lib} | cut -d, -f9)
    DEST=$(echo ${lib} | cut -d, -f11)


    echo "${SRC} -> ${DEST} :: $(basename ${DEST})"

    rm ${SRC}
    ln -s $(basename ${DEST}) ${SRC}
done
