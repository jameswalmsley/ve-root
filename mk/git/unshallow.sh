#!/bin/bash

function="unshallow"

. ${VEBASE}/mk/git/git.sh

git fetch --unshallow || true
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git fetch
