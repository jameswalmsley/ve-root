#!/bin/bash

function="pull"

. ${BASE}/mk/git/git.sh

echo ${layer} - ${repo_name}

git pull


true
