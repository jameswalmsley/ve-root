#!/bin/bash

function="rev-parse HEAD"

. ${BASE}/mk/git/git.sh

git rev-parse HEAD
