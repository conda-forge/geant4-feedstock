#!/usr/bin/env bash
set -eux

cmake -G Ninja -B example-build -S "${PREFIX}/share/Geant4-10.7.4/examples/basic/B1" ${CMAKE_ARGS:-}
cmake --build example-build
cd example-build
./exampleB1 run2.mac
