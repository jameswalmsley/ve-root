#!/bin/bash

repo=$(echo $1 | cut -d : -f1)
ref=$(echo $1 | cut -d : -f2)

echo ${function} - ${repo}

cd ${repo}
