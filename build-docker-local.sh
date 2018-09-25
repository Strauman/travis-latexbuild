#!/usr/bin/env bash
docker build --build-arg scheme=small --rm --tag="texbuild:initial" docker/
