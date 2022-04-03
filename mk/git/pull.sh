#!/bin/bash

function="pull"

. ${VEBASE}/mk/git/git.sh

echo ${layer} - ${repo_name}

git pull


true
