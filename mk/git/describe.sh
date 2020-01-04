#!/bin/bash

function="status"

. ${BASE}/mk/git/git.sh

git describe --always --tags

