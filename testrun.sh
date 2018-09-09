#!/usr/bin/env bash
docker run --mount src="`pwd`/tests",target=/src,type=bind --mount src="`pwd`/execute_tests.sh",target="/usr/bin/tsts",type=bind texbuild:initial tsts
