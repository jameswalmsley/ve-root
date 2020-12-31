#!/usr/bin/env python3

from packaging import version
import sys

if len(sys.argv) == 3:

    a = version.parse(sys.argv[1])
    b = version.parse(sys.argv[2])

    if a == b:
        print("eq")
        sys.exit(0)

    if a < b:
        print("lt")
        sys.exit(-1)

    if a > b:
        print("gt")
        sys.exit(1)

if len(sys.argv) == 4:

    a = version.parse(sys.argv[2])
    b = version.parse(sys.argv[3])

    if sys.argv[1] == "--gteq":
        if a >= b:
            print("y")
            sys.exit(0)
        else:
            print("n")
            sys.exit(1)


