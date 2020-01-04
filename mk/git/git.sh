#!/bin/bash

repo=$(echo $1 | cut -d : -f1)
ref=$(echo $1 | cut -d : -f2)
repo_rel=$(realpath --relative-to ${BASE} ${repo})
layer=$(echo ${repo_rel} | cut -d/ -f3)
repo_name=$(echo ${repo_rel} | cut -d/ -f4)

cd ${repo}
