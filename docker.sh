#!/bin/bash
ARGS="$@"
make docker DOCKER_COMMAND="${ARGS}"
