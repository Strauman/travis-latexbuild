#!/usr/bin/env bash
export SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
docker run --mount src="$SCRIPTPATH",target=/repo,type=bind --mount src="$SCRIPTPATH/docker/execute_tests.sh",target="/usr/bin/tsts",type=bind texbuild:initial tsts
