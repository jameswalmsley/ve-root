#!/bin/bash

function="status"

. ${VEBASE}/mk/git/git.sh

describe=$(git describe --always --tags)

echo ${layer} - ${repo_name} ${describe}

