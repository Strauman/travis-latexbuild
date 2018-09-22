#!/usr/bin/env bash
docker run -it --mount src="`pwd`",target=/repo,type=bind --mount src="`pwd`/docker/execute_tests.sh",target="/usr/bin/tst",type=bind texbuild:initial /bin/sh
