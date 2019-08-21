#!/bin/bash

function="checkout"

. ${BASE}/mk/git/git.sh

git checkout $ref
