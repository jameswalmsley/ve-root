strip_binary() {
    if [ $# -ne 2 ] ; then
        warning "strip_binary: Missing arguments"
        return 0
    fi
    local strip="$1"
    local bin="$2"

    file $bin | grep -q -P "(\bELF\b)|(\bPE\b)|(\bPE32\b)"
    if [ $? -eq 0 ]; then
        $strip $bin 2>/dev/null || true
    fi
}

STRIP_BINARIES=$(find $1)
for bin in $STRIP_BINARIES ; do
    strip_binary strip $bin
done