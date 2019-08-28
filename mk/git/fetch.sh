#!/bin/bash

function="fetch"

. ${BASE}/mk/git/git.sh

git fetch --all --tags
