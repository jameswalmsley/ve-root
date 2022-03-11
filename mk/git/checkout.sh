#!/bin/bash

function="checkout"

. ${BASE}/mk/git/git.sh

git fetch origin --tags $ref
git checkout $ref
