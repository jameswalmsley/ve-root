#!/bin/bash

function="rev-parse HEAD"

. ${VEBASE}/mk/git/git.sh

git rev-parse HEAD
