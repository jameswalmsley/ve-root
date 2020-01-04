#!/bin/bash

function="status"

. ${BASE}/mk/git/git.sh

describe=$(git describe --always --tags)

echo ${layer} - ${repo_name} ${describe}

