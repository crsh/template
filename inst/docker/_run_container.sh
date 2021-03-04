#!/bin/sh

docker build \
    --build-arg RSTUDIO_VERSION=1.3.1093 \
    -t ocrep .

docker run -d \
    -p 8787:8787 \
    -e DISABLE_AUTH=true \
    -e ROOT=TRUE \
    -v $(pwd):/home/rstudio \
    ocrep

sleep 1

open http://$(ipconfig getifaddr en0):8787
