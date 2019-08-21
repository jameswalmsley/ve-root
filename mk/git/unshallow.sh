#!/bin/bash

function="unshallow"

. ${BASE}/mk/git/git.sh

git fetch --unshallow &> /dev/null || true
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git fetch
