#!/bin/bash

function="submodule update"

. ${BASE}/mk/git/git.sh

git submodule sync
git submodule update --init --recursive
