#!/bin/bash

function="unshallow"

. ${VEBASE}/mk/git/git.sh

git fetch --unshallow 2> /dev/null || true
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git fetch
