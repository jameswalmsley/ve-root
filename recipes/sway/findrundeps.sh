#!/bin/bash

BINS=$(find out/sway/sysroot/ -type f -executable)

for bin in ${BINS}
do
        NOTFOUND=$(ldd ${bin} | grep found)
        if [[ "$NOTFOUND" == *"found"* ]]; then
                echo $bin has missing deps
                echo $NOTFOUND
        fi
done

