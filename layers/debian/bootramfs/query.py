#!/usr/bin/python3

import os
import sys
import json

config=sys.argv[1]
command=sys.argv[2]
query=sys.argv[3]

with open(config) as f:
    data = json.load(f)

config=data

if sys.argv[2] == "json":
    print(eval(sys.argv[3]))

