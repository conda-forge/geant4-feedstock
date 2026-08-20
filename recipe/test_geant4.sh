#!/usr/bin/env bash
set -eux

geant4-config --version
geant4-config --prefix
geant4-config --libs
geant4-config --cflags

# The qt feature is what the two build variants differ in, so check that the
# package actually matches the variant it claims to be.
if [[ "${GEANT4_USE_QT}" == "ON" ]]; then
  test "$(geant4-config --has-feature qt)" = "yes"
else
  test "$(geant4-config --has-feature qt)" = "no"
fi

# Multithreading and the system CLHEP/expat/zlib are non-negotiable for this
# package, so guard against a silently reconfigured build.
test "$(geant4-config --has-feature multithreading)" = "yes"
test "$(geant4-config --has-feature hdf5)" = "yes"
test "$(geant4-config --has-feature gdml)" = "yes"

cmake -G Ninja -B test-build -S test_cmake ${CMAKE_ARGS:-}
cmake --build test-build
./test-build/geant4-conda-test
