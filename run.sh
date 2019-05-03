#!/bin/bash
xhost + 127.0.0.1
docker run -ti        -e DISPLAY=host.docker.internal:0        jupyter-ros:update