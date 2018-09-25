#!/usr/bin/env bash
export SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
echo "Running docker interactive now. To run the execute_tests.sh-script, just run the tst-command"
docker run -it --mount src="$SCRIPTPATH",target=/repo,type=bind --mount src="$SCRIPTPATH/docker/execute_tests.sh",target="/usr/bin/tst",type=bind texbuild:initial /bin/sh
