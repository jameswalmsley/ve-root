#!/bin/bash

function="submodule update"

. ${VEBASE}/mk/git/git.sh

git submodule sync
git submodule update --init --recursive
