#!/usr/bin/env bash

docker build . -t bt-staging
docker run --rm -it bt-staging bash
