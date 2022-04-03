#!/bin/bash

function="checkout"

. ${VEBASE}/mk/git/git.sh

git fetch origin --tags $ref
git checkout $ref
