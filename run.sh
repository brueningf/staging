#!/usr/bin/env bash

docker build . -t staging
docker run --rm -it staging bash
