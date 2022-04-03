#!/bin/bash

function="fetch"

. ${VEBASE}/mk/git/git.sh

git fetch --all --tags
