#!/bin/bash

. ${VEBASE}/mk/git/git.sh


describe=$(git describe --always --tags)

echo GIT_${layer}_${repo_name}:=${describe}
